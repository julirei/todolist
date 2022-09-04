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

  /// The datetime when the todolist was created
  final DateTime createdAt;

  /// The userid of the user who created the todolist
  final String userId;
}
