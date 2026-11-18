import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

enum NotificationSection { hoy, ayer, anteriores }

extension NotificationSectionLabel on NotificationSection {
  String get label => switch (this) {
    NotificationSection.hoy => 'Hoy',
    NotificationSection.ayer => 'Ayer',
    NotificationSection.anteriores => 'Anteriores',
  };
}

// Notificación guardada en users/{uid}/notifications/{id}.
class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.type,
    required this.read,
    required this.createdAt,
  });

  final String id;
  final String title;
  final String body;
  // diario | foros | comentarios | logro | sistema
  final String type;
  final bool read;
  final DateTime createdAt;

  IconData get icon => iconForType(type);

  static IconData iconForType(String type) => switch (type) {
    'diario' => Icons.monitor_heart_outlined,
    'foros' => Icons.people_outline,
    'comentarios' => Icons.chat_bubble_outline,
    'logro' => Icons.check,
    _ => Icons.notifications_none,
  };

  factory AppNotification.fromMap(String id, Map<String, dynamic> data) {
    final created = data['createdAt'];
    return AppNotification(
      id: id,
      title: data['title'] as String? ?? '',
      body: data['body'] as String? ?? '',
      type: data['type'] as String? ?? 'sistema',
      read: data['read'] as bool? ?? false,
      // Si la fecha aún no llega del servidor, se toma como recién creada.
      createdAt: created is Timestamp
          ? created.toDate()
          : created is DateTime
          ? created
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() => {
    'title': title,
    'body': body,
    'type': type,
    'read': read,
    'createdAt': Timestamp.fromDate(createdAt),
  };

  AppNotification copyWith({bool? read}) => AppNotification(
    id: id,
    title: title,
    body: body,
    type: type,
    read: read ?? this.read,
    createdAt: createdAt,
  );

  // En qué grupo de la pantalla va según su fecha.
  static NotificationSection sectionFor(DateTime date, DateTime now) {
    final today = DateTime(now.year, now.month, now.day);
    final day = DateTime(date.year, date.month, date.day);
    final days = (today.difference(day).inHours / 24).round();
    if (days <= 0) return NotificationSection.hoy;
    if (days == 1) return NotificationSection.ayer;
    return NotificationSection.anteriores;
  }

  // Agrupa respetando el orden de la lista (de la más nueva a la más vieja).
  static Map<NotificationSection, List<AppNotification>> group(
    List<AppNotification> items,
    DateTime now,
  ) {
    final groups = <NotificationSection, List<AppNotification>>{};
    for (final item in items) {
      groups.putIfAbsent(sectionFor(item.createdAt, now), () => []).add(item);
    }
    return groups;
  }
}
