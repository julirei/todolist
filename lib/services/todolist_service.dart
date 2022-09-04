import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/models/todolist.dart';
import 'package:todo_list/models/todolist_blueprint.dart';
import 'package:todo_list/repositories/todolist_repository.dart';

class TodoListService {
  TodoListService({
    required this.todolistRepository,
  });

  /// Required dependency.
  final TodoListRepository todolistRepository;
  final _todoListRef = FirebaseFirestore.instance.collection('todolists');

  /// Creates a new [TodoList] from the given [blueprint] and attempts
  /// to publish it.
  ///
  /// May throw [PublishTodoListException].
  Future<TodoList> publishTodoList(TodoListBlueprint blueprint) async {
    // Create a new todolist from the blueprint.
    final todolist = TodoList(
      id: '', // will be determined by the repository
      title: blueprint.title,
      createdAt: blueprint.createdAt,
      userId: blueprint.userId,
    );

    try {
      // Store the newly created todolist in the repository.
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

  /// Gets all todos for the given [userId].
  Future<List<TodoList>> getTodoListsByUserId(String userId) async {
    return todolistRepository.allWithUserId(userId);
  }

  /// Removes Todolist at given [id]
  Future<void> removeTodoList(
    String id,
  ) async {
    try {
      await _todoListRef.doc(id).delete();
    } catch (error) {
      print(error);
      throw RemoveTodoListException();
    }
  }
}

class PublishTodoListException implements Exception {}

class RemoveTodoListException implements Exception {}
