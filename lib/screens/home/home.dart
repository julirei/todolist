import 'package:flutter/material.dart';
import 'package:todo_list/app/service_locator.dart';
import 'package:todo_list/models/todolist.dart';
import 'package:todo_list/models/todolist_blueprint.dart';
import 'package:todo_list/screens/home/widgets/home_list_todolists.dart';
import 'package:todo_list/screens/todolist/todolist.dart';
import 'package:todo_list/services/todolist_service.dart';
import 'package:get_it/get_it.dart';

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _textFieldController = TextEditingController();
  final List<TodoList> _todolists = <TodoList>[];
  late TodoList publishedTodolist;
  //final _todolists = getIt<TodoListService>().getTodoLists();

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the controller when the widget is disposed.
    _textFieldController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        centerTitle: true,
      ),
      body: HomeListTodoLists(todolists: _todolists!),
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
                handlePublishTodolistOnPressed();
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) =>
                        ToDoList(title: _textFieldController.text)));
              },
            ),
          ],
        );
      },
    );
  }

  void handlePublishTodolistOnPressed() async {
    //setLoading(true);
    final todolistBlueprint = TodoListBlueprint(
      title: _textFieldController.text,
    );

    try {
      // TODO: Call FootprintPublishService (Business Logic)
      // TODO: Add Business Logic to FootprintPublishService.
      getIt<TodoListService>().publishTodoList(todolistBlueprint).then(
          (todolist) => {
                publishedTodolist = todolist,
                _todolists.add(publishedTodolist)
              });

      Navigator.pop(context);
    } catch (error) {
      print(error);
      //showErrorSnackbar('Something went wrong. $error');
    } finally {
      //setLoading(false);
    }
  }
}
