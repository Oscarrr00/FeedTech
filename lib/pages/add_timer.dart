import 'package:flutter/material.dart';
import 'package:flutter_time_picker_spinner/flutter_time_picker_spinner.dart';

class AddTimerPage extends StatefulWidget {
  const AddTimerPage({
    Key? key,
  }) : super(key: key);

  @override
  State<AddTimerPage> createState() => _AddTimerPageState();
}

class _AddTimerPageState extends State<AddTimerPage> {
  DateTime _dateTime = DateTime.now();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Nuevo Horario"),
            IconButton(onPressed: () {}, icon: Icon(Icons.check))
          ],
        ),
      ),
      body: Center(
          child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TimePickerSpinner(
            alignment: Alignment.center,
            is24HourMode: false,
            normalTextStyle: TextStyle(
                fontSize: 24, color: Color.fromARGB(255, 145, 143, 143)),
            highlightedTextStyle:
                TextStyle(fontSize: 24, color: Colors.deepOrange),
            spacing: 40,
            itemHeight: 80,
            onTimeChange: (time) {
              setState(() {
                _dateTime = time;
              });
            },
          ),
          SizedBox(height: 20),
          Text(
              "El horario sera: ${_dateTime.hour.toString() + ':' + _dateTime.minute.toString()}",
              style: TextStyle(fontSize: 24)),
        ],
      )),
    );
  }
}
