import 'package:feedtech/models/feed_time_model.dart';
import 'package:flutter/material.dart';
import 'package:day_night_time_picker/day_night_time_picker.dart';

class AddTimerPage extends StatefulWidget {
  final int? initialPortions;
  final TimeOfDay? initialFeedTime;

  AddTimerPage({
    Key? key,
    this.initialPortions,
    this.initialFeedTime,
  }) : super(key: key);

  @override
  State<AddTimerPage> createState() => _AddTimerPageState();
}

class _AddTimerPageState extends State<AddTimerPage> {
  late TimeOfDay timeToFeed;
  late int portions;

  @override
  void initState() {
    timeToFeed = widget.initialFeedTime != null
        ? widget.initialFeedTime!
        : TimeOfDay.now();
    portions = widget.initialPortions ?? 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("Nuevo Horario"),
            IconButton(
              onPressed: () {
                Navigator.of(context).pop(
                  FeedTime(portions: portions, feedTime: timeToFeed),
                );
              },
              icon: Icon(
                Icons.check,
              ),
            )
          ],
        ),
      ),
      body: Container(
        height: double.infinity,
        width: double.infinity,
        child: Center(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 32),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text(
                      "Horario",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                  ),
                  createInlinePicker(
                    context: context,
                    isOnChangeValueMode: true,
                    dialogInsetPadding: const EdgeInsets.symmetric(
                        horizontal: 20.0, vertical: 24.0),
                    is24HrFormat: true,
                    value: timeToFeed,
                    onChange: (newTime) {
                      print(newTime);
                      setState(() {
                        timeToFeed = newTime;
                      });
                    },
                  ),
                  SizedBox(height: 40),
                  Center(
                    child: Text(
                      "Porciones",
                      style:
                          TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
                    ),
                  ),
                  SizedBox(height: 14),
                  _getNumberPicker(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getNumberPicker() {
    return Row(
      mainAxisSize: MainAxisSize.max,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
          onPressed: () {
            setState(() {
              portions--;
              if (portions <= 0) {
                portions = 1;
              }
            });
          },
          icon: Icon(Icons.remove),
        ),
        SizedBox(width: 32),
        Text(
          "$portions",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
        SizedBox(width: 32),
        IconButton(
          onPressed: () {
            setState(() {
              portions++;
              if (portions > 5) {
                portions = 5;
              }
            });
          },
          icon: Icon(Icons.add),
        ),
      ],
    );
  }
}
