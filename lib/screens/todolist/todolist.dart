import 'package:flutter/material.dart';
import 'package:todo_list/app/service_locator.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/models/todolist.dart';
import 'package:todo_list/screens/todo/add_todo.dart';
import 'package:todo_list/screens/todolist/widgets/list_todos.dart';
import 'package:todo_list/services/todo_service.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({Key? key, required this.todolist}) : super(key: key);
  final TodoList todolist;

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final TextEditingController _textFieldController = TextEditingController();
  late List<Todo> _todos;
  final TodoService todoService = getIt<TodoService>();
  bool _isLoading = false;

  @override
  void initState() {
    _isLoading = true;
    todoService.getTodos(widget.todolist.id).then((todos) => {
          setState(() {
            _todos = todos;
            _isLoading = false;
          })
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.todolist.title),
      ),
      body: !_isLoading
          ? ListTodos(todos: _todos)
          : const Center(
              child: CircularProgressIndicator(),
            ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddToDo(todolist: widget.todolist)));
        },
        tooltip: 'Todo Liste erstellen',
        child: const Icon(Icons.add),
      ),
    );
  }
}
