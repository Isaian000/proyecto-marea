import 'package:flutter/material.dart';

import '../core/app_colors.dart';

// Un foro de la comunidad, guardado en forums/{id}.
// Al unirse, el uid se agrega a memberIds del foro y del grupo ligado (groupId).
// En foros privados, la solicitud agrega el uid a requestIds.
class Forum {
  const Forum({
    required this.id,
    required this.name,
    required this.category,
    this.subtitle = '',
    this.introTitle = '',
    this.question = '',
    this.description = '',
    this.isPublic = true,
    this.groupId,
    this.order = 0,
    this.memberIds = const [],
    this.requestIds = const [],
  });

  final String id;
  final String name;
  // ansiedad | depresion | social
  final String category;
  final String subtitle;
  final String introTitle;
  final String question;
  final String description;
  final bool isPublic;
  final String? groupId;
  final int order;
  final List<String> memberIds;
  final List<String> requestIds;

  static const categories = ['ansiedad', 'depresion', 'social'];
  static const categoryLabels = ['Ansiedad', 'Depresión', 'Social'];

  Color get color => colorForCategory(category);
  int get memberCount => memberIds.length;

  bool isMember(String? uid) => uid != null && memberIds.contains(uid);
  bool hasRequested(String? uid) => uid != null && requestIds.contains(uid);

  static Color colorForCategory(String category) {
    switch (category) {
      case 'depresion':
        return AppColors.blue;
      case 'social':
        return AppColors.gold;
      default:
        return AppColors.slate;
    }
  }

  factory Forum.fromMap(String id, Map<String, dynamic> map) {
    return Forum(
      id: id,
      name: map['name'] as String? ?? '',
      category: map['category'] as String? ?? 'ansiedad',
      subtitle: map['subtitle'] as String? ?? '',
      introTitle: map['introTitle'] as String? ?? '',
      question: map['question'] as String? ?? '',
      description: map['description'] as String? ?? '',
      isPublic: map['isPublic'] as bool? ?? true,
      groupId: map['groupId'] as String?,
      order: (map['order'] as num?)?.toInt() ?? 0,
      memberIds: List<String>.from(map['memberIds'] as List? ?? const []),
      requestIds: List<String>.from(map['requestIds'] as List? ?? const []),
    );
  }

  Map<String, dynamic> toMap() => {
    'name': name,
    'category': category,
    'subtitle': subtitle,
    'introTitle': introTitle,
    'question': question,
    'description': description,
    'isPublic': isPublic,
    'groupId': groupId,
    'order': order,
    'memberIds': memberIds,
    'requestIds': requestIds,
  };

  Forum copyWith({List<String>? memberIds, List<String>? requestIds}) {
    return Forum(
      id: id,
      name: name,
      category: category,
      subtitle: subtitle,
      introTitle: introTitle,
      question: question,
      description: description,
      isPublic: isPublic,
      groupId: groupId,
      order: order,
      memberIds: memberIds ?? this.memberIds,
      requestIds: requestIds ?? this.requestIds,
    );
  }
}
