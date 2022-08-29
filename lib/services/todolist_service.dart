import 'package:todo_list/models/todolist.dart';
import 'package:todo_list/models/todolist_blueprint.dart';
import 'package:todo_list/repositories/todolist_repository.dart';

class TodoListService {
  TodoListService({
    required this.todolistRepository,
  });

  /// Required dependency.
  final TodoListRepository todolistRepository;

  /// Creates a new [TodoList] from the given [blueprint] and attempts
  /// to publish it.
  ///
  /// May throw [PublishTodoListException].
  Future<TodoList> publishTodoList(TodoListBlueprint blueprint) async {
    // Create a new todolist from the blueprint.
    final todolist = TodoList(
      id: '', // will be determined by the repository
      title: blueprint.title,
    );

    try {
      // Store the newly created footprint in the repository.
      final storedTodoList = await todolistRepository.create(todolist);
      return storedTodoList;
    } catch (error) {
      // Improve error handling.
      throw PublishTodoListException();
    }
  }

  /// Gets all todolists
  Future<List<TodoList>> getTodoLists() async {
    return todolistRepository.all();
  }
}

class PublishTodoListException implements Exception {}
