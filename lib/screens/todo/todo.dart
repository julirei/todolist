import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/app/service_locator.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/services/todo_service.dart';

class ToDo extends StatefulWidget {
  const ToDo({Key? key, required this.todo}) : super(key: key);
  final Todo todo;

  @override
  State<ToDo> createState() => _ToDoState();
}

class _ToDoState extends State<ToDo> {
  final dateformat = DateFormat('dd.MM.yyyy hh:mm');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          toolbarHeight: 80.0,
          title: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Bis ${dateformat.format(widget.todo.duedate)}',
                style: const TextStyle(color: Colors.white, fontSize: 12.0),
              ),
              Text(
                widget.todo.title.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 16.0),
              ),
            ],
          ),
          leading: Checkbox(
            value: widget.todo.done,
            onChanged: ((value) => handleTodoOnChange(value)),
          ),
          actions: [
            IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                icon: const Icon(Icons.close)),
          ],
        ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
                image: NetworkImage(widget.todo.imageUrl), fit: BoxFit.cover),
          ),
        ));
  }

  handleTodoOnChange(value) {
    setState(() {
      widget.todo.done = value!;
      getIt<TodoService>().updateTodo(widget.todo.id, widget.todo.done);
    });
  }
}
