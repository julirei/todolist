import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:todo_list/screens/home/home.dart';
import 'package:google_fonts/google_fonts.dart';

class ToDoApp extends StatefulWidget {
  const ToDoApp({Key? key}) : super(key: key);

  @override
  State<ToDoApp> createState() => _ToDoAppState();

  /// Code that needs to be executed before the app starts.
  static Future<void> bootstrap() async {
    await Firebase.initializeApp();
    await FirebaseAppCheck.instance.activate(
      webRecaptchaSiteKey: 'recaptcha-v3-site-key',
    );
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
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        fontFamily: GoogleFonts.getFont('Roboto').fontFamily,
        primarySwatch: Colors.green,
      ),
      home: const Home(title: 'Deine TO-DO Listen'),
    );
  }
}
