import 'package:flutter/foundation.dart';

import '../models/app_notification.dart';
import '../services/auth_service.dart';
import '../services/notification_service.dart';

// Lista de notificaciones del usuario con sesión iniciada.
class NotificationsProvider extends ChangeNotifier {
  NotificationsProvider({
    NotificationRepository? repository,
    String? Function()? currentUid,
  }) : _repository = repository ?? const FirestoreNotificationRepository(),
       _currentUid = currentUid ?? (() => AuthService.currentUser?.uid);

  final NotificationRepository _repository;
  final String? Function() _currentUid;

  List<AppNotification> _items = [];
  bool _loading = false;
  String? _error;
  String? _loadedUid;

  List<AppNotification> get items => List.unmodifiable(_items);
  bool get loading => _loading;
  String? get error => _error;
  int get unreadCount => _items.where((n) => !n.read).length;

  // Carga (o recarga, al deslizar hacia abajo) desde Firestore.
  Future<void> load() async {
    final uid = _currentUid();
    if (uid != _loadedUid) _items = [];
    _loadedUid = uid;
    _error = null;

    if (uid == null) {
      notifyListeners();
      return;
    }

    _loading = true;
    notifyListeners();
    try {
      _items = await _repository.fetch(uid);
    } catch (e) {
      debugPrint('No se pudieron cargar las notificaciones: $e');
      _error = 'No se pudieron cargar las notificaciones.';
    }
    _loading = false;
    notifyListeners();
  }

  Future<void> markAsRead(String id) async {
    final uid = _currentUid();
    final index = _items.indexWhere((n) => n.id == id);
    if (uid == null || index < 0 || _items[index].read) return;

    _setRead({id}, true);
    try {
      await _repository.markAsRead(uid, id);
    } catch (e) {
      _setRead({id}, false);
      rethrow;
    }
  }

  Future<void> markAllAsRead() async {
    final uid = _currentUid();
    final ids = _items.where((n) => !n.read).map((n) => n.id).toSet();
    if (uid == null || ids.isEmpty) return;

    _setRead(ids, true);
    try {
      await _repository.markAllAsRead(uid, ids.toList());
    } catch (e) {
      _setRead(ids, false);
      rethrow;
    }
  }

  void _setRead(Set<String> ids, bool read) {
    _items = [
      for (final n in _items) ids.contains(n.id) ? n.copyWith(read: read) : n,
    ];
    notifyListeners();
  }
}
