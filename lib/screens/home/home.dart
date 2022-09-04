import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/app/service_locator.dart';
import 'package:todo_list/models/todolist.dart';
import 'package:todo_list/models/todolist_blueprint.dart';
import 'package:todo_list/screens/home/widgets/home_list_todolists.dart';
import 'package:todo_list/screens/todolist/todolist.dart';
import 'package:todo_list/services/todolist_service.dart';
import 'package:get_it/get_it.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _textFieldController = TextEditingController();
  late List<TodoList> _todolists = <TodoList>[];
  final TodoListService todoListService = getIt<TodoListService>();
  late bool _signedIn = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late bool _success = false;
  late String _userEmail;
  late String _userId;

  @override
  void initState() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          _signedIn = false;
          _success = false;
        });
        print('User is currently signed out!');
      } else {
        setState(() {
          _signedIn = true;
          _success = true;
          _userId = user.uid;
        });
        todoListService
            .getTodoListsByUserId(_userId)
            .then((todolists) => {setState(() => _todolists = todolists)});
        print('User is signed in!');
      }
    });
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
        actions: [
          _signedIn
              ? TextButton(
                  child: const Icon(
                    Icons.logout,
                    color: Colors.white,
                  ),
                  onPressed: () async {
                    await _firebaseAuth.signOut();
                  },
                )
              : TextButton(
                  onPressed: _displayLoginDialog,
                  child: const Icon(
                    Icons.login,
                    color: Colors.white,
                  ))
        ],
      ),
      body: _signedIn
          ? HomeListTodoLists(todolists: _todolists)
          : const Padding(
              padding: EdgeInsets.all(15),
              child: Text("Bitte einloggen um TO-DO Listen zu erstellen."),
            ),
      floatingActionButton: _signedIn
          ? FloatingActionButton(
              onPressed: _displayAddTodoListDialog,
              tooltip: 'Todo Liste erstellen',
              child: const Icon(Icons.add),
            )
          : FloatingActionButton(
              onPressed: _displayLoginDialog, child: const Icon(Icons.login)),
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
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _displayLoginDialog() async {
    _textFieldController.clear();
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Login'),
          content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                TextFormField(
                  controller: _emailController,
                  decoration: const InputDecoration(hintText: 'E-Mail'),
                ),
                TextFormField(
                  controller: _passwordController,
                  decoration: const InputDecoration(hintText: 'Passwort'),
                ),
              ]),
          actions: <Widget>[
            TextButton(
              child: const Text('Benutzer erstellen'),
              onPressed: () {
                _registerUser();
                Navigator.pop(context, true);
              },
            ),
            TextButton(
              child: const Text('Sign In'),
              onPressed: () {
                _signInUser();
                Navigator.pop(context, true);
              },
            ),
          ],
        );
      },
    );
  }

  void handlePublishTodolistOnPressed() async {
    final todolistBlueprint = TodoListBlueprint(
      title: _textFieldController.text,
      createdAt: DateTime.now(),
      userId: _userId,
    );

    try {
      getIt<TodoListService>()
          .publishTodoList(todolistBlueprint)
          .then((todolist) => {
                setState(() => _todolists.add(todolist)),
                Navigator.pop(context),
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ToDoList(todolist: todolist))),
              });
    } catch (error) {
      //print(error);
    } finally {}
  }

  void _signInUser() async {
    try {
      final user = (await _firebaseAuth.signInWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;

      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email!;
          _userId = user.uid;
        });
      } else {
        setState(() {
          _success = false;
        });
      }
    } catch (error) {
      print(error);
    }
  }

  void _registerUser() async {
    try {
      final user = (await _firebaseAuth.createUserWithEmailAndPassword(
        email: _emailController.text,
        password: _passwordController.text,
      ))
          .user;
      if (user != null) {
        setState(() {
          _success = true;
          _userEmail = user.email!;
          _userId = user.uid;
        });
      } else {
        setState(() {
          _success = false;
        });
      }
    } catch (error) {
      print(error);
    }
  }
}
