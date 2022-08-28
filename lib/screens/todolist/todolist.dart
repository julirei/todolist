import 'package:flutter/material.dart';
import 'package:todo_list/screens/todo/add_todo.dart';

class ToDoList extends StatefulWidget {
  const ToDoList({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<ToDoList> createState() => _ToDoListState();
}

class _ToDoListState extends State<ToDoList> {
  final TextEditingController _textFieldController = TextEditingController();

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
        title: Text(widget.title),
      ),
      body: ListView.builder(
        // Let the ListView know how many items it needs to build.
        itemCount: 1,
        // Provide a builder function. This is where the magic happens.
        // Convert each item into a widget based on the type of item it is.
        itemBuilder: (context, index) {
          //final item = todolists[index];

          return ListTile(
            title: Text(
                'Erstelle dir hier deine TO-DOs zum Thema "${widget.title}"'),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(MaterialPageRoute(
              builder: (context) => AddToDo(title: widget.title)));
        },
        tooltip: 'Todo Liste erstellen',
        child: const Icon(Icons.add),
      ),
    );
  }
}
