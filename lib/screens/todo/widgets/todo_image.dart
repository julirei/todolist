import 'dart:io';

import 'package:flutter/material.dart';

class TodoImage extends StatefulWidget {
  const TodoImage({Key? key, required this.todoimage}) : super(key: key);
  final File todoimage;

  @override
  State<TodoImage> createState() => _TodoImageState();
}

class _TodoImageState extends State<TodoImage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(0.0),
      width: double.infinity,
      height: 250.0,
      child: Image.file(
        widget.todoimage,
        fit: BoxFit.contain,
      ),
    );
  }
}
