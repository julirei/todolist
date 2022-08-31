import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/app/service_locator.dart';
import 'package:todo_list/models/todo.dart';
import 'package:todo_list/models/todo_blueprint.dart';
import 'package:todo_list/models/todolist.dart';
import 'package:todo_list/services/todo_service.dart';

class AddToDo extends StatefulWidget {
  const AddToDo({Key? key, required this.todolist}) : super(key: key);
  final TodoList todolist;

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  DateTime selectedDate = DateTime.now();
  TimeOfDay selectedTime = TimeOfDay.now();
  DateTime dateTime = DateTime.now();
  bool showDate = false;
  bool showTime = false;
  bool showDateTime = false;

  // Select for Date
  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != selectedDate) {
      setState(() {
        selectedDate = selected;
      });
    }
    return selectedDate;
  }

// Select for Time
  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (selected != null && selected != selectedTime) {
      setState(() {
        selectedTime = selected;
      });
    }
    return selectedTime;
  }
  // select date time picker

  Future _selectDateTime(BuildContext context) async {
    final date = await _selectDate(context);
    final time = await _selectTime(context);
    setState(() {
      dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String getDateTime() {
    // ignore: unnecessary_null_comparison
    if (dateTime == null) {
      return 'select date timer';
    } else {
      return DateFormat('yyyy-MM-dd HH: ss a').format(dateTime);
    }
  }

  final TextEditingController _textFieldNameController =
      TextEditingController();
  final today = DateTime.now();
  final List<Todo> _todos = <Todo>[];
  bool _isLoading = false;
  late File _pickedFile;

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
        title: Text('TO-DO in "${widget.todolist.title}" erstellen'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const Text(
              'Was ist zu erledigen',
            ),
            const SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: _textFieldNameController,
              maxLength: 20,
              decoration: const InputDecoration(
                labelText: 'Titel',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            const Text(
              'Bis wann ist es zu erledigen?',
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  _selectDateTime(context);
                  showDateTime = true;
                },
                child: const Text('Datum und Uhrzeit wählen'),
              ),
            ),
            showDateTime
                ? Center(child: Text(getDateTime()))
                : const SizedBox(),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  handleImageButtonPressed();
                },
                child: const Text('Foto schiessen'),
              ),
            ),
            const SizedBox(
              height: 10.0,
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 15),
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  handleChooseImageButtonPressed();
                },
                child: const Text('Foto auswählen'),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          handlePublishTodoOnPressed();
        },
        tooltip: 'Todo Liste erstellen',
        child: const Icon(Icons.done),
      ),
    );
  }

  void handlePublishTodoOnPressed() async {
    final todoBlueprint = TodoBlueprint(
      title: _textFieldNameController.text,
      duedate: dateTime,
      todolistId: widget.todolist.id,
      done: false,
      imageUrl: _pickedFile,
    );

    print(todoBlueprint.imageUrl);
    try {
      setState(() {
        _isLoading = true;
      });
      getIt<TodoService>().publishTodo(todoBlueprint).then((todo) => {
            setState(() {
              _todos.add(todo);
              _isLoading = false;
            })
          });
      Navigator.of(context).pop();
    } catch (error) {
      //showErrorSnackbar('Something went wrong. $error');
    } finally {
      //setLoading(false);
    }
  }

  handleImageButtonPressed() async {
    return await ImagePicker()
        .pickImage(
      source: ImageSource.camera,
      preferredCameraDevice: CameraDevice.front,
    )
        .then((value) {
      setState(() {
        _pickedFile = File(value!.path);
      });
    });
  }

  handleChooseImageButtonPressed() async {
    return await ImagePicker()
        .pickImage(
      source: ImageSource.gallery,
      preferredCameraDevice: CameraDevice.front,
    )
        .then(
      (value) {
        setState(
          () {
            _pickedFile = File(value!.path);
          },
        );
      },
    );
  }
}
