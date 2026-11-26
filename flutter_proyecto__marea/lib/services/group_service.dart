import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/group_models.dart';

// Todo lo que se lee y se guarda dentro de un grupo (groups/{groupId}/...).
// Se separa en una clase abstracta para poder probar el provider sin Firebase.
abstract class GroupRepository {
  Future<List<Topic>> fetchTopics(String groupId);
  Future<Topic> createTopic(String groupId, Topic topic);
  Future<void> setVote(String groupId, String topicId, String uid, bool vote);
  Stream<List<TopicComment>> watchComments(String groupId, String topicId);
  Future<void> addComment(
    String groupId,
    String topicId, {
    required String uid,
    required String name,
    required String text,
  });
  Future<List<GroupResource>> fetchResources(String groupId);
  Future<List<GroupMember>> fetchMembers(String groupId);
  Future<void> saveMember(String groupId, String uid, String name);
  Future<ReviewSummary> fetchReviews(String groupId, String? uid);
  Future<void> rate(String groupId, String uid, int rating);
  Stream<List<ChatMessage>> watchMessages(
    String groupId,
    String? directChatId,
    String? myUid,
  );
  Future<void> sendMessage(
    String groupId,
    String? directChatId, {
    required String uid,
    required String name,
    required String text,
  });
}

class FirestoreGroupRepository implements GroupRepository {
  const FirestoreGroupRepository();

  DocumentReference<Map<String, dynamic>> _group(String id) =>
      FirebaseFirestore.instance.collection('groups').doc(id);

  CollectionReference<Map<String, dynamic>> _topics(String groupId) =>
      _group(groupId).collection('topics');

  // null = chat general del grupo; si no, chat entre dos personas.
  CollectionReference<Map<String, dynamic>> _messages(
    String groupId,
    String? directChatId,
  ) => directChatId == null
      ? _group(groupId).collection('messages')
      : _group(
          groupId,
        ).collection('directChats').doc(directChatId).collection('messages');

  @override
  Future<List<Topic>> fetchTopics(String groupId) async {
    var snap = await _topics(
      groupId,
    ).orderBy('createdAt', descending: true).get();
    if (snap.docs.isEmpty) {
      await _seedTopics(groupId);
      snap = await _topics(groupId).orderBy('createdAt', descending: true).get();
    }
    return snap.docs.map((d) => Topic.fromMap(d.id, d.data())).toList();
  }

  @override
  Future<Topic> createTopic(String groupId, Topic topic) async {
    final ref = await _topics(groupId).add({
      ...topic.toMap(),
      'createdAt': FieldValue.serverTimestamp(),
    });
    return Topic(
      id: ref.id,
      title: topic.title,
      text: topic.text,
      authorId: topic.authorId,
      authorName: topic.authorName,
      createdAt: topic.createdAt,
    );
  }

  @override
  Future<void> setVote(String groupId, String topicId, String uid, bool vote) {
    return _topics(groupId).doc(topicId).update({
      'voterIds': vote
          ? FieldValue.arrayUnion([uid])
          : FieldValue.arrayRemove([uid]),
    });
  }

