import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Foto de perfil guardada solo en el teléfono (no en Firebase).
// La imagen se copia a la carpeta de la app y su ruta se guarda con
// shared_preferences, una por cada cuenta.
class PhotoService {
  PhotoService._();

  static String storageKey(String uid) => 'profilePhoto_$uid';

  // Cada foto nueva lleva la hora en el nombre para que Flutter no muestre
  // la imagen anterior que tenía guardada en memoria.
  static String fileNameFor(String uid, DateTime time, String extension) =>
      'profile_${uid}_${time.millisecondsSinceEpoch}$extension';

  // Devuelve la ruta de la foto guardada, o null si no hay o ya no existe.
  static Future<String?> load(String uid) async {
    if (kIsWeb) return null;
    final prefs = await SharedPreferences.getInstance();
    final path = prefs.getString(storageKey(uid));
    if (path == null) return null;
    if (!await File(path).exists()) {
      await prefs.remove(storageKey(uid));
      return null;
    }
    return path;
  }

  // Abre la galería. Devuelve la ruta nueva, o null si el usuario canceló.
  static Future<String?> pickFromGallery(String uid) async {
    if (kIsWeb) return null;
    final picked = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 800,
      maxHeight: 800,
      imageQuality: 85,
    );
    if (picked == null) return null;

    final dot = picked.name.lastIndexOf('.');
    final extension = dot >= 0 ? picked.name.substring(dot) : '.jpg';
    final dir = await getApplicationDocumentsDirectory();
    final newPath =
        '${dir.path}${Platform.pathSeparator}'
        '${fileNameFor(uid, DateTime.now(), extension)}';
    await File(picked.path).copy(newPath);

    return save(uid, newPath);
  }

  // Guarda la ruta de la foto y borra la anterior.
  static Future<String> save(String uid, String newPath) async {
    final prefs = await SharedPreferences.getInstance();
    final oldPath = prefs.getString(storageKey(uid));
    await prefs.setString(storageKey(uid), newPath);
    if (oldPath != null && oldPath != newPath) await _deleteFile(oldPath);
    return newPath;
  }

  static Future<void> remove(String uid) async {
    final prefs = await SharedPreferences.getInstance();
    final oldPath = prefs.getString(storageKey(uid));
    await prefs.remove(storageKey(uid));
    if (oldPath != null) await _deleteFile(oldPath);
  }

  static Future<void> _deleteFile(String path) async {
    try {
      final file = File(path);
      if (await file.exists()) await file.delete();
    } catch (e) {
      debugPrint('No se pudo borrar la foto anterior: $e');
    }
  }
}
