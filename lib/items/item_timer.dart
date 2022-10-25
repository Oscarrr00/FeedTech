import 'package:flutter/material.dart';

class ItemTimer extends StatelessWidget {
  final dynamic timer;
  ItemTimer({
    Key? key,
    required this.timer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSwitched = false;
    return Padding(
      padding: const EdgeInsets.only(bottom: 15.0),
      child: Container(
        width: 60,
        height: 60,
        padding: EdgeInsets.all(5),
        child: ClipRRect(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Row(
                  children: [
                    Text(
                        "${timer.hour.toString() + ':' + timer.minute.toString()}",
                        style: TextStyle(fontSize: 45)),
                    Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(),
                        Text("PM", textAlign: TextAlign.start),
                      ],
                    ),
                  ],
                ),
              ),
              Container(
                  child: Row(
                children: [
                  Switch(
                    value: isSwitched,
                    onChanged: (value) {},
                    activeTrackColor: Colors.lightGreenAccent,
                    activeColor: Colors.green,
                  ),
                  IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                  IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
                ],
              )),
            ],
          ),
        ),
      ),
    );
  }
}
