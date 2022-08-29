import 'package:flutter/material.dart';

@immutable
class Todo {
  const Todo({
    required this.title,
    required this.duedate,
    //required this.todolistId,
  });

  /// The Todos title.
  final String title;

  /// The duedate of the Todo.
  final DateTime duedate;

  /// The ID of the Todolist this Todo refers to.
  // final String todolistId;
}
