import 'package:flutter/foundation.dart';

import '../models/forum.dart';
import '../models/group_summary.dart';
import '../services/auth_service.dart';
import '../services/community_service.dart';

// Foros de la comunidad y los grupos del usuario con sesión iniciada.
class CommunityProvider extends ChangeNotifier {
  CommunityProvider({
    CommunityRepository? repository,
    String? Function()? currentUid,
  }) : _repository = repository ?? const FirestoreCommunityRepository(),
       _currentUid = currentUid ?? (() => AuthService.currentUser?.uid);

  final CommunityRepository _repository;
  final String? Function() _currentUid;

  List<Forum> _forums = [];
  List<GroupSummary> _myGroups = [];
  bool _loading = false;
  String? _error;

  List<Forum> get forums => List.unmodifiable(_forums);
  List<GroupSummary> get myGroups => List.unmodifiable(_myGroups);
  bool get loading => _loading;
  String? get error => _error;
  String? get uid => _currentUid();

  List<Forum> forumsIn(String category) =>
      _forums.where((f) => f.category == category).toList();

  // Lee (o vuelve a leer, al deslizar hacia abajo) desde Firestore.
  Future<void> load() async {
    final uid = _currentUid();
    _error = null;
    if (uid == null) {
      _forums = [];
      _myGroups = [];
      notifyListeners();
      return;
    }

    _loading = true;
    notifyListeners();
    try {
      final results = await Future.wait([
        _repository.fetchForums(),
        _repository.fetchMyGroups(uid),
      ]);
      _forums = results[0] as List<Forum>;
      _myGroups = results[1] as List<GroupSummary>;
    } catch (e) {
      debugPrint('No se pudo cargar la comunidad: $e');
      _error = 'No se pudo cargar la comunidad.';
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> join(Forum forum) async {
    final uid = _requireUid();
    if (forum.isMember(uid)) return;
    await _repository.joinForum(uid, forum);
    _replace(forum.copyWith(memberIds: [...forum.memberIds, uid]));
    // El grupo ligado ahora aparece en "Mis grupos".
    try {
      _myGroups = await _repository.fetchMyGroups(uid);
    } catch (e) {
      debugPrint('No se pudieron recargar los grupos: $e');
    }
    notifyListeners();
  }

  Future<void> requestAccess(Forum forum) async {
    final uid = _requireUid();
    if (forum.hasRequested(uid)) return;
    await _repository.requestAccess(uid, forum);
    _replace(forum.copyWith(requestIds: [...forum.requestIds, uid]));
    notifyListeners();
  }

  void _replace(Forum updated) {
    _forums = [for (final f in _forums) f.id == updated.id ? updated : f];
  }

  String _requireUid() {
    final uid = _currentUid();
    if (uid == null) throw StateError('No hay una sesión iniciada.');
    return uid;
  }
}
