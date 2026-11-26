import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/app_notification.dart';

CollectionReference<Map<String, dynamic>> _notifications(String uid) =>
    FirebaseFirestore.instance
        .collection('users')
        .doc(uid)
        .collection('notifications');

// Lo que necesita la pantalla de notificaciones. Se separa en una clase
// abstracta para poder probar el provider sin Firebase.
abstract class NotificationRepository {
  Future<List<AppNotification>> fetch(String uid);
  Future<void> markAsRead(String uid, String id);
  Future<void> markAllAsRead(String uid, List<String> ids);
}

class FirestoreNotificationRepository implements NotificationRepository {
  const FirestoreNotificationRepository();

  @override
  Future<List<AppNotification>> fetch(String uid) async {
    final snap = await _notifications(
      uid,
    ).orderBy('createdAt', descending: true).limit(50).get();
    return snap.docs
        .map((doc) => AppNotification.fromMap(doc.id, doc.data()))
        .toList();
  }

  @override
  Future<void> markAsRead(String uid, String id) {
    return _notifications(uid).doc(id).update({'read': true});
  }

  @override
  Future<void> markAllAsRead(String uid, List<String> ids) {
    final batch = FirebaseFirestore.instance.batch();
    for (final id in ids) {
      batch.update(_notifications(uid).doc(id), {'read': true});
    }
    return batch.commit();
  }
}

// Para crear notificaciones desde cualquier parte de la app, por ejemplo
// cuando alguien comenta en un foro:
//   NotificationService.create(uid, title: 'Foros', body: '...', type: 'foros');
class NotificationService {
  NotificationService._();

  static const welcomeId = 'bienvenida';

  static Future<void> create(
    String uid, {
    required String title,
    required String body,
    String type = 'sistema',
    String? id,
  }) async {
    final data = {
      'title': title,
      'body': body,
      'type': type,
      'read': false,
      'createdAt': FieldValue.serverTimestamp(),
    };
    if (id == null) {
      await _notifications(uid).add(data);
    } else {
      await _notifications(uid).doc(id).set(data);
    }
  }

  static Map<String, dynamic> welcomeData() => {
    'title': 'Bienvenida',
    'body':
        'Gracias por unirte a Marea. Registra cada día cómo te sientes en tu diario.',
    'type': 'sistema',
    'read': false,
    'createdAt': FieldValue.serverTimestamp(),
  };

  static DocumentReference<Map<String, dynamic>> welcomeRef(String uid) =>
      _notifications(uid).doc(welcomeId);

  static Future<void> createWelcome(String uid) =>
      welcomeRef(uid).set(welcomeData());
}
