import 'package:flutter/material.dart';
import 'package:todo_list/screens/todolist/todolist.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _textFieldController = TextEditingController();
  final List<String> _todolists = <String>[];

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textFieldController.dispose();
    super.dispose();
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
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: ListView.builder(
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
                      _todolists[index],
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
                            ToDoList(title: _todolists[index])),
                  ));
        },
        itemCount: _todolists.length,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _displayAddTodoListDialog,
        tooltip: 'Todo Liste erstellen',
        child: const Icon(Icons.add),
      ),
    );
  }

  Future<void> _displayAddTodoListDialog() async {
    _textFieldController.clear();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Neue TODO Liste erstellen'),
          content: TextField(
            controller: _textFieldController,
            decoration:
                const InputDecoration(hintText: 'Gib deiner Liste einen Namen'),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Erstellen'),
              onPressed: () {
                Navigator.pop(context);
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ToDoList(title: _textFieldController.text)));
                _addTodoList(_textFieldController.text);
              },
            ),
          ],
        );
      },
    );
  }

  void _addTodoList(String name) {
    setState(() {
      _todolists.add(name);
    });
  }
}
