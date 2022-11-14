import 'package:feedtech/models/feed_time_model.dart';
import 'package:flutter/material.dart';

class ItemTimer extends StatelessWidget {
  final FeedTime timer;
  final void Function() onDeletePressed;
  final void Function() onEditPressed;
  ItemTimer({
    Key? key,
    required this.timer,
    required this.onDeletePressed,
    required this.onEditPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    bool isSwitched = false;
    return Card(
      elevation: 3,
      margin: EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 5,
      ),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${(timer.feedTime.hour > 12 ? timer.feedTime.hour % 12 : timer.feedTime.hour).toString().padLeft(2, "0")}:${timer.feedTime.minute.toString().padLeft(2, "0")} ${timer.feedTime.hour >= 12 ? "pm" : "am"}",
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.left,
                  ),
                  SizedBox(height: 4),
                  Text(
                    "Todos los dias",
                    style: TextStyle(color: Color.fromARGB(255, 75, 75, 75)),
                  ),
                  Text(
                    "Alimento: ${timer.portions} porci${timer.portions == 1 ? "ón" : "ones"}",
                    style: TextStyle(color: Color.fromARGB(255, 75, 75, 75)),
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
                IconButton(
                    onPressed: onEditPressed, icon: Icon(Icons.edit, size: 27)),
                IconButton(
                    onPressed: onDeletePressed,
                    icon: Icon(Icons.delete, size: 27)),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
