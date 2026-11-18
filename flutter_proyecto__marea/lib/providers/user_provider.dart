import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../services/auth_service.dart';
import '../services/photo_service.dart';
import '../services/user_service.dart';

// Mantiene los datos del usuario con sesión iniciada.
// Las pantallas lo leen con context.watch<UserProvider>().user
class UserProvider extends ChangeNotifier {
  UserProvider() {
    // Sin Firebase inicializado (por ejemplo en los tests) no hace nada.
    if (Firebase.apps.isEmpty) return;
    _authSub = AuthService.authStateChanges().listen(_onAuthChanged);
  }

  StreamSubscription<User?>? _authSub;
  StreamSubscription<AppUser?>? _userSub;
  StreamSubscription<String>? _tokenSub;

  AppUser? _user;
  String? _uid;
  String? _photoPath;
  bool _loading = false;
  String? _error;

  AppUser? get user => _user;
  bool get loading => _loading;
  String? get error => _error;

  // Ruta de la foto de perfil guardada en el teléfono, o null si no hay.
  String? get photoPath => _photoPath;

  String get initials => _user?.initials ?? '';

  Future<void> _onAuthChanged(User? firebaseUser) async {
    await _userSub?.cancel();
    await _tokenSub?.cancel();
    _userSub = null;
    _tokenSub = null;
    _error = null;
    _uid = firebaseUser?.uid;
    _photoPath = null;

    if (firebaseUser == null) {
      _user = null;
      _loading = false;
      notifyListeners();
      return;
    }

    _loading = true;
    notifyListeners();

    unawaited(_loadPhoto(firebaseUser.uid));

    _userSub = UserService.watchUser(firebaseUser.uid).listen(
      (user) {
        _user = user;
        _loading = false;
        notifyListeners();
        unawaited(_syncEmail(firebaseUser, user));
      },
      onError: (Object e) {
        debugPrint('Error al leer el usuario: $e');
        _error = 'No se pudieron cargar tus datos.';
        _loading = false;
        notifyListeners();
      },
    );

    // Registra el dispositivo en Firebase Cloud Messaging y guarda su ID.
    // No espera a nada más, para que una conexión lenta no lo detenga.
    _tokenSub = UserService.listenDeviceToken(firebaseUser.uid);

    // Crea el documento si es la primera vez (por ejemplo, con Google).
    // Con tiempo límite, para que una mala conexión no lo deje esperando.
    try {
      await UserService.ensureUser(
        firebaseUser,
      ).timeout(const Duration(seconds: 15));
    } catch (e) {
      debugPrint('No se pudo crear el usuario en Firestore: $e');
    }
  }

  Future<void> _loadPhoto(String uid) async {
    try {
      final path = await PhotoService.load(uid);
      if (_uid != uid) return;
      _photoPath = path;
      notifyListeners();
    } catch (e) {
      debugPrint('No se pudo cargar la foto de perfil: $e');
    }
  }

  // Abre la galería. Devuelve false si el usuario canceló.
  Future<bool> pickPhoto() async {
    final uid = _uid;
    if (uid == null) throw StateError('No hay un usuario con sesión iniciada.');
    final path = await PhotoService.pickFromGallery(uid);
    if (path == null) return false;
    _photoPath = path;
    notifyListeners();
    return true;
  }

  Future<void> removePhoto() async {
    final uid = _uid;
    if (uid == null) return;
    await PhotoService.remove(uid);
    _photoPath = null;
    notifyListeners();
  }

  // Cuando el usuario confirma un correo nuevo, Firebase Auth lo cambia;
  // aquí se copia también al documento de Firestore.
  Future<void> _syncEmail(User firebaseUser, AppUser? user) async {
    final authEmail = firebaseUser.email;
    if (user == null || authEmail == null || authEmail.isEmpty) return;
    if (user.email == authEmail) return;
    try {
      await UserService.updateProfile(firebaseUser.uid, {'email': authEmail});
    } catch (e) {
      debugPrint('No se pudo actualizar el correo en Firestore: $e');
    }
  }

  Future<void> updateProfile({
    String? nombre,
    String? apellido,
    String? pais,
    String? genero,
    String? ocupacion,
    String? direccion,
  }) async {
    final current = _user;
    if (current == null) {
      throw StateError('No hay un usuario con sesión iniciada.');
    }
    await UserService.updateProfile(current.uid, {
      if (nombre != null) 'nombre': nombre.trim(),
      if (apellido != null) 'apellido': apellido.trim(),
      'pais': ?pais,
      'genero': ?genero,
      'ocupacion': ?ocupacion?.trim(),
      'direccion': ?direccion?.trim(),
    });

    // También actualiza el nombre de la cuenta de Firebase Auth, que es el
    // que usan las pantallas que todavía leen AuthService.displayName.
    if (nombre != null || apellido != null) {
      final fullName =
          '${(nombre ?? current.nombre).trim()} ${(apellido ?? current.apellido).trim()}'
              .trim();
      try {
        await FirebaseAuth.instance.currentUser?.updateDisplayName(fullName);
      } catch (e) {
        debugPrint('No se pudo actualizar el nombre de la cuenta: $e');
      }
    }
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _userSub?.cancel();
    _tokenSub?.cancel();
    super.dispose();
  }
}
