import 'package:flutter/material.dart';

@immutable
class TodoList {
  const TodoList({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.userId,
  });

  /// The TodoLists id.
  final String id;

  /// The TodoLists title.
  final String title;

  final DateTime createdAt;

  final String userId;
}
