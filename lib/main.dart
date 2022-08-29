import 'package:flutter/material.dart';
import 'package:todo_list/app/app.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await ToDoApp.bootstrap();
  runApp(const ToDoApp());
}
