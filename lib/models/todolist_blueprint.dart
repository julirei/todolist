import 'package:flutter/material.dart';

/// A blueprint for creating a new [TodoList].
@immutable
class TodoListBlueprint {
  const TodoListBlueprint({
    required this.title,
    required this.createdAt,
    required this.userId,
  });

  /// The todolists title.
  final String title;

  /// The datetime when the todolist was created
  final DateTime createdAt;

  /// The userid of the user who created the todolist
  final String userId;
}
