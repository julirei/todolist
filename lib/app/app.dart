import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:todo_list/app/service_locator.dart';
import 'package:todo_list/screens/home/home.dart';
import 'package:google_fonts/google_fonts.dart';

class ToDoApp extends StatefulWidget {
  const ToDoApp({Key? key}) : super(key: key);

  @override
  State<ToDoApp> createState() => _ToDoAppState();

  /// Code that needs to be executed before the app starts.
  static Future<void> bootstrap() async {
    await Firebase.initializeApp();
    await FirebaseAppCheck.instance.setTokenAutoRefreshEnabled(true);
    FirebaseAppCheck.instance.onTokenChange.listen((token) {
      print(token);
    });

    setupServiceLocator();
    WidgetsFlutterBinding.ensureInitialized();
  }
}

class _ToDoAppState extends State<ToDoApp> {
  @override
  void initState() {
    super.initState();
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TODO LIST',
      theme: ThemeData(
        fontFamily: GoogleFonts.getFont('Roboto').fontFamily,
        primarySwatch: Colors.green,
      ),
      home: const Home(title: 'Deine TO-DO Listen'),
    );
  }
}
