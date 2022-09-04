import 'package:todo_list/models/state.dart';
import 'package:todo_list/models/todolist.dart';

/// Stores [TodoList]s.
abstract class TodoListRepository {
  /// Currently stored todolists.
  State<List<TodoList>> get todolists;

  /// Creates a new [todolist] and returns it.
  ///
  /// The [todolist]´s ID is ignored!
  ///
  /// Note that the returned [TodoList] has the ID
  /// replaced with a generated ID from the repository!
  Future<TodoList> create(TodoList todolist);

  /// Gets all existing todolists.
  Future<List<TodoList>> all();

  /// Gets all existing todolists.
  Future<List<TodoList>> allWithUserId(String userId);

  /// Finds the todolist with the given [id].
  ///
  /// May be `null` if no such todolist was found.
  Future<TodoList?> find(String id);

  Future<void> delete(String todoListId);
}
