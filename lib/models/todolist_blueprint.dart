import 'package:flutter/material.dart';

/// A blueprint for creating a new [TodoList].
@immutable
class TodoListBlueprint {
  const TodoListBlueprint({
    required this.title,
  });

  /// The todolists title.
  final String title;
}
