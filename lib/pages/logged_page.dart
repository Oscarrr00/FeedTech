import 'package:feedtech/items/item_timer.dart';
import 'package:feedtech/pages/add_timer.dart';
import 'package:feedtech/pages/history.dart';
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
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("FeedTech"),
          ],
        ),
      ),
      body: CustomPaint(
        painter: BackgroundPainter(),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("El plato esta: ",
                                style: TextStyle(fontSize: 20)),
                            (vacio_lleno)
                                ? Text("LLENO",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: 20))
                                : Text("VACIO",
                                    style: TextStyle(
                                        color: Colors.green, fontSize: 20))
                          ]),
                      SizedBox(height: 20),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Material(
                            shape: CircleBorder(),
                            child: InkWell(
                              splashColor: Colors.black,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute(
                                    builder: (context) => HistoryPage(),
                                  ),
                                );
                              },
                              customBorder: CircleBorder(),
                              child: Ink(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color:
                                            Color.fromARGB(255, 206, 199, 199),
                                        width: 2)),
                                height: 60,
                                width: 60,
                                child: Icon(
                                    color: Colors.blue,
                                    Icons.numbers,
                                    size: 28),
                              ),
                            ),
                          ),
                          Material(
                            shape: CircleBorder(),
                            child: InkWell(
                              splashColor: Colors.black,
                              onTap: () {},
                              customBorder: CircleBorder(),
                              child: Ink(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color:
                                            Color.fromARGB(255, 206, 199, 199),
                                        width: 2)),
                                height: 150,
                                width: 150,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                        color: Colors.blue,
                                        Icons.pets,
                                        size: 50),
                                    SizedBox(height: 15),
                                    Text("Alimenar Manual",
                                        textAlign: TextAlign.center),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Material(
                            shape: CircleBorder(),
                            child: InkWell(
                              splashColor: Colors.black,
                              onTap: () {},
                              customBorder: CircleBorder(),
                              child: Ink(
                                decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                        color:
                                            Color.fromARGB(255, 206, 199, 199),
                                        width: 2)),
                                height: 60,
                                width: 60,
                                child: Icon(
                                    color: Colors.blue,
                                    Icons.camera_alt,
                                    size: 28),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 60),
                (Timers != null)
                    ? Expanded(
                        child: Container(
                          padding: EdgeInsets.all(10),
                          child: ListView(
                            scrollDirection: Axis.vertical,
                            children: List.generate(Timers.length, (index) {
                              return ItemTimer(timer: Timers[index]);
                            }),
                          ),
                        ),
                      )
                    : Expanded(child: Container()),
                InkWell(
                  splashColor: Colors.black,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => AddTimerPage(),
                      ),
                    );
                  },
                  customBorder: CircleBorder(),
                  child: Ink(
                    decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: Color.fromARGB(255, 220, 215, 215),
                            width: 2)),
                    height: 65,
                    width: 65,
                    child: Icon(color: Colors.black, Icons.add, size: 35),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class BackgroundPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final height = size.height;
    final width = size.width;
    Paint paint = new Paint();

    Path mainBackground = new Path();
    mainBackground.moveTo(0, height * 0.3);

    mainBackground.lineTo(width * 0.26, height * 0.322);

    mainBackground.quadraticBezierTo(
        width * 0.43, height * 0.362, width * 0.5, height * 0.36);

    mainBackground.quadraticBezierTo(
        width * 0.57, height * 0.362, width * 0.74, height * 0.322);

    mainBackground.lineTo(width, height * 0.3);

    mainBackground.lineTo(width, 0);

    mainBackground.lineTo(0, 0);

    paint.color = Color.fromARGB(255, 102, 178, 244);
    canvas.drawPath(mainBackground, paint);
  }

  @override
  bool shouldRepaint(BackgroundPainter oldDelegate) => false;
}
