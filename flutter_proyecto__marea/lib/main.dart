import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'app.dart';
import 'firebase_options.dart';
// Ajusta esta ruta según la ubicación real de tu archivo:
// import 'flows/mental_health_map/screens/firestore_seed_data.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  if (kDebugMode) {
    try {
      // Descomenta cuando importes firestore_seed_data.dart:
      // await seedJaliscoCareCenters(FirebaseFirestore.instance);
    } catch (e) {
      debugPrint('No se pudo ejecutar seedJaliscoCareCenters: $e');
    }
  }

  runApp(const MareaApp());
}