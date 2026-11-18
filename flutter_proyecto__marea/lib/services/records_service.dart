import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/emotional_record.dart';

// Operaciones del diario. Se separa en una clase abstracta para poder probar
// el provider sin Firebase.
abstract class RecordsRepository {
  Future<List<EmotionalRecord>> fetchAll(String uid);
  Future<EmotionalRecord> save(String uid, EmotionalRecord record);
  Future<void> delete(String uid, String id);
}

class FirestoreRecordsRepository implements RecordsRepository {
  const FirestoreRecordsRepository();

  CollectionReference<Map<String, dynamic>> _records(String uid) =>
      FirebaseFirestore.instance
          .collection('users')
          .doc(uid)
          .collection('records');

  @override
  Future<List<EmotionalRecord>> fetchAll(String uid) async {
    final snap = await _records(
      uid,
    ).orderBy('date', descending: true).get();
    return snap.docs
        .map((doc) => EmotionalRecord.fromMap(doc.id, doc.data()))
        .toList();
  }

  // Crea o actualiza. Un registro nuevo usa la fecha como id.
  @override
  Future<EmotionalRecord> save(String uid, EmotionalRecord record) async {
    final id = record.id.isEmpty ? record.dayKey : record.id;
    await _records(uid).doc(id).set({
      ...record.toMap(),
      'updatedAt': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
    return record.copyWith(id: id);
  }

  @override
  Future<void> delete(String uid, String id) {
    return _records(uid).doc(id).delete();
  }
}
