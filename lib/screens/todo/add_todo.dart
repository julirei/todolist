import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class AddToDo extends StatefulWidget {
  const AddToDo({Key? key, required this.title}) : super(key: key);
  final String title;

  @override
  State<AddToDo> createState() => _AddToDoState();
}

class ToDo {
  ToDo({required this.name, required this.duedate});
  final String name;
  final DateTime duedate;
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
    if (date == null) return;

    final time = await _selectTime(context);

    if (time == null) return;
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

  final TextEditingController _textFieldController = TextEditingController();
  final TextEditingController _textFieldNameController =
      TextEditingController();
  final TextEditingController _textFieldDuedateController =
      TextEditingController();
  final today = DateTime.now();
  final List<ToDo> _todos = <ToDo>[];

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
        title: Text('TO-DO in "${widget.title}" erstellen'),
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
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pop();
          setState(() {
            _todos.add(
                ToDo(name: _textFieldNameController.text, duedate: dateTime));
          });
        },
        tooltip: 'Todo Liste erstellen',
        child: const Icon(Icons.done),
      ),
    );
  }
}
