import 'package:flutter/material.dart';
import 'package:todo_list/models/todolist.dart';
import 'package:todo_list/screens/todolist/todolist.dart';

/// Header of the footprint screen
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
                  trailing: const Icon(
                    Icons.keyboard_arrow_right,
                    color: Colors.black,
                    size: 30.0,
                  ),
                ),
              ),
            ),
            onTap: () => Navigator.of(context).push(
                  MaterialPageRoute(
                      builder: (context) =>
                          ToDoList(title: widget.todolists[index].toString())),
                ));
      },
      itemCount: widget.todolists.length,
    );
  }
}
