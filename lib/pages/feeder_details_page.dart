import 'dart:async';

import 'package:feedtech/blocs/feeders/bloc/pair_feeders_bloc.dart';
import 'package:feedtech/blocs/feeders/bloc/pair_feeders_repository.dart';
import 'package:feedtech/items/item_timer.dart';
import 'package:feedtech/models/feed_time_model.dart';
import 'package:feedtech/pages/add_timer.dart';
import 'package:feedtech/pages/all_charts_history.dart';
import 'package:feedtech/pages/camera_page.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _foodPresentSubscription;
  bool? hasFoodPresent;
  late String feederName;
  List<FeedTime> currentFeedTimes = [];
  Completer<void> feedCompleter = Completer()..complete();

  @override
  void initState() {
    feederName = widget.feeder.feederName;
    _getRTDBFeedTimeSubscription();
    _getFirestoreFoodPresentSubscription();
    super.initState();
  }

  @override
  void dispose() async {
    _dbFeedTimesSubscription.cancel();
    _foodPresentSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "FeedTech (${feederName.length > 15 ? feederName.substring(0, 15) + "..." : feederName})",
          overflow: TextOverflow.visible,
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.edit),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  final TextEditingController newNameCtlr =
                      TextEditingController(text: feederName);
                  return AlertDialog(
                    title: Text("Editar nombre alimentador"),
                    content: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "Nuevo nombre:",
                          style: TextStyle(
                            fontSize: 18,
                          ),
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(height: 16),
                        TextField(
                          decoration: InputDecoration(
                            border: OutlineInputBorder(),
                          ),
                          controller: newNameCtlr,
                        )
                      ],
                    ),
                    actions: [
                      ElevatedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: Text("Cancelar")),
                      ElevatedButton(
                          onPressed: () async {
                            await updateFeederName(
                              widget.feeder,
                              newNameCtlr.text,
                            );
                            setState(() {
                              feederName = newNameCtlr.text;
                            });
                            BlocProvider.of<PairFeedersBloc>(context)
                                .add(LoadUserFeedersEvent());
                            Navigator.of(context).pop();
                          },
                          child: Text("Guardar")),
                    ],
                  );
                },
              );
            },
          ),
        ],
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
                    Text(
                      "El plato está: ",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    hasFoodPresent == null
                        ? Text(
                            "sin datos",
                            style: TextStyle(
                              color: Colors.brown,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          )
                        : hasFoodPresent == true
                            ? Text(
                                "con alimento",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 27, 120, 30),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              )
                            : Text(
                                "sin alimento",
                                style: TextStyle(
                                  color: Color.fromARGB(255, 169, 24, 14),
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
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
                          splashColor: Color.fromARGB(255, 214, 214, 214),
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) =>
                                    AllChartsPage(feeder: widget.feeder),
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
                          splashColor: Color.fromARGB(255, 214, 214, 214),
                          onTap: () {
                            feedPortionOnFeeder();
                          },
                          customBorder: CircleBorder(),
                          child: Ink(
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Color.fromARGB(255, 206, 199, 199),
                                width: 2,
                              ),
                            ),
                            height: 150,
                            width: 150,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                SizedBox(height: 8),
                                Icon(color: Colors.blue, Icons.pets, size: 72),
                                SizedBox(height: 4),
                                Text(
                                  "Alimentar\nahora",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Material(
                        shape: CircleBorder(),
                        child: InkWell(
                          splashColor: Color.fromARGB(255, 214, 214, 214),
                          onTap: () {
                            Navigator.of(context).push(MaterialPageRoute(
                                builder: (context) => CameraPage()));
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
      splashColor: Color.fromARGB(255, 214, 214, 214),
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

  void _getRTDBFeedTimeSubscription() {
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
    setState(() {
      feederName = widget.feeder.feederName;
    });
  }

  void _getFirestoreFoodPresentSubscription() {
    _foodPresentSubscription = FirebaseFirestore.instance
        .collection("foodPresent")
        .where(
          "feeder",
          isEqualTo: FirebaseFirestore.instance
              .collection("feeders")
              .doc(widget.feeder.feederId),
        )
        .orderBy("timestamp", descending: true)
        .limit(1)
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        final Timestamp date = event.docs.first.data()["timestamp"];
        print(DateTime.fromMillisecondsSinceEpoch(
          date.millisecondsSinceEpoch,
        ));
        final bool hasFoodPresentFirestore =
            event.docs.first.data()["hasFoodPresent"];
        setState(() {
          hasFoodPresent = hasFoodPresentFirestore;
        });
      }
    });
  }
}

Future<void> updateFeederName(
    Feeder currentFeeder, String newFeederName) async {
  await FirebaseFirestore.instance
      .collection("feeders")
      .doc(currentFeeder.feederId)
      .set({"feederName": newFeederName}, SetOptions(merge: true));
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
