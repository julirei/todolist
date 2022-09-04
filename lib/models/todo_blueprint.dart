import 'dart:io';
import 'package:flutter/material.dart';
import 'package:todo_list/models/geo_location.dart';

/// A blueprint for creating a new [Todo].
class TodoBlueprint {
  TodoBlueprint({
    required this.title,
    required this.todolistId,
    required this.duedate,
    required this.done,
    required this.imageUrl,
    required this.createdAt,
    required this.userId,
    required this.position,
  });

  /// The todos title.
  final String title;

  /// The todolists id.
  final String todolistId;

  /// The duedate of the Todo.
  final DateTime duedate;

  late bool done;

  final File imageUrl;

  final DateTime createdAt;

  final String userId;

  final GeoLocation position;
}
