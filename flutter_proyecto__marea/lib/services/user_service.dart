import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';

import '../models/app_user.dart';

// Todo lo que se lee o se guarda del usuario en Firestore (users/{uid}).
class UserService {
  UserService._();

  static DocumentReference<Map<String, dynamic>> _doc(String uid) =>
      FirebaseFirestore.instance.collection('users').doc(uid);

  // Guarda los datos del formulario de registro.
  static Future<void> saveProfile(
    String uid, {
    required String nombre,
    required String apellido,
    required String email,
    String? pais,
    String? genero,
  }) {
    return _doc(uid).set({
      'nombre': nombre.trim(),
      'apellido': apellido.trim(),
      'email': email.trim(),
      'pais': pais,
      'genero': genero,
      'createdAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Crea el documento la primera vez que alguien entra (por ejemplo con
  // Google, donde no hay formulario de registro). Si ya existe, no lo toca.
  // Se usa una transacción para no pisar lo que guarda saveProfile.
  static Future<void> ensureUser(User user) {
    final ref = _doc(user.uid);
    return FirebaseFirestore.instance.runTransaction((tx) async {
      final snap = await tx.get(ref);
      if (snap.exists) return;
      final parts = (user.displayName ?? '')
          .trim()
          .split(RegExp(r'\s+'))
          .where((p) => p.isNotEmpty)
          .toList();
      tx.set(ref, {
        'nombre': parts.isNotEmpty ? parts.first : '',
        'apellido': parts.length > 1 ? parts.sublist(1).join(' ') : '',
        'email': user.email ?? '',
        'pais': null,
        'genero': null,
        'createdAt': FieldValue.serverTimestamp(),
      });
    });
  }

  // Avisa cada vez que cambian los datos del usuario en Firestore.
  static Stream<AppUser?> watchUser(String uid) {
    return _doc(uid).snapshots().map((snap) {
      final data = snap.data();
      return data == null ? null : AppUser.fromMap(uid, data);
    });
  }

  static Future<void> updateProfile(String uid, Map<String, dynamic> data) {
    return _doc(uid).set({
      ...data,
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  // Token del dispositivo: Firebase Cloud Messaging ahora identifica cada
  // dispositivo con su Installation ID (FID), que llega por onRegistered.
  // Se guarda en el campo fcmToken cada vez que llega uno nuevo.
  // Si el dispositivo no lo soporta (por ejemplo Windows), solo avisa en
  // consola y la app sigue funcionando.
  static StreamSubscription<String>? listenDeviceToken(String uid) {
    try {
      debugPrint('Registrando el dispositivo para notificaciones...');
      final messaging = FirebaseMessaging.instance;
      // Hay que escuchar antes de llamar a register().
      final sub = messaging.onRegistered.listen(
        (id) => saveToken(uid, id),
        onError: (Object e) =>
            debugPrint('No se pudo obtener el token del dispositivo: $e'),
      );
      unawaited(_register(messaging));
      return sub;
    } catch (e) {
      debugPrint('Este dispositivo no soporta notificaciones: $e');
      return null;
    }
  }

  static Future<void> _register(FirebaseMessaging messaging) async {
    try {
      await messaging.requestPermission();
      await messaging.register();
    } catch (e) {
      debugPrint('No se pudo registrar el dispositivo: $e');
    }
  }

  static Future<void> saveToken(String uid, String token) async {
    await _doc(uid).set({
      'fcmToken': token,
      'tokenUpdatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    debugPrint('Token del dispositivo guardado en Firestore.');
  }
}
