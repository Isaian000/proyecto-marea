import 'package:cloud_firestore/cloud_firestore.dart';

import 'jalisco_centers_catalog.dart';

Future<int> importCareCenters(
  FirebaseFirestore firestore, {
  required List<JaliscoCenterSeed> items,
  String collectionName = 'care_centers',
}) async {
  const int chunkSize = 400;
  var imported = 0;

  for (var i = 0; i < items.length; i += chunkSize) {
    final end = (i + chunkSize < items.length) ? i + chunkSize : items.length;
    final chunk = items.sublist(i, end);

    final batch = firestore.batch();
    for (final center in chunk) {
      final docRef = firestore.collection(collectionName).doc(center.id);
      batch.set(
        docRef,
        center.toFirestoreMap(),
        SetOptions(merge: true),
      );
    }

    await batch.commit();
    imported += chunk.length;
  }

  return imported;
}