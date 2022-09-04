import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/app/service_locator.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/screens/todo/todo.dart';
import 'package:todo_list/services/todo_service.dart';

/// Header of the footprint screen
class ListTodos extends StatefulWidget {
  const ListTodos({Key? key, required this.todos}) : super(key: key);
  final List<Todo> todos;

  @override
  State<ListTodos> createState() => _ListTodosState();
}

class _ListTodosState extends State<ListTodos> {
  final dateformat = DateFormat('dd.MM.yyyy');
  bool isChecked = false;
  bool _isLoading = false;
  final TodoService todoService = getIt<TodoService>();

  @override
  void initState() {
    widget.todos.sort((a, b) => a.duedate.compareTo(b.duedate));

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
          child: Card(
            elevation: 8.0,
            margin: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
            child: Container(
              padding: const EdgeInsets.only(right: 12.0),
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(
                  right: BorderSide(width: 0.5, color: Colors.white24),
                ),
              ),
              child: ListTile(
                title: Text(
                  widget.todos[index].title,
                ),
                subtitle: Text(dateformat.format(widget.todos[index].duedate)),
                trailing: IconButton(
                    onPressed: () {
                      handleRemoveTodo(index);
                    },
                    icon: const Icon(Icons.delete)),
                leading: Checkbox(
                  checkColor: Colors.white,
                  value: widget.todos[index].done,
                  onChanged: ((value) {
                    handleTodoOnChange(index, value);
                  }),
                ),
              ),
            ),
          ),
          onTap: () => Navigator.of(context).push(
            MaterialPageRoute(
                builder: (context) => ToDo(todo: widget.todos[index])),
          ),
        );
      },
      itemCount: widget.todos.length,
    );
  }

  handleTodoOnChange(index, value) {
    _isLoading = true;
    setState(() {
      widget.todos[index].done = value!;
      getIt<TodoService>()
          .updateTodo(widget.todos[index].id, widget.todos[index].done)
          .then((todo) => {
                setState(() {
                  _isLoading = false;
                })
              });
    });
  }

  handleRemoveTodo(index) {
    _isLoading = true;
    getIt<TodoService>().removeTodo(widget.todos[index].id);
    setState(() {
      widget.todos
          .removeWhere((element) => element.id == widget.todos[index].id);
    });
  }
}
