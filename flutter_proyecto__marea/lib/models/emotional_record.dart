import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../core/app_colors.dart';

// Un registro del diario, guardado en users/{uid}/records/{id}.
// Hay un registro por día: su id es la fecha (por ejemplo 2026-11-18).
class EmotionalRecord {
  const EmotionalRecord({
    this.id = '',
    required this.date,
    required this.mood,
    this.note = '',
    this.energy,
    this.sleep,
    this.thoughts,
  });

  final String id;
  final DateTime date;
  // De 0 (muy bajo) a 1 (muy bien).
  final double mood;
  final String note;
  final String? energy;
  final String? sleep;
  final String? thoughts;

  static const energyOptions = ['Muy baja', 'Baja', 'Activa', 'Muy activa'];
  static const sleepOptions = [
    'No dormí casi nada',
    'Dormí poco',
    'Dormí lo necesario',
    'Dormí excelente',
  ];
  static const thoughtsOptions = [
    'Negativos',
    'Algo negativos',
    'Neutrales',
    'Positivos',
  ];

  String get moodLabel => labelForMood(mood);
  Color get color => colorForMood(mood);
  String get dayKey => keyForDay(date);

  static String labelForMood(double mood) {
    if (mood < .25) return 'Muy bajo';
    if (mood < .45) return 'Bajo';
    if (mood < .65) return 'Neutral';
    if (mood < .85) return 'Bien';
    return 'Muy bien';
  }

  static Color colorForMood(double mood) {
    if (mood < .25) return AppColors.blue;
    if (mood < .45) return const Color(0xFF829DB6);
    if (mood < .65) return const Color(0xFFBEAF8B);
    if (mood < .85) return AppColors.gold;
    return AppColors.orange;
  }

  static DateTime startOfDay(DateTime date) =>
      DateTime(date.year, date.month, date.day);

  static String keyForDay(DateTime date) =>
      '${date.year.toString().padLeft(4, '0')}-'
      '${date.month.toString().padLeft(2, '0')}-'
      '${date.day.toString().padLeft(2, '0')}';

  factory EmotionalRecord.fromMap(String id, Map<String, dynamic> data) {
    final rawDate = data['date'];
    final date = rawDate is Timestamp
        ? rawDate.toDate()
        : rawDate is DateTime
        ? rawDate
        : DateTime.now();
    final rawMood = data['mood'];
    return EmotionalRecord(
      id: id,
      date: startOfDay(date),
      mood: rawMood is num ? rawMood.clamp(0, 1).toDouble() : 0.5,
      note: data['note'] as String? ?? '',
      energy: data['energy'] as String?,
      sleep: data['sleep'] as String?,
      thoughts: data['thoughts'] as String?,
    );
  }

  // Los campos de seguimiento vacíos no se mandan, para no borrar los que
  // ya estaban guardados.
  Map<String, dynamic> toMap() => {
    'date': Timestamp.fromDate(startOfDay(date)),
    'mood': mood,
    'moodLabel': moodLabel,
    'note': note,
    'energy': ?energy,
    'sleep': ?sleep,
    'thoughts': ?thoughts,
  };

  EmotionalRecord copyWith({
    String? id,
    DateTime? date,
    double? mood,
    String? note,
    String? energy,
    String? sleep,
    String? thoughts,
  }) => EmotionalRecord(
    id: id ?? this.id,
    date: date ?? this.date,
    mood: mood ?? this.mood,
    note: note ?? this.note,
    energy: energy ?? this.energy,
    sleep: sleep ?? this.sleep,
    thoughts: thoughts ?? this.thoughts,
  );
}
