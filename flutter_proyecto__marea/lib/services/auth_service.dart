import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../firebase_options.dart';

// Todo lo de Firebase Auth en un solo lugar para que las pantallas
// solo llamen a estas funciones.
class AuthService {
  AuthService._();

  static FirebaseAuth get _auth => FirebaseAuth.instance;

  static final GoogleSignIn _google = GoogleSignIn(
    // En iOS se usa el client ID que generó flutterfire; en Android se ignora.
    clientId: defaultTargetPlatform == TargetPlatform.iOS
        ? DefaultFirebaseOptions.ios.iosClientId
        : null,
  );

  // Sin Firebase inicializado (por ejemplo en los tests) no hay usuario.
  static User? get currentUser =>
      Firebase.apps.isEmpty ? null : _auth.currentUser;

  // Nombre para mostrar: el de la cuenta o, si no hay, lo de antes del @.
  static String get displayName {
    final user = currentUser;
    final name = user?.displayName?.trim() ?? '';
    if (name.isNotEmpty) return name;
    return (user?.email ?? '').split('@').first;
  }

  static String get initials => displayName
      .split(RegExp(r'\s+'))
      .where((p) => p.isNotEmpty)
      .take(2)
      .map((p) => p[0].toUpperCase())
      .join();

  // Avisa cada vez que alguien inicia o cierra sesión.
  static Stream<User?> authStateChanges() => _auth.authStateChanges();

  static Future<void> signIn(String email, String password) {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  static Future<void> register({
    required String name,
    required String email,
    required String password,
  }) async {
    final cred = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
    await cred.user?.updateDisplayName(name.trim());
    await cred.user?.sendEmailVerification();
  }

  // Devuelve false si el usuario cerró el selector de cuentas sin elegir.
  static Future<bool> signInWithGoogle() async {
    final account = await _google.signIn();
    if (account == null) return false;
    final tokens = await account.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: tokens.accessToken,
      idToken: tokens.idToken,
    );
    await _auth.signInWithCredential(credential);
    return true;
  }

  static Future<void> sendPasswordReset(String email) {
    return _auth.sendPasswordResetEmail(email: email.trim());
  }

  static Future<void> sendEmailVerification() async {
    await _auth.currentUser?.sendEmailVerification();
  }

  // Vuelve a pedir los datos del usuario para saber si ya verificó su correo.
  static Future<bool> reloadEmailVerified() async {
    await _auth.currentUser?.reload();
    return _auth.currentUser?.emailVerified ?? false;
  }

  static Future<void> signOut() async {
    await _google.signOut();
    await _auth.signOut();
  }

  static Future<void> deleteAccount() async {
    await _auth.currentUser?.delete();
    await _google.signOut();
  }

  static bool get usesPassword =>
      currentUser?.providerData.any((p) => p.providerId == 'password') ?? false;

  // Traduce los errores de Firebase a mensajes para el usuario.
  static String errorMessage(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-email':
          return 'El correo no es válido.';
        case 'user-not-found':
        case 'wrong-password':
        case 'invalid-credential':
          return 'Correo o contraseña incorrectos.';
        case 'email-already-in-use':
          return 'Ya existe una cuenta con ese correo.';
        case 'weak-password':
          return 'La contraseña debe tener al menos 6 caracteres.';
        case 'too-many-requests':
          return 'Demasiados intentos. Espera un momento.';
        case 'network-request-failed':
          return 'Sin conexión a internet.';
        case 'requires-recent-login':
          return 'Por seguridad, cierra sesión, vuelve a entrar e inténtalo de nuevo.';
        case 'account-exists-with-different-credential':
          return 'Ese correo ya está registrado con otro método de acceso.';
      }
      return error.message ?? 'Ocurrió un error. Inténtalo de nuevo.';
    }
    return 'Ocurrió un error. Inténtalo de nuevo.';
  }
}
