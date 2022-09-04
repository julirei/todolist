import 'package:todo_list/models/geo_location.dart';

class Todo {
  Todo({
    required this.id,
    required this.title,
    required this.duedate,
    required this.todolistId,
    required this.done,
    required this.imageUrl,
    required this.createdAt,
    required this.userId,
    required this.position,
  });

  /// The Todos id.
  final String id;

  /// The Todos title.
  final String title;

  /// The duedate of the Todo.
  final DateTime duedate;

  /// The ID of the Todolist this Todo refers to.
  final String todolistId;

  late bool done;

  final String imageUrl;

  final DateTime createdAt;

  final String userId;

  final GeoLocation position;
}
