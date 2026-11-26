import 'package:flutter/material.dart';

import '../models/emotional_record.dart';

// Cálculos de la pantalla Patrones y de la semana en Hoy.
class MoodStats {
  MoodStats._();

  static const _pluralDays = [
    'lunes',
    'martes',
    'miércoles',
    'jueves',
    'viernes',
    'sábados',
    'domingos',
  ];

  static DateTime mondayOf(DateTime date) =>
      DateTime(date.year, date.month, date.day - (date.weekday - 1));

  static Map<String, EmotionalRecord> _byDay(List<EmotionalRecord> records) =>
      {for (final r in records) r.dayKey: r};

  // Registro de cada día de la semana actual, de lunes a domingo.
  static List<EmotionalRecord?> week(
    List<EmotionalRecord> records,
    DateTime today,
  ) {
    final byDay = _byDay(records);
    final monday = mondayOf(today);
    return [
      for (var i = 0; i < 7; i++)
        byDay[EmotionalRecord.keyForDay(
          DateTime(monday.year, monday.month, monday.day + i),
        )],
    ];
  }

  // Las últimas 4 semanas completas, de lunes a domingo (28 días).
  static List<EmotionalRecord?> lastFourWeeks(
    List<EmotionalRecord> records,
    DateTime today,
  ) {
    final byDay = _byDay(records);
    final monday = mondayOf(today);
    final start = DateTime(monday.year, monday.month, monday.day - 21);
    return [
      for (var i = 0; i < 28; i++)
        byDay[EmotionalRecord.keyForDay(
          DateTime(start.year, start.month, start.day + i),
        )],
    ];
  }

  // Promedio de ánimo por día de la semana (lunes = 0).
  static List<double?> weekdayAverages(List<EmotionalRecord> records) {
    final sums = List<double>.filled(7, 0);
    final counts = List<int>.filled(7, 0);
    for (final r in records) {
      sums[r.date.weekday - 1] += r.mood;
      counts[r.date.weekday - 1]++;
    }
    return [for (var i = 0; i < 7; i++) counts[i] == 0 ? null : sums[i] / counts[i]];
  }

  // Frase de "Patrón detectado". Null si todavía no hay datos suficientes.
  static String? patternSummary(List<EmotionalRecord> records) {
    if (records.length < 3) return null;
    final averages = weekdayAverages(records);
    int? best;
    int? worst;
    for (var i = 0; i < 7; i++) {
      final value = averages[i];
      if (value == null) continue;
      if (best == null || value > averages[best]!) best = i;
      if (worst == null || value < averages[worst]!) worst = i;
    }
    if (best == null || worst == null || best == worst) return null;
    return 'Sueles sentirte mejor los ${_pluralDays[best]} '
        'y más bajo los ${_pluralDays[worst]}.';
  }

  static Color? colorOf(EmotionalRecord? record) => record?.color;
}
