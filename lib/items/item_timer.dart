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
      padding: const EdgeInsets.only(bottom: 20.0),
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          color: Color.fromARGB(255, 237, 237, 237),
          borderRadius: BorderRadius.circular(10),
        ),
        padding: EdgeInsets.all(5),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "${timer.day.toString() + ':' + timer.minute.toString().padLeft(2, "0")}",
                    style: TextStyle(fontSize: 30),
                    textAlign: TextAlign.left,
                  ),
                  Text("Todos los dias"),
                  Text("Alimento: 5 porcione(s)"),
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
                IconButton(onPressed: () {}, icon: Icon(Icons.edit, size: 27)),
                IconButton(
                    onPressed: () {}, icon: Icon(Icons.delete, size: 27)),
              ],
            )),
          ],
        ),
      ),
    );
  }
}
