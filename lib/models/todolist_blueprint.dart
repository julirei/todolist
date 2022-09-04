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

  final DateTime createdAt;

  final String userId;
}
