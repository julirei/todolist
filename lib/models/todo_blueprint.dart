import 'package:flutter/material.dart';

/// A blueprint for creating a new [Todo].
@immutable
class TodoBlueprint {
  const TodoBlueprint({
    required this.title,
    required this.todolistId,
    required this.duedate,
  });

  /// The todos title.
  final String title;

  /// The todolists id.
  final String todolistId;

  /// The duedate of the Todo.
  final DateTime duedate;
}
