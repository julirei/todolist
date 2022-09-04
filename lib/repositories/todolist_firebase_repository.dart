import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:todo_list/models/state.dart';
import 'package:todo_list/models/todolist.dart';
import 'package:todo_list/repositories/todolist_repository.dart';

class TodoListFirebaseRepository implements TodoListRepository {
  final _todoListsRef = FirebaseFirestore.instance.collection('todolists');

  State<List<TodoList>> get todolists => _todolists;
  final State<List<TodoList>> _todolists = State([]);

  // Local in-memory cache to reduce firestore queries.
  final Set<TodoList> _todolistSet = {};

  @override
  Future<TodoList> create(TodoList todolist) async {
    final doc = await _todoListsRef.add(_mapTodoListToFirestoreDoc(todolist));
    final todoListWithId = TodoList(
      id: doc.id,
      title: todolist.title,
      createdAt: todolist.createdAt,
      userId: todolist.userId,
    );
    _mergeIntoTodoLists([todoListWithId]);
    return todoListWithId;
  }

  @override
  Future<List<TodoList>> all() async {
    final querySnapshot = await _todoListsRef.get();
    final todolists =
        querySnapshot.docs.map(_mapFirestoreDocToTodoList).toList();
    _mergeIntoTodoLists(todolists);
    return todolists;
  }

  @override
  Future<List<TodoList>> allWithUserId(String userId) async {
    final querySnapshot =
        await _todoListsRef.where('userId', isEqualTo: userId).get();
    final todolists =
        querySnapshot.docs.map(_mapFirestoreDocToTodoList).toList();
    _mergeIntoTodoLists(todolists);
    return todolists;
  }

  @override
  Future<TodoList?> find(String id) async {
    final doc = await _todoListsRef.doc(id).get();
    final todoList = _mapFirestoreDocToTodoList(doc);
    _mergeIntoTodoLists([todoList]);
    return todoList;
  }

  @override
  Future<void> delete(String todoListId) async {
    await _todoListsRef.doc(todoListId).delete();
  }

  void _mergeIntoTodoLists(Iterable<TodoList> todolists) {
    final beforeLength = _todolistSet.length;
    _todolistSet.addAll(todolists);

    if (_todolistSet.length > beforeLength) {
      // there were changes -> update state
      _todolists.value = _todolistSet.toList();
    }
  }

  TodoList _mapFirestoreDocToTodoList(
      DocumentSnapshot<Map<String, dynamic>> doc) {
    final map = doc.data()!;
    return TodoList(
      id: doc.id,
      title: map['title'],
      createdAt: map['createdAt'].toDate(),
      userId: map['userId'],
    );
  }

  Map<String, dynamic> _mapTodoListToFirestoreDoc(TodoList todolist) {
    return {
      'title': todolist.title,
      'createdAt': todolist.createdAt,
      'userId': todolist.userId,
    };
  }
}
