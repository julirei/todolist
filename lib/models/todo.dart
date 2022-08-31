import 'dart:io';

import 'package:flutter/material.dart';

@immutable
class Todo {
  const Todo({
    required this.id,
    required this.title,
    required this.duedate,
    required this.todolistId,
    required this.done,
    required this.imageUrl,
  });

  /// The Todos id.
  final String id;

  /// The Todos title.
  final String title;

  /// The duedate of the Todo.
  final DateTime duedate;

  /// The ID of the Todolist this Todo refers to.
  final String todolistId;

  final bool done;

  final File imageUrl;
}
