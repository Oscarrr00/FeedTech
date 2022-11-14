import 'dart:async';

import 'package:feedtech/blocs/feeders/bloc/pair_feeders_repository.dart';
import 'package:feedtech/items/item_timer.dart';
import 'package:feedtech/models/feed_time_model.dart';
import 'package:feedtech/pages/add_timer.dart';
import 'package:feedtech/pages/all_charts_history.dart';
import 'package:feedtech/pages/food_per_hours.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';

class FeederDetailsPage extends StatefulWidget {
  final Feeder feeder;

  FeederDetailsPage({
    Key? key,
    required this.feeder,
  }) : super(key: key) {}

  @override
  State<FeederDetailsPage> createState() => _FeederDetailsPageState();
}

class _FeederDetailsPageState extends State<FeederDetailsPage> {
  late final StreamSubscription<DatabaseEvent> _dbFeedTimesSubscription;
  List<FeedTime> currentFeedTimes = [];
  Completer<void> feedCompleter = Completer()..complete();

  @override
  void initState() {
    _dbFeedTimesSubscription = FirebaseDatabase.instance
        .ref("feeders/" + widget.feeder.feederId + "/feedTimes")
        .onValue
        .listen((event) {
      if (event.snapshot.exists == false) {
        setState(() {
          currentFeedTimes = [];
        });
        return;
      }
      String data = event.snapshot.value as String? ?? "";
      if (data == "") {
        setState(() {
          currentFeedTimes = [];
        });
        return;
      }
      final List<String> dataPoints = data.split(":");
      final List<FeedTime> feedTimes = dataPoints.map((dataPoint) {
        final rawFeedTime = dataPoint.split(";");
        final DateTime feederDateTime = DateTime.fromMillisecondsSinceEpoch(
            int.parse(rawFeedTime[0]) * 1000);
        return FeedTime(
            portions: int.parse(rawFeedTime[1]),
            feedTime: TimeOfDay.fromDateTime(feederDateTime));
      }).toList();
      setState(() {
        currentFeedTimes = feedTimes;
      });
    });
    super.initState();
  }

