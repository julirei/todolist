import 'package:flutter/material.dart';

@immutable
class TodoList {
  const TodoList({
    required this.id,
    required this.title,
  });

  /// The TodoLists id.
  final String id;

  /// The TodoLists title.
  final String title;
}
