import 'dart:io';

import 'package:flutter/material.dart';

/// A blueprint for creating a new [Todo].
@immutable
class TodoBlueprint {
  const TodoBlueprint({
    required this.title,
    required this.todolistId,
    required this.duedate,
    required this.done,
    required this.imageUrl,
  });

  /// The todos title.
  final String title;

  /// The todolists id.
  final String todolistId;

  /// The duedate of the Todo.
  final DateTime duedate;

  final bool done;

  final File imageUrl;
}
