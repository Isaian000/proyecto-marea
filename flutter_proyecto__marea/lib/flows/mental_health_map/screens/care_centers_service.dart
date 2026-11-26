import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';
import 'package:geolocator/geolocator.dart';

import 'care_center.dart';

class CareCentersService {
  CareCentersService({FirebaseFirestore? firestore})
      : _firestore = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _firestore;

  static const String collectionName = 'care_centers';

  /// Radio máximo en metros (ej. 25000 m = 25 km). Usa `null` para no filtrar por distancia.
  Future<List<CareCenter>> searchNearby({
    required double lat,
    required double lng,
    double? maxRadiusMeters = 150000,
  }) async {
    try {
      final snapshot = await _firestore.collection(collectionName).get();

      final allCenters = <CareCenter>[];
      for (final doc in snapshot.docs) {
        final data = doc.data();
        final name = data['name']?.toString().trim();
        final pLat = (data['lat'] as num?)?.toDouble();
        final pLng = (data['lng'] as num?)?.toDouble();

        if (name == null || name.isEmpty || pLat == null || pLng == null) {
          continue;
        }

        final distance = Geolocator.distanceBetween(lat, lng, pLat, pLng);
        if (maxRadiusMeters != null && distance > maxRadiusMeters) {
          continue;
        }

        allCenters.add(
          CareCenter(
            id: doc.id,
            name: name,
            address: data['address']?.toString(),
            phone: data['phone']?.toString(),
            lat: pLat,
            lng: pLng,
            distanceMeters: distance,
          ),
        );
      }

      allCenters.sort((a, b) => a.distanceMeters.compareTo(b.distanceMeters));
      return allCenters;
    } catch (e, st) {
      debugPrint('Error leyendo $collectionName desde Firestore: $e\n$st');
      rethrow;
    }
  }
}