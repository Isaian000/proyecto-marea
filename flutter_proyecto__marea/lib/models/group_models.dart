import 'package:flutter/material.dart';

class TopicComment {
  const TopicComment({
    required this.author,
    required this.initials,
    required this.time,
    required this.text,
    required this.color,
  });

  final String author;
  final String initials;
  final String time;
  final String text;
  final Color color;
}

class Topic {
  const Topic({
    required this.title,
    required this.author,
    required this.time,
    required this.text,
    required this.replies,
    required this.votes,
    this.comments = const [],
  });

  final String title;
  final String author;
  final String time;
  final String text;
  final int replies;
  final int votes;
  final List<TopicComment> comments;
}

class ChatMessage {
  const ChatMessage({
    required this.text,
    required this.isMine,
    this.author = '',
  });

  final String text;
  final bool isMine;
  final String author;
}