  @override
  Stream<List<TopicComment>> watchComments(String groupId, String topicId) {
    return _topics(groupId)
        .doc(topicId)
        .collection('comments')
        .orderBy('createdAt')
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => TopicComment.fromMap(d.id, d.data()))
              .toList(),
        );
  }

  @override
  Future<void> addComment(
    String groupId,
    String topicId, {
    required String uid,
    required String name,
    required String text,
  }) async {
    final topic = _topics(groupId).doc(topicId);
    final batch = FirebaseFirestore.instance.batch();
    batch.set(topic.collection('comments').doc(), {
      'text': text,
      'authorId': uid,
      'authorName': name,
      'createdAt': FieldValue.serverTimestamp(),
    });
    batch.update(topic, {'commentCount': FieldValue.increment(1)});
    await batch.commit();
  }

  @override
  Future<List<GroupResource>> fetchResources(String groupId) async {
    final col = _group(groupId).collection('resources');
    var snap = await col.get();
    if (snap.docs.isEmpty) {
      final batch = FirebaseFirestore.instance.batch();
      for (final r in seedResources) {
        batch.set(col.doc(r.id), {
          ...r.toMap(),
          'createdAt': FieldValue.serverTimestamp(),
        });
      }
      await batch.commit();
      snap = await col.get();
    }
    final list = snap.docs
        .map((d) => GroupResource.fromMap(d.id, d.data()))
        .toList();
    list.sort((a, b) => a.order.compareTo(b.order));
    return list;
  }

  @override
  Future<List<GroupMember>> fetchMembers(String groupId) async {
    final snap = await _group(
      groupId,
    ).collection('members').orderBy('lastSeen', descending: true).get();
    return snap.docs.map((d) => GroupMember.fromMap(d.id, d.data())).toList();
  }

  @override
  Future<void> saveMember(String groupId, String uid, String name) {
    return _group(groupId).collection('members').doc(uid).set({
      'name': name,
      'lastSeen': FieldValue.serverTimestamp(),
    }, SetOptions(merge: true));
  }

  @override
  Future<ReviewSummary> fetchReviews(String groupId, String? uid) async {
    final snap = await _group(groupId).collection('reviews').get();
    final ratings = <String, int>{
      for (final d in snap.docs)
        d.id: (d.data()['rating'] as num?)?.toInt() ?? 0,
    };
    ratings.removeWhere((_, value) => value < 1 || value > 5);
    return ReviewSummary.fromRatings(ratings, uid);
  }

  @override
  Future<void> rate(String groupId, String uid, int rating) {
    return _group(groupId).collection('reviews').doc(uid).set({
      'rating': rating,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  @override
  Stream<List<ChatMessage>> watchMessages(
    String groupId,
    String? directChatId,
    String? myUid,
  ) {
    return _messages(groupId, directChatId)
        .orderBy('createdAt')
        .limitToLast(100)
        .snapshots()
        .map(
          (snap) => snap.docs
              .map((d) => ChatMessage.fromMap(d.id, d.data(), myUid))
              .toList(),
        );
  }

  @override
  Future<void> sendMessage(
    String groupId,
    String? directChatId, {
    required String uid,
    required String name,
    required String text,
  }) {
    return _messages(groupId, directChatId).add({
      'text': text,
      'authorId': uid,
      'authorName': name,
      'createdAt': FieldValue.serverTimestamp(),
    });
  }

  // Temas para iniciar la conversación la primera vez que se abre el grupo.
  Future<void> _seedTopics(String groupId) async {
    final batch = FirebaseFirestore.instance.batch();
    for (final t in starterTopics) {
      batch.set(_topics(groupId).doc(), {
        ...t.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    await batch.commit();
  }
}

// Id del chat entre dos personas: los dos uid ordenados.
String directChatIdFor(String uidA, String uidB) {
  final ids = [uidA, uidB]..sort();
  return ids.join('_');
}

final starterTopics = [
  Topic(
    id: '',
    title: 'Preséntate con el grupo',
    text:
        'Cuéntanos un poco de ti y qué te trajo aquí. Puedes compartir solo '
        'lo que te haga sentir cómodo.',
    authorId: 'marea',
    authorName: 'Equipo Marea',
    createdAt: DateTime(2026),
  ),
  Topic(
    id: '',
    title: '¿Qué te ayuda en un día difícil?',
    text:
        'Compartamos cosas pequeñas que nos ayudan cuando el día se pone '
        'pesado: una canción, una caminata, una persona.',
    authorId: 'marea',
    authorName: 'Equipo Marea',
    createdAt: DateTime(2026),
  ),
];

const seedResources = [
  GroupResource(
    id: 'que-es-la-ansiedad',
    order: 1,
    title: '¿Qué es la ansiedad generalizada?',
    description:
        'Qué significa vivir con ansiedad constante, sus causas, síntomas y '
        'cómo buscar ayuda profesional.',
    body: '''## ¿Qué es?
La ansiedad generalizada es una preocupación excesiva, persistente y difícil de controlar sobre aspectos cotidianos como la salud, la escuela, el trabajo o la familia.
## Síntomas frecuentes
- Inquietud constante o tensión
- Dificultad para concentrarse
- Cansancio
- Problemas para dormir
## ¿Cuándo buscar ayuda?
Si los síntomas interfieren con tu vida diaria y causan malestar continuo, acude con un profesional de salud mental. No estás solo.''',
  ),
  GroupResource(
    id: 'respiracion',
    order: 2,
    title: 'Respiración para momentos difíciles',
    description:
        'Un ejercicio de respiración sencillo para recuperar la calma en '
        'pocos minutos.',
    body: '''## Respiración 4-7-8
- Inhala por la nariz contando hasta 4
- Sostén el aire contando hasta 7
- Exhala por la boca contando hasta 8
- Repite 4 veces
## Consejo
Practícalo cuando estés tranquilo, así te será más fácil usarlo en un momento difícil.''',
  ),
  GroupResource(
    id: 'ataque-de-panico',
    order: 3,
    title: '¿Qué hacer en un ataque de pánico?',
    description:
        'Pasos breves para recuperar el control en situaciones difíciles.',
    body: '''## Recuerda
Un ataque de pánico se siente muy intenso, pero pasa. Normalmente baja en unos minutos.
## Qué hacer
- Busca un lugar seguro donde puedas sentarte
- Respira lento, alargando la exhalación
- Nombra 5 cosas que ves, 4 que tocas y 3 que escuchas
- Si se repite seguido, platícalo con un profesional''',
  ),
  GroupResource(
    id: 'hablar-con-otros',
    order: 4,
    title: '¿Cómo hablar de lo que sientes con los demás?',
    description:
        'Consejos para comunicarte con familia y amigos sin sentir culpa ni '
        'vergüenza.',
    body: '''## Antes de hablar
Elige a alguien de confianza y un momento tranquilo.
## Ideas para empezar
- "Últimamente me he sentido..."
- "No necesito que me des una solución, solo que me escuches"
- "Me ayudaría que..."
## Recuerda
Pedir apoyo es una muestra de fortaleza.''',
  ),
];