  @override
  void dispose() async {
    _dbFeedTimesSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool vacio_lleno = true;
    return Scaffold(
      appBar: AppBar(
        title: Text(
            "FeedTech (${widget.feeder.feederName.length > 15 ? widget.feeder.feederName.substring(0, 15) + "..." : widget.feeder.feederName})",
            overflow: TextOverflow.visible),
      ),
      body: CustomPaint(
        painter: BackgroundPainter(),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(height: 25),
            Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text("El plato esta: ", style: TextStyle(fontSize: 20)),
                    (vacio_lleno)
                        ? Text(
                            "LLENO",
                            style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                            ),
                          )
                        : Text(
                            "VACIO",
                            style: TextStyle(
                              color: Colors.green,
                              fontSize: 20,
                            ),
                          )
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
                                builder: (context) => AllChartsPage(),
                              ),
                            );
                          },
                          customBorder: CircleBorder(),
                          child: Ink(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Color.fromARGB(255, 206, 199, 199),
                                    width: 2)),
                            height: 60,
                            width: 60,
                            child: Icon(
                                color: Colors.blue, Icons.numbers, size: 28),
                          ),
                        ),
                      ),
                      Material(
                        shape: CircleBorder(),
                        child: InkWell(
                          splashColor: Colors.black,
                          onTap: () {
                            feedPortionOnFeeder();
                          },
                          customBorder: CircleBorder(),
                          child: Ink(
                            decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                    color: Color.fromARGB(255, 206, 199, 199),
                                    width: 2)),
                            height: 150,
                            width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(color: Colors.blue, Icons.pets, size: 50),
                                SizedBox(height: 15),
                                Text("Alimentar ahora",
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
                                    color: Color.fromARGB(255, 206, 199, 199),
                                    width: 2)),
                            height: 60,
                            width: 60,
                            child: Icon(
                                color: Colors.blue, Icons.camera_alt, size: 28),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 50),
            Expanded(
              child: ListView.builder(
                itemBuilder: (context, index) {
                  return ItemTimer(
                    timer: currentFeedTimes[index],
                    onDeletePressed: () {
                      deleteFeedTime(
                        currentFeedTimes,
                        currentFeedTimes[index],
                        widget.feeder.feederId,
                      );
                    },
                    onEditPressed: () {
                      editFeedTime(
                        currentFeedTimes,
                        currentFeedTimes[index],
                        context,
                      );
                    },
                  );
                },
                itemCount: currentFeedTimes.length,
                scrollDirection: Axis.vertical,
              ),
            ),
            SizedBox(height: 8),
            _addTimerBtn(context, currentFeedTimes.length),
            SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  InkWell _addTimerBtn(BuildContext context, int numberOfTimers) {
    return InkWell(
      splashColor: Colors.black,
      onTap: () {
        if (numberOfTimers >= 8) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(
              SnackBar(
                content: Text(
                  "Únicamente puedes programar 8 horarios por alimentador.",
                ),
              ),
            );
          return;
        }
        addFeedTime(currentFeedTimes, context);
      },
      customBorder: CircleBorder(),
      child: Ink(
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Color.fromARGB(255, 220, 215, 215),
            width: 2,
          ),
        ),
        height: 65,
        width: 65,
        child: Icon(
          color: Colors.black,
          Icons.add,
          size: 35,
        ),
      ),
    );
  }

  Future<void> feedPortionOnFeeder() async {
    if (!feedCompleter.isCompleted) {
      print("You are going too fast!, wait for 5 secs");
      return;
    }
    await FirebaseDatabase.instance
        .ref("feeders/" + widget.feeder.feederId + "/shouldFeed")
        .set(true);
    feedCompleter = Completer();
    Future.delayed(Duration(seconds: 5))
        .then((value) => feedCompleter.complete());
  }

  void deleteFeedTime(
      List<FeedTime> feedTimes, FeedTime feedTimeToDelete, String feederId) {
    final List<FeedTime> newFeedTimes =
        feedTimes.where((element) => element != feedTimeToDelete).toList();
    String newFeedTimesStr = newFeedTimes.map((feedTime) {
      final timeNow = DateTime.now();
      final scheduleTo = DateTime(timeNow.year, timeNow.month, timeNow.day,
          feedTime.feedTime.hour, feedTime.feedTime.minute, 1);
      return "${scheduleTo.millisecondsSinceEpoch ~/ 1000};${feedTime.portions}";
    }).join(":");
    FirebaseDatabase.instance
        .ref("feeders/" + feederId + "/feedTimes")
        .set(newFeedTimesStr);
  }

  void editFeedTime(
      List<FeedTime> feedTimes, FeedTime feedTimeToEdit, BuildContext context) {
    Navigator.of(context)
        .push<FeedTime>(
      MaterialPageRoute(
        builder: (context) => AddTimerPage(
          initialPortions: feedTimeToEdit.portions,
          initialFeedTime: feedTimeToEdit.feedTime,
        ),
      ),
    )
        .then(
      (newFeedTime) {
        if (newFeedTime == null) {
          return;
        }
        String newFeedTimesStr = feedTimes
            .map((feedTime) =>
                feedTime == feedTimeToEdit ? newFeedTime : feedTime)
            .map(formatFeedTime)
            .join(":");
        FirebaseDatabase.instance
            .ref("feeders/" + widget.feeder.feederId + "/feedTimes")
            .set(newFeedTimesStr);
      },
    );
  }

  void addFeedTime(List<FeedTime> feedTimes, BuildContext context) {
    Navigator.of(context)
        .push<FeedTime>(
      MaterialPageRoute(
        builder: (context) => AddTimerPage(),
      ),
    )
        .then((newFeedTime) {
      if (newFeedTime == null) {
        return;
      }
      feedTimes.add(newFeedTime);
      String newFeedTimesStr = feedTimes.map(formatFeedTime).join(":");
      FirebaseDatabase.instance
          .ref("feeders/" + widget.feeder.feederId + "/feedTimes")
          .set(newFeedTimesStr);
    });
  }

  String formatFeedTime(FeedTime feedTime) {
    final timeNow = DateTime.now();
    final scheduleTo = DateTime(timeNow.year, timeNow.month, timeNow.day,
        feedTime.feedTime.hour, feedTime.feedTime.minute, 1);
    return "${scheduleTo.millisecondsSinceEpoch ~/ 1000};${feedTime.portions}";
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
