import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/forum.dart';
import '../models/group_summary.dart';
import 'notification_service.dart';

// Operaciones de Comunidad (foros y "Mis grupos"). Se separa en una clase
// abstracta para poder probar el provider sin Firebase.
abstract class CommunityRepository {
  Future<List<Forum>> fetchForums();
  Future<List<GroupSummary>> fetchMyGroups(String uid);
  Future<void> joinForum(String uid, Forum forum);
  Future<void> requestAccess(String uid, Forum forum);
}

class FirestoreCommunityRepository implements CommunityRepository {
  const FirestoreCommunityRepository();

  FirebaseFirestore get _db => FirebaseFirestore.instance;
  CollectionReference<Map<String, dynamic>> get _forums =>
      _db.collection('forums');
  CollectionReference<Map<String, dynamic>> get _groups =>
      _db.collection('groups');

  @override
  Future<List<Forum>> fetchForums() async {
    var snap = await _forums.get();
    if (snap.docs.isEmpty) {
      await _seed();
      snap = await _forums.get();
    }
    final forums = snap.docs
        .map((doc) => Forum.fromMap(doc.id, doc.data()))
        .toList();
    forums.sort((a, b) => a.order.compareTo(b.order));
    return forums;
  }

  @override
  Future<List<GroupSummary>> fetchMyGroups(String uid) async {
    final snap = await _groups.where('memberIds', arrayContains: uid).get();
    final groups = snap.docs
        .map((doc) => GroupSummary.fromMap(doc.id, doc.data()))
        .toList();
    groups.sort((a, b) => a.name.compareTo(b.name));
    return groups;
  }

  // Se une al foro y al grupo ligado en una sola escritura.
  @override
  Future<void> joinForum(String uid, Forum forum) async {
    final batch = _db.batch();
    batch.update(_forums.doc(forum.id), {
      'memberIds': FieldValue.arrayUnion([uid]),
    });
    final groupId = forum.groupId;
    if (groupId != null && groupId.isNotEmpty) {
      batch.set(_groups.doc(groupId), {
        'memberIds': FieldValue.arrayUnion([uid]),
      }, SetOptions(merge: true));
    }
    await batch.commit();
    await NotificationService.create(
      uid,
      title: 'Foros',
      body: 'Te uniste a ${forum.name}. Ya aparece en Mis grupos.',
      type: 'foros',
    );
  }

  @override
  Future<void> requestAccess(String uid, Forum forum) async {
    await _forums.doc(forum.id).update({
      'requestIds': FieldValue.arrayUnion([uid]),
    });
    await NotificationService.create(
      uid,
      title: 'Foros',
      body: 'Enviaste una solicitud para unirte a ${forum.name}.',
      type: 'foros',
    );
  }

  // La primera vez que se abre Comunidad crea los foros y grupos iniciales.
  // Los grupos se escriben con merge para no borrar lo que ya tengan.
  Future<void> _seed() async {
    final batch = _db.batch();
    for (final forum in seedForums) {
      batch.set(_forums.doc(forum.id), {
        ...forum.toMap(),
        'createdAt': FieldValue.serverTimestamp(),
      });
    }
    for (final group in seedGroups) {
      final data = group.toMap()..remove('memberIds');
      batch.set(_groups.doc(group.id), {
        ...data,
        'createdAt': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    }
    await batch.commit();
  }
}

// Datos iniciales: los mismos foros y grupos que antes estaban fijos.
const seedGroups = [
  GroupSummary(
    id: 'ansiedad',
    name: 'Grupo Ansiedad',
    topic: 'Ansiedad',
    category: 'ansiedad',
    isPublic: true,
  ),
  GroupSummary(
    id: 'ansiedad-social',
    name: 'Grupo Ansiedad Social',
    topic: 'Ansiedad Social',
    category: 'social',
    isPublic: false,
  ),
  GroupSummary(
    id: 'depresion',
    name: 'Grupo Depresión',
    topic: 'Depresión',
    category: 'depresion',
    isPublic: false,
  ),
];

const _intro = {
  'ansiedad': (
    name: 'Foro de ansiedad',
    subtitle: 'Para platicar sobre la ansiedad',
    title: 'Hablemos de ansiedad',
    question: '¿Te has sentido abrumado, con pensamientos que no se detienen o con una constante sensación de inquietud?',
    description: 'No estás solo. Te invitamos a un espacio seguro donde podrás compartir, escuchar y aprender sobre la ansiedad junto a otras personas que te comprenden. Hablar de lo que sentimos es el primer paso para sanar.',
    group: 'ansiedad',
  ),
  'depresion': (
    name: 'Foro de depresión',
    subtitle: 'Para platicar sobre la depresión',
    title: 'Hablemos de depresión',
    question: 'A veces la tristeza pesa más de lo que podemos expresar.',
    description: 'Si te has sentido sin energía, desmotivado o desconectado de todo, queremos que sepas que no estás solo. Este foro es un espacio empático y seguro para hablar sobre la depresión y encontrar apoyo real.',
    group: 'depresion',
  ),
  'social': (
    name: 'Foro de ansiedad social',
    subtitle: 'Para platicar sobre ansiedad social',
    title: 'Hablemos de estrés social',
    question: '¿Te cuesta hablar en público, iniciar conversaciones o sentirte cómodo en reuniones sociales?',
    description: 'La ansiedad social puede ser muy difícil, pero no tienes que afrontarla solo. Te invitamos a un espacio de comprensión y apoyo donde podrás compartir tus experiencias con personas que te entienden.',
    group: 'ansiedad-social',
  ),
};

// Por categoría: foro 1 público, foro 2 público solo en ansiedad, foro 3 privado.
List<Forum> get seedForums => [
  for (final (c, category) in Forum.categories.indexed)
    for (var i = 1; i <= 3; i++)
      Forum(
        id: '$category-$i',
        name: '${_intro[category]!.name} $i',
        category: category,
        subtitle: _intro[category]!.subtitle,
        introTitle: _intro[category]!.title,
        question: _intro[category]!.question,
        description: _intro[category]!.description,
        isPublic: i == 1 || (i == 2 && category == 'ansiedad'),
        groupId: _intro[category]!.group,
        order: c * 10 + i,
      ),
];
