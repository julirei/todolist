import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/repositories/todo_repository.dart';

class TodoFirebaseRepository implements TodoRepository {
  final _todos = FirebaseFirestore.instance.collection('todos');

  @override
  Future<List<Todo>> all(String todolistId) async {
    final querySnapshot =
        await _todos.where('todolistId', isEqualTo: todolistId).get();
    return querySnapshot.docs.map(_mapFirestoreDocToTodo).toList();
  }

  @override
  Future<Todo> create(Todo todo) async {
    final doc = await _todos.add(_mapTodoToFirestoreDoc(todo));
    return Todo(
      id: doc.id,
      todolistId: todo.todolistId,
      title: todo.title,
      duedate: todo.duedate,
      done: todo.done,
      imageUrl: todo.imageUrl,
    );
  }

  Todo _mapFirestoreDocToTodo(
    QueryDocumentSnapshot<Map<String, dynamic>> doc,
  ) {
    final map = doc.data();
    return Todo(
      id: doc.id,
      todolistId: map['todolistId'],
      title: map['title'],
      duedate: map['duedate'].toDate(),
      done: map['done'],
      imageUrl: map['imageUrl'],
    );
  }

  Map<String, dynamic> _mapTodoToFirestoreDoc(Todo todo) {
    return {
      'todolistId': todo.todolistId,
      'title': todo.title,
      'duedate': Timestamp.fromDate(todo.duedate),
      'done': todo.done,
      'imageUrl': todo.imageUrl,
    };
  }
}
