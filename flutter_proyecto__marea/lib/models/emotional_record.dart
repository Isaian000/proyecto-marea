import 'package:flutter/material.dart';

// datos de un registro del diario
class EmotionalRecord {
  const EmotionalRecord({
    required this.date,
    required this.mood,
    required this.moodLabel,
    required this.note,
    required this.color,
    this.energy = 'Activa',
    this.sleep = 'Dormí lo necesario',
    this.thoughts = 'Neutrales',
  });

  final DateTime date;
  final double mood;
  final String moodLabel;
  final String note;
  final Color color;
  final String energy;
  final String sleep;
  final String thoughts;
}
