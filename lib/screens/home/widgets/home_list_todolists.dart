import 'package:flutter/material.dart';
import 'package:todo_list/app/service_locator.dart';
import 'package:todo_list/models/todolist.dart';
import 'package:todo_list/screens/todolist/todolist.dart';
import 'package:todo_list/services/todolist_service.dart';

class HomeListTodoLists extends StatefulWidget {
  const HomeListTodoLists({Key? key, required this.todolists})
      : super(key: key);
  final List<TodoList> todolists;

  @override
  State<HomeListTodoLists> createState() => _HomeListTodoListsState();
}

class _HomeListTodoListsState extends State<HomeListTodoLists> {
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
                    widget.todolists[index].title,
                  ),
                  trailing: IconButton(
                      onPressed: () => _displayRemoveTodoListDialog(index),
                      icon: const Icon(Icons.delete)),
                ),
              ),
            ),
            onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          ToDoList(todolist: widget.todolists[index])),
                ));
      },
      itemCount: widget.todolists.length,
    );
  }

  Future<void> _displayRemoveTodoListDialog(index) async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'TODO Liste "${widget.todolists[index].title}" wirklich löschen?'),
          actions: <Widget>[
            TextButton(
              child: const Text('Nein'),
              onPressed: () {
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: const Text('Ja'),
              onPressed: () {
                handleRemoveTodoList(index);
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  handleRemoveTodoList(index) {
    getIt<TodoListService>().removeTodoList(widget.todolists[index].id);
    setState(() {
      widget.todolists
          .removeWhere((element) => element.id == widget.todolists[index].id);
    });
  }
}
