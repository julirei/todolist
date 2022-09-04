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

  /// The bool if the Todo is done
  late bool done;

  /// The imageurl of the File attached to Todo
  final String imageUrl;

  /// The datetime when the Todo is created
  final DateTime createdAt;

  /// The userid of the user who created the Todo
  final String userId;

  /// The geolocation where the Todo was created
  final GeoLocation position;
}
