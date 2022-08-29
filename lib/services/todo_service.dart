import 'package:todo_list/models/todo.dart';
import 'package:todo_list/models/todo_blueprint.dart';
import 'package:todo_list/repositories/todo_repository.dart';

/// Handles all state and business logic related to [todo]s.
class TodoService {
  TodoService({
    required this.todoRepository,
  });

  /// Required dependency.
  final TodoRepository todoRepository;

  /// Gets all todos for the given [todolistId].
  Future<List<Todo>> getTodos(String todolistId) async {
    return todoRepository.all(todolistId);
  }

  /// Creates a new [Todo] from the given [blueprint] and attempts
  /// to publish it.
  ///
  /// May throw [PublishTodoException].
  Future<Todo> publishTodo(
    TodoBlueprint blueprint,
  ) async {
    // Make sure a user is currently signed-in.
    // final currentUser = userRepository.currentUser.value;
    // if (currentUser == null) {
    //   throw throw PublishTodoException();
    // }

    // Create a new todo from the blueprint.
    final todo = Todo(
      id: '', // will be determined by the repository
      todolistId: blueprint.todolistId,
      title: blueprint.title,
      duedate: blueprint.duedate,
    );

    try {
      // Store the newly created todo in the repository.
      final storedTodo = await todoRepository.create(todo);
      return storedTodo;
    } catch (error) {
      // TODO: Improve error handling.
      throw PublishTodoException();
    }
  }
}

class PublishTodoException implements Exception {}
