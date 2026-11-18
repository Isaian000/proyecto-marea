import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';

import '../models/app_user.dart';
import '../services/auth_service.dart';
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
  bool _loading = false;
  String? _error;

  AppUser? get user => _user;
  bool get loading => _loading;
  String? get error => _error;

  Future<void> _onAuthChanged(User? firebaseUser) async {
    await _userSub?.cancel();
    await _tokenSub?.cancel();
    _userSub = null;
    _tokenSub = null;
    _error = null;

    if (firebaseUser == null) {
      _user = null;
      _loading = false;
      notifyListeners();
      return;
    }

    _loading = true;
    notifyListeners();

    _userSub = UserService.watchUser(firebaseUser.uid).listen(
      (user) {
        _user = user;
        _loading = false;
        notifyListeners();
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

  Future<void> updateProfile({
    String? nombre,
    String? apellido,
    String? pais,
    String? genero,
  }) async {
    final uid = _user?.uid;
    if (uid == null) return;
    await UserService.updateProfile(uid, {
      if (nombre != null) 'nombre': nombre.trim(),
      if (apellido != null) 'apellido': apellido.trim(),
      'pais': ?pais,
      'genero': ?genero,
    });
  }

  @override
  void dispose() {
    _authSub?.cancel();
    _userSub?.cancel();
    _tokenSub?.cancel();
    super.dispose();
  }
}
