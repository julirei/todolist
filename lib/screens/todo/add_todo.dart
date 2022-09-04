import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:todo_list/app/service_locator.dart';
import 'package:todo_list/models/geo_location.dart';
import 'package:todo_list/models/todo_blueprint.dart';
import 'package:todo_list/models/todolist.dart';
import 'package:todo_list/screens/todo/todo.dart';
import 'package:todo_list/services/todo_service.dart';

class AddToDo extends StatefulWidget {
  const AddToDo({Key? key, required this.todolist}) : super(key: key);
  final TodoList todolist;

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class _AddToDoState extends State<AddToDo> {
  // Datepicker variables
  DateTime _selectedDate = DateTime.now();
  TimeOfDay _selectedTime = TimeOfDay.now();
  DateTime _dateTime = DateTime.now();
  final _dateformat = DateFormat('dd.MM.yyyy hh:mm');
  late bool _datepicked = false;

  final TextEditingController _textFieldNameController =
      TextEditingController();
  late File _pickedFile;
  late GeoLocation _position;
  final TodoService _todoService = getIt<TodoService>();
  bool _imagePicked = false;

  @override
  void initState() {
    _todoService.determinePosition().then((position) => {
          setState(() {
            _position = GeoLocation(
                latitude: position.latitude, longitude: position.longitude);
          })
        });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('TO-DO in "${widget.todolist.title}" erstellen'),
      ),
      body: Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            const SizedBox(
              height: 10.0,
            ),
            TextFormField(
              controller: _textFieldNameController,
              maxLength: 20,
              decoration: const InputDecoration(
                labelText: 'Was ist zu erledigen?',
                enabledBorder: UnderlineInputBorder(
                  borderSide: BorderSide(),
                ),
              ),
            ),
            const SizedBox(
              height: 20.0,
            ),
            Row(children: [
              Expanded(
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    child: ElevatedButton(
                        onPressed: () {
                          _selectDateTime(context);
                          _datepicked = true;
                        },
                        child: const Icon(Icons.date_range)),
                  ),
                  _datepicked
                      ? Container(
                          width: double.infinity,
                          child: Text(
                            getDateTime(),
                            textAlign: TextAlign.center,
                          ),
                        )
                      : const SizedBox(height: 20.0),
                ]),
              ),
              Expanded(
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        handleImageButtonPressed();
                      },
                      child: const Icon(Icons.camera_alt),
                    ),
                  ),
                  _imagePicked
                      ? Container(
                          width: double.infinity,
                          child: const Text(
                            'Bild angehängt',
                            textAlign: TextAlign.center,
                          ))
                      : const SizedBox(height: 20.0),
                ]),
              ),
              Expanded(
                child: Column(children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 15),
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        handleChooseImageButtonPressed();
                      },
                      child: const Icon(Icons.attach_file),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                ]),
              )
            ]),
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
      duedate: _dateTime,
      todolistId: widget.todolist.id,
      done: false,
      imageUrl: _imagePicked ? _pickedFile : File(''),
      createdAt: DateTime.now(),
      position: _position,
      userId: widget.todolist.userId,
    );

    try {
      getIt<TodoService>().publishTodo(todoBlueprint).then(
            (value) => Navigator.of(context).push(
              MaterialPageRoute(builder: (context) => ToDo(todo: value)),
            ),
          );
    } catch (error) {
      print(error);
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
        _imagePicked = true;
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
            _imagePicked = true;
          },
        );
      },
    );
  }

  // Select for Date
  Future<DateTime> _selectDate(BuildContext context) async {
    final selected = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(2000),
      lastDate: DateTime(2025),
    );
    if (selected != null && selected != _selectedDate) {
      setState(() {
        _selectedDate = selected;
      });
    }
    return _selectedDate;
  }

// Select for Time
  Future<TimeOfDay> _selectTime(BuildContext context) async {
    final selected = await showTimePicker(
      context: context,
      initialTime: _selectedTime,
    );
    if (selected != null && selected != _selectedTime) {
      setState(() {
        _selectedTime = selected;
      });
    }
    return _selectedTime;
  }

  // select date time picker
  Future _selectDateTime(BuildContext context) async {
    final date = await _selectDate(context);
    final time = await _selectTime(context);
    setState(() {
      _dateTime = DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      );
    });
  }

  String getDateTime() {
    if (_dateTime == null) {
      return 'select date timer';
    } else {
      return _dateformat.format(_dateTime);
    }
  }
}
