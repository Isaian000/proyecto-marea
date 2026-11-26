import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Modo oscuro de toda la app. Se guarda en el teléfono para recordarlo
// la próxima vez que se abra la app.
class ThemeProvider extends ChangeNotifier {
  ThemeProvider() {
    _load();
  }

  static const _key = 'darkMode';

  bool _isDark = true;

  bool get isDark => _isDark;

  ThemeMode get themeMode => _isDark ? ThemeMode.dark : ThemeMode.light;

  Future<void> _load() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final saved = prefs.getBool(_key);
      if (saved != null && saved != _isDark) {
        _isDark = saved;
        notifyListeners();
      }
    } catch (e) {
      debugPrint('No se pudo leer el modo oscuro: $e');
    }
  }

  Future<void> setDark(bool value) async {
    _isDark = value;
    notifyListeners();
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool(_key, value);
    } catch (e) {
      debugPrint('No se pudo guardar el modo oscuro: $e');
    }
  }
}
