import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/app/service_locator.dart';
import 'package:todo_list/models/todolist.dart';
import 'package:todo_list/models/todolist_blueprint.dart';
import 'package:todo_list/screens/home/widgets/home_list_todolists.dart';
import 'package:todo_list/screens/todolist/todolist.dart';
import 'package:todo_list/services/todolist_service.dart';

final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

class Home extends StatefulWidget {
  const Home({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  late List<TodoList> _todolists = <TodoList>[];
  final TodoListService todoListService = getIt<TodoListService>();
  late bool _signedIn = false;
  late bool _obscured = true;
  late String _userId;
  late String _userEmail;

  @override
  void initState() {
    _firebaseAuth.authStateChanges().listen((User? user) {
      if (user == null) {
        setState(() {
          _signedIn = false;
        });
        print('User is currently signed out!');
      } else {
        setState(() {
          _signedIn = true;
          _userId = user.uid;
          _userEmail = user.email!;
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
        leading: _signedIn
            ? IconButton(
                onPressed: () => _showLoggedInUser(),
                icon: const Icon(Icons.face))
            : const Text(''),
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
                    Icons.face,
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
              onPressed: _displayLoginDialog, child: const Icon(Icons.add)),
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
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: const Text('Login'),
            content: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextFormField(
                      controller: _emailController,
                      decoration: const InputDecoration(
                        hintText: 'E-Mail',
                        prefixIcon: Icon(Icons.email_rounded),
                      ),
                      keyboardType: TextInputType.emailAddress),
                  TextFormField(
                    controller: _passwordController,
                    obscureText: _obscured,
                    keyboardType: TextInputType.visiblePassword,
                    decoration: InputDecoration(
                      hintText: 'Passwort',
                      prefixIcon: const Icon(Icons.lock_rounded),
                      suffixIcon: IconButton(
                        onPressed: () {
                          setState(() {
                            _obscured = !_obscured;
                          });
                        },
                        icon: Icon(
                          _obscured
                              ? Icons.visibility_rounded
                              : Icons.visibility_off_rounded,
                        ),
                      ),
                    ),
                  )
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
        });
      },
    );
  }

  Future<void> _showLoggedInUser() async {
    return showDialog<void>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Logged-In User'),
          content: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text('$_userEmail '),
              ]),
          actions: <Widget>[
            TextButton(
              child: const Text('Schließen'),
              onPressed: () {
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
          _userEmail = user.email!;
          _userId = user.uid;
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
          _userEmail = user.email!;
          _userId = user.uid;
        });
      }
    } catch (error) {
      print(error);
    }
  }
}
