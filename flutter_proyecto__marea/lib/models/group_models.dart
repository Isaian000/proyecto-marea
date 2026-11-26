import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../core/app_colors.dart';

// Modelos del contenido de un grupo (groups/{groupId}/...).

DateTime _readDate(Object? value) => value is Timestamp
    ? value.toDate()
    : value is DateTime
    ? value
    : DateTime.now();

// "Ahora", "Hace 5 min", "Hace 2 h", "Hace 3 d".
String relativeTime(DateTime date, [DateTime? now]) {
  final diff = (now ?? DateTime.now()).difference(date);
  if (diff.inMinutes < 1) return 'Ahora';
  if (diff.inMinutes < 60) return 'Hace ${diff.inMinutes} min';
  if (diff.inHours < 24) return 'Hace ${diff.inHours} h';
  return 'Hace ${diff.inDays} d';
}

String initialsOf(String name) {
  final parts = name.trim().split(RegExp(r'\s+')).where((p) => p.isNotEmpty);
  final letters = parts.take(2).map((p) => p[0].toUpperCase()).join();
  return letters.isEmpty ? '?' : letters;
}

// Color fijo por persona, para que su avatar siempre se vea igual.
Color colorForPerson(String id) {
  const palette = [slate, gold, sand, blue, teal, orange];
  return palette[id.hashCode.abs() % palette.length];
}

// groups/{groupId}/topics/{topicId}
class Topic {
  const Topic({
    required this.id,
    required this.title,
    required this.text,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
    this.commentCount = 0,
    this.voterIds = const [],
  });

  final String id;
  final String title;
  final String text;
  final String authorId;
  final String authorName;
  final DateTime createdAt;
  final int commentCount;
  final List<String> voterIds;

  String get author => authorName;
  String get time => relativeTime(createdAt);
  int get replies => commentCount;
  int get votes => voterIds.length;
  bool votedBy(String? uid) => uid != null && voterIds.contains(uid);

  factory Topic.fromMap(String id, Map<String, dynamic> data) => Topic(
    id: id,
    title: data['title'] as String? ?? '',
    text: data['text'] as String? ?? '',
    authorId: data['authorId'] as String? ?? '',
    authorName: data['authorName'] as String? ?? 'Anónimo',
    createdAt: _readDate(data['createdAt']),
    commentCount: (data['commentCount'] as num?)?.toInt() ?? 0,
    voterIds: List<String>.from(data['voterIds'] as List? ?? const []),
  );

  Map<String, dynamic> toMap() => {
    'title': title,
    'text': text,
    'authorId': authorId,
    'authorName': authorName,
    'createdAt': Timestamp.fromDate(createdAt),
    'commentCount': commentCount,
    'voterIds': voterIds,
  };

  Topic copyWith({int? commentCount, List<String>? voterIds}) => Topic(
    id: id,
    title: title,
    text: text,
    authorId: authorId,
    authorName: authorName,
    createdAt: createdAt,
    commentCount: commentCount ?? this.commentCount,
    voterIds: voterIds ?? this.voterIds,
  );
}

// groups/{groupId}/topics/{topicId}/comments/{commentId}
class TopicComment {
  const TopicComment({
    required this.id,
    required this.text,
    required this.authorId,
    required this.authorName,
    required this.createdAt,
  });

  final String id;
  final String text;
  final String authorId;
  final String authorName;
  final DateTime createdAt;

  String get author => authorName;
  String get initials => initialsOf(authorName);
  String get time => relativeTime(createdAt);
  Color get color => colorForPerson(authorId);

  factory TopicComment.fromMap(String id, Map<String, dynamic> data) =>
      TopicComment(
        id: id,
        text: data['text'] as String? ?? '',
        authorId: data['authorId'] as String? ?? '',
        authorName: data['authorName'] as String? ?? 'Anónimo',
        createdAt: _readDate(data['createdAt']),
      );
}

// groups/{groupId}/messages/{id} (chat del grupo) y
// groups/{groupId}/directChats/{uidA_uidB}/messages/{id} (chat entre dos).
class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.isMine,
    this.author = '',
    this.id = '',
    this.authorId = '',
    this.createdAt,
  });

  final String text;
  final bool isMine;
  final String author;
  final String id;
  final String authorId;
  final DateTime? createdAt;

  factory ChatMessage.fromMap(
    String id,
    Map<String, dynamic> data,
    String? myUid,
  ) {
    final authorId = data['authorId'] as String? ?? '';
    return ChatMessage(
      id: id,
      text: data['text'] as String? ?? '',
      authorId: authorId,
      author: data['authorName'] as String? ?? '',
      isMine: myUid != null && authorId == myUid,
      createdAt: _readDate(data['createdAt']),
    );
  }
}

// groups/{groupId}/members/{uid}: datos públicos de cada integrante.
class GroupMember {
  const GroupMember({
    required this.uid,
    required this.name,
    required this.lastSeen,
  });

  final String uid;
  final String name;
  final DateTime lastSeen;

  String get initials => initialsOf(name);
  Color get color => colorForPerson(uid);
  bool get online => DateTime.now().difference(lastSeen).inMinutes < 15;
  String get status =>
      online ? 'Activo ahora' : 'Activo ${relativeTime(lastSeen).toLowerCase()}';

  factory GroupMember.fromMap(String uid, Map<String, dynamic> data) =>
      GroupMember(
        uid: uid,
        name: data['name'] as String? ?? 'Integrante',
        lastSeen: _readDate(data['lastSeen']),
      );
}

// groups/{groupId}/resources/{id}
// body usa líneas sencillas: "## Título", "- viñeta" o texto normal.
class GroupResource {
  const GroupResource({
    required this.id,
    required this.title,
    required this.description,
    required this.body,
    this.order = 0,
  });

  final String id;
  final String title;
  final String description;
  final String body;
  final int order;

  factory GroupResource.fromMap(String id, Map<String, dynamic> data) =>
      GroupResource(
        id: id,
        title: data['title'] as String? ?? '',
        description: data['description'] as String? ?? '',
        body: data['body'] as String? ?? '',
        order: (data['order'] as num?)?.toInt() ?? 0,
      );

  Map<String, dynamic> toMap() => {
    'title': title,
    'description': description,
    'body': body,
    'order': order,
  };
}

// Promedio de groups/{groupId}/reviews/{uid} y la calificación propia.
class ReviewSummary {
  const ReviewSummary({this.average = 0, this.count = 0, this.myRating});

  final double average;
  final int count;
  final int? myRating;

  static ReviewSummary fromRatings(Map<String, int> ratingsByUid, String? uid) {
    if (ratingsByUid.isEmpty) return const ReviewSummary();
    final total = ratingsByUid.values.fold<int>(0, (a, b) => a + b);
    return ReviewSummary(
      average: total / ratingsByUid.length,
      count: ratingsByUid.length,
      myRating: uid == null ? null : ratingsByUid[uid],
    );
  }
}
