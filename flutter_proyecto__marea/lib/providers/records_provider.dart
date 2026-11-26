import 'package:flutter/foundation.dart';

import '../models/emotional_record.dart';
import '../services/auth_service.dart';
import '../services/records_service.dart';

// Registros del diario del usuario con sesión iniciada (el CRUD).
class RecordsProvider extends ChangeNotifier {
  RecordsProvider({
    RecordsRepository? repository,
    String? Function()? currentUid,
    DateTime Function()? clock,
  }) : _repository = repository ?? const FirestoreRecordsRepository(),
       _currentUid = currentUid ?? (() => AuthService.currentUser?.uid),
       _clock = clock ?? DateTime.now;

  final RecordsRepository _repository;
  final String? Function() _currentUid;
  final DateTime Function() _clock;

  List<EmotionalRecord> _items = [];
  bool _loading = false;
  String? _error;
  String? _loadedUid;

  // Del más nuevo al más viejo.
  List<EmotionalRecord> get items => List.unmodifiable(_items);
  bool get loading => _loading;
  String? get error => _error;

  DateTime get today => EmotionalRecord.startOfDay(_clock());

  EmotionalRecord? get todayRecord => byDay(today);

  EmotionalRecord? byDay(DateTime day) {
    final key = EmotionalRecord.keyForDay(day);
    for (final record in _items) {
      if (record.dayKey == key) return record;
    }
    return null;
  }

  EmotionalRecord? byId(String id) {
    for (final record in _items) {
      if (record.id == id) return record;
    }
    return null;
  }

  // Lee (o vuelve a leer, al deslizar hacia abajo) desde Firestore.
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
      _items = await _repository.fetchAll(uid);
      _sort();
    } catch (e) {
      debugPrint('No se pudieron cargar los registros: $e');
      _error = 'No se pudieron cargar tus registros.';
    }
    _loading = false;
    notifyListeners();
  }

  // Crea el registro de hoy o actualiza el que ya existe.
  Future<void> saveToday({required double mood, required String note}) {
    final base = todayRecord ?? EmotionalRecord(date: today, mood: mood);
    return _save(base.copyWith(mood: mood, note: note.trim()));
  }

  // Guarda energía, sueño y pensamientos en el registro de hoy.
  Future<void> saveTracking({
    required String energy,
    required String sleep,
    required String thoughts,
  }) {
    final base = todayRecord ?? EmotionalRecord(date: today, mood: 0.5);
    return _save(
      base.copyWith(energy: energy, sleep: sleep, thoughts: thoughts),
    );
  }

  Future<void> update(EmotionalRecord record) => _save(record);

  Future<void> delete(String id) async {
    final uid = _requireUid();
    await _repository.delete(uid, id);
    _items = _items.where((r) => r.id != id).toList();
    notifyListeners();
  }

  Future<void> _save(EmotionalRecord record) async {
    final uid = _requireUid();
    final saved = await _repository.save(uid, record);
    _items = [
      for (final r in _items)
        if (r.id != saved.id) r,
      saved,
    ];
    _sort();
    notifyListeners();
  }

  void _sort() => _items.sort((a, b) => b.date.compareTo(a.date));

  String _requireUid() {
    final uid = _currentUid();
    if (uid == null) throw StateError('No hay una sesión iniciada.');
    return uid;
  }
}
