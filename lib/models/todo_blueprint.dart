import 'dart:io';
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

  /// The bool if the Todo is done
  late bool done;

  /// The imageurl of the File attached to Todo
  final File imageUrl;

  /// The datetime when the Todo is created
  final DateTime createdAt;

  /// The userid of the user who created the Todo
  final String userId;

  /// The geolocation where the Todo was created
  final GeoLocation position;
}
