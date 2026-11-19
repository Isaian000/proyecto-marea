import 'package:flutter/material.dart';

import 'forum.dart';

// Lo que necesita "Mis grupos" de un grupo guardado en groups/{id}.
// El contenido del grupo (temas, chat, recursos) vive en sus subcolecciones.
class GroupSummary {
  const GroupSummary({
    required this.id,
    required this.name,
    required this.topic,
    required this.category,
    this.description = '',
    this.isPublic = true,
    this.memberIds = const [],
  });

  final String id;
  final String name;
  final String topic;
  // ansiedad | depresion | social (define el color)
  final String category;
  final String description;
  final bool isPublic;
  final List<String> memberIds;

  Color get color => Forum.colorForCategory(category);
  int get memberCount => memberIds.length;

  String get membersLabel =>
      memberCount == 1 ? '1 integrante' : '$memberCount integrantes';

  factory GroupSummary.fromMap(String id, Map<String, dynamic> map) {
    return GroupSummary(
      id: id,
      name: map['name'] as String? ?? '',
      topic: map['topic'] as String? ?? '',
      category: map['category'] as String? ?? 'ansiedad',
      description: map['description'] as String? ?? '',
      isPublic: map['isPublic'] as bool? ?? true,
      memberIds: List<String>.from(map['memberIds'] as List? ?? const []),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'topic': topic,
    'category': category,
    'description': description,
    'isPublic': isPublic,
    'memberIds': memberIds,
  };
}
