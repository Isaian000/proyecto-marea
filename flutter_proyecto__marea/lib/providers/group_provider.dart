import 'package:flutter/foundation.dart';

import '../models/group_models.dart';
import '../models/group_summary.dart';
import '../services/auth_service.dart';
import '../services/group_service.dart';

// Contenido de un grupo abierto: temas, recursos, integrantes y reseñas.
// Se crea al abrir el grupo y lo comparten sus pantallas.
class GroupProvider extends ChangeNotifier {
  GroupProvider({
    required this.group,
    GroupRepository? repository,
    String? Function()? currentUid,
    String Function()? currentName,
  }) : _repository = repository ?? const FirestoreGroupRepository(),
       _currentUid = currentUid ?? (() => AuthService.currentUser?.uid),
       _currentName = currentName ?? (() => AuthService.displayName);

  final GroupSummary group;
  final GroupRepository _repository;
  final String? Function() _currentUid;
  final String Function() _currentName;

  List<Topic> _topics = [];
  List<GroupResource> _resources = [];
  List<GroupMember> _members = [];
  ReviewSummary _reviews = const ReviewSummary();
  bool _loading = false;
  String? _error;

  List<Topic> get topics => List.unmodifiable(_topics);
  List<GroupResource> get resources => List.unmodifiable(_resources);
  ReviewSummary get reviews => _reviews;
  bool get loading => _loading;
  String? get error => _error;
  String? get uid => _currentUid();

  String get myName {
    final name = _currentName().trim();
    return name.isEmpty ? 'Integrante' : name;
  }

  // Integrantes sin contarme a mí.
  List<GroupMember> get otherMembers =>
      _members.where((m) => m.uid != uid).toList();

  int get memberCount => _members.length;

  Topic? topicById(String id) {
    for (final t in _topics) {
      if (t.id == id) return t;
    }
    return null;
  }

  // Lee (o vuelve a leer, al deslizar hacia abajo) desde Firestore.
  Future<void> load() async {
    final uid = _currentUid();
    _error = null;
    if (uid == null) {
      notifyListeners();
      return;
    }

    _loading = true;
    notifyListeners();
    try {
      // Me registro como integrante para aparecer en la zona de interacción.
      await _repository.saveMember(group.id, uid, myName);
      final results = await Future.wait([
        _repository.fetchTopics(group.id),
        _repository.fetchResources(group.id),
        _repository.fetchMembers(group.id),
        _repository.fetchReviews(group.id, uid),
      ]);
      _topics = results[0] as List<Topic>;
      _resources = results[1] as List<GroupResource>;
      _members = results[2] as List<GroupMember>;
      _reviews = results[3] as ReviewSummary;
    } catch (e) {
      debugPrint('No se pudo cargar el grupo: $e');
      _error = 'No se pudo cargar el grupo.';
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> createTopic({required String title, required String text}) async {
    final uid = _requireUid();
    final created = await _repository.createTopic(
      group.id,
      Topic(
        id: '',
        title: title.trim(),
        text: text.trim(),
        authorId: uid,
        authorName: myName,
        createdAt: DateTime.now(),
      ),
    );
    _topics = [created, ..._topics];
    notifyListeners();
  }

  Future<void> toggleVote(Topic topic) async {
    final uid = _requireUid();
    final vote = !topic.votedBy(uid);
    final voters = vote
        ? [...topic.voterIds, uid]
        : topic.voterIds.where((v) => v != uid).toList();
    _replaceTopic(topic.copyWith(voterIds: voters));
    try {
      await _repository.setVote(group.id, topic.id, uid, vote);
    } catch (e) {
      _replaceTopic(topic);
      rethrow;
    }
  }

  Stream<List<TopicComment>> comments(String topicId) =>
      _repository.watchComments(group.id, topicId);

  Future<void> addComment(Topic topic, String text) async {
    final uid = _requireUid();
    await _repository.addComment(
      group.id,
      topic.id,
      uid: uid,
      name: myName,
      text: text.trim(),
    );
    final current = topicById(topic.id) ?? topic;
    _replaceTopic(current.copyWith(commentCount: current.commentCount + 1));
  }

  Future<void> rate(int rating) async {
    final uid = _requireUid();
    await _repository.rate(group.id, uid, rating);
    _reviews = await _repository.fetchReviews(group.id, uid);
    notifyListeners();
  }

  // null = chat general del grupo.
  Stream<List<ChatMessage>> messages({String? withUid}) => _repository
      .watchMessages(group.id, _chatId(withUid), _currentUid());

  Future<void> sendMessage(String text, {String? withUid}) {
    final uid = _requireUid();
    return _repository.sendMessage(
      group.id,
      _chatId(withUid),
      uid: uid,
      name: myName,
      text: text.trim(),
    );
  }

  String? _chatId(String? withUid) {
    final uid = _currentUid();
    if (withUid == null || uid == null) return null;
    return directChatIdFor(uid, withUid);
  }

  void _replaceTopic(Topic updated) {
    _topics = [for (final t in _topics) t.id == updated.id ? updated : t];
    notifyListeners();
  }

  String _requireUid() {
    final uid = _currentUid();
    if (uid == null) throw StateError('No hay una sesión iniciada.');
    return uid;
  }
}
