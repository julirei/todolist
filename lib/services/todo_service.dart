import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/models/todo_blueprint.dart';
import 'package:todo_list/repositories/todo_media_repository.dart';
import 'package:todo_list/repositories/todo_repository.dart';
import 'package:geolocator/geolocator.dart';

/// Should handle all state and business logic related to [todo]s.
class TodoService {
  TodoService({
    required this.todoRepository,
    required this.todoMediaRepository,
  });

  /// Required dependency.
  final TodoRepository todoRepository;
  final TodoMediaRepository todoMediaRepository;
  final _todosRef = FirebaseFirestore.instance.collection('todos');

  /// Gets all todos for the given [todolistId].
  Future<List<Todo>> getTodos(String todolistId) async {
    return todoRepository.all(todolistId);
  }

  /// Gets position of current User
  Future<Position> determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    // Test if location services are enabled.
    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // Location services are not enabled don't continue
      // accessing the position and request users of the
      // App to enable the location services.
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // Permissions are denied, next time you could try
        // requesting permissions again (this is also where
        // Android's shouldShowRequestPermissionRationale
        // returned true. According to Android guidelines
        // your App should show an explanatory UI now.
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      // Permissions are denied forever, handle appropriately.
      return Future.error(
          'Location permissions are permanently denied, we cannot request permissions.');
    }

    // When we reach here, permissions are granted and we can
    // continue accessing the position of the device.
    return await Geolocator.getCurrentPosition();
  }

  /// Creates a new [Todo] from the given [blueprint] and attempts
  /// to publish it.
  ///
  /// May throw [PublishTodoException].
  Future<Todo> publishTodo(
    TodoBlueprint blueprint,
  ) async {
    // TODO: make sure user is signed in
    final String imageUrl;
    if (blueprint.imageUrl.path.isNotEmpty) {
      imageUrl = await todoMediaRepository.uploadMedia(blueprint.imageUrl);
    } else {
      imageUrl = "";
    }

    // Create a new todo from the blueprint.
    final todo = Todo(
      id: '', // will be determined by the repository
      todolistId: blueprint.todolistId,
      title: blueprint.title,
      duedate: blueprint.duedate,
      done: false,
      imageUrl: imageUrl,
      createdAt: DateTime.now(),
      userId: blueprint.userId,
      position: blueprint.position,
    );

    try {
      // Store the newly created todo in the repository.
      final storedTodo = await todoRepository.create(todo);
      return storedTodo;
    } catch (error) {
      print(error);
      // TODO: Improve error handling.
      throw PublishTodoException();
    }
  }

  /// Updates the done field of the [Todo] of a given [id]
  updateTodo(
    String id,
    bool done,
  ) async {
    try {
      await _todosRef.doc(id).update({"done": done});
    } catch (error) {
      print(error);
      throw PublishTodoException();
    }
  }

  /// Removes a [Todo] with the given [id]
  removeTodo(
    String id,
  ) async {
    try {
      await _todosRef.doc(id).delete();
    } catch (error) {
      print(error);
      throw RemoveTodoException();
    }
  }
}

class PublishTodoException implements Exception {}

class RemoveTodoException implements Exception {}
