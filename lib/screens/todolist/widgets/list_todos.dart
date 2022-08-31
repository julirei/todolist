import 'package:flutter/material.dart';
import 'package:todo_list/models/todo.dart';

/// Header of the footprint screen
class ListTodos extends StatefulWidget {
  const ListTodos({Key? key, required this.todos}) : super(key: key);
  final List<Todo> todos;

  @override
  State<ListTodos> createState() => _ListTodosState();
}

class _ListTodosState extends State<ListTodos> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemBuilder: (BuildContext context, int index) {
        return GestureDetector(
            child: Card(
              elevation: 8.0,
              margin:
                  const EdgeInsets.symmetric(horizontal: 10.0, vertical: 6.0),
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
                  trailing: Text(
                    widget.todos[index].duedate.toString(),
                  ),
                  leading: Checkbox(
                    value: false,
                    onChanged: handleTodoCheck(),
                  ),
                ),
              ),
            ),
            onTap: () => Navigator.of(context).pop());
      },
      itemCount: widget.todos.length,
    );
  }

  handleTodoCheck() {
    return;
  }
}
