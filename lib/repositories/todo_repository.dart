import 'package:todo_list/models/todo.dart';

/// Stores [Todo]s.
abstract class TodoRepository {
  /// Gets all todos for the given [todo].
  Future<List<Todo>> all(String todolistId);

  /// Creates a new [todo] and returns it.
  ///
  /// The [todo]´s ID is ignored!
  ///
  /// Note that the returned [Todo] has the ID
  /// replaced with a generated ID from the repository!
  Future<Todo> create(Todo todo);

  Future<void> delete(String todoId);
}
