import 'package:feedtech/items/item_timer.dart';
import 'package:feedtech/pages/add_timer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';

class LoggedPage extends StatelessWidget {
  const LoggedPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic>? Timers = [DateTime.now(), DateTime.now()];
    bool vacio_lleno = true;
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text("FeedTech"),
            Container(
              child: Row(
                children: [
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddTimerPage(),
                          ),
                        );
                      },
                      icon: Icon(Icons.add)),
                  IconButton(
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => AddTimerPage(),
                          ),
                        );
                      },
                      icon: Icon(Icons.analytics)),
                ],
              ),
            ),
          ],
        ),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                      Text("El plato esta: ", style: TextStyle(fontSize: 20)),
                      (vacio_lleno)
                          ? Text("LLENO",
                              style: TextStyle(color: Colors.red, fontSize: 20))
                          : Text("VACIO",
                              style:
                                  TextStyle(color: Colors.blue, fontSize: 20))
                    ]),
                    SizedBox(height: 20),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        InkWell(
                          splashColor: Colors.black,
                          onTap: () {},
                          customBorder: CircleBorder(),
                          child: Ink(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Color.fromARGB(255, 169, 164, 164),
                                    width: 2)),
                            height: 60,
                            width: 60,
                            child: Icon(
                                color: Colors.blue, Icons.numbers, size: 30),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.black,
                          onTap: () {},
                          customBorder: CircleBorder(),
                          child: Ink(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Color.fromARGB(255, 169, 164, 164),
                                    width: 2)),
                            height: 150,
                            width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(color: Colors.blue, Icons.pets, size: 50),
                                SizedBox(height: 15),
                                Text("Alimenar Manual",
                                    textAlign: TextAlign.center),
                              ],
                            ),
                          ),
                        ),
                        InkWell(
                          splashColor: Colors.black,
                          onTap: () {},
                          customBorder: CircleBorder(),
                          child: Ink(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Color.fromARGB(255, 169, 164, 164),
                                    width: 2)),
                            height: 60,
                            width: 60,
                            child: Icon(
                                color: Colors.blue, Icons.camera_alt, size: 30),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              (Timers != null)
                  ? Expanded(
                      child: Container(
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: List.generate(Timers.length, (index) {
                            return ItemTimer(timer: Timers[index]);
                          }),
                        ),
                      ),
                    )
                  : Expanded(child: Container()),
            ],
          ),
        ),
      ),
    );
  }
}
