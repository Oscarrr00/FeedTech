import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TechFeedersUsers extends StatefulWidget {
  const TechFeedersUsers({
    Key? key,
  }) : super(key: key);

  @override
  State<TechFeedersUsers> createState() => _TechFeedersUsersState();
}

class _TechFeedersUsersState extends State<TechFeedersUsers> {
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _feedersUsersSubscription;
  List users = [];
  List<FeedersUsersBar> data = [];
  void initState() {
    _getFeedersUsersSubscription();
    super.initState();
  }

  @override
  void dispose() async {
    _feedersUsersSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<FeedersUsersBar, String>> capacity = [
      charts.Series(
          id: "Time history",
          data: data,
          domainFn: (FeedersUsersBar series, _) => series.users,
          measureFn: (FeedersUsersBar series, _) => series.feeders,
          colorFn: (FeedersUsersBar series, _) => series.barColor)
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Alimentadores por usuario"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "",
            ),
            Expanded(
              child: charts.BarChart(
                capacity,
                animate: true,
              ),
            ),
            SizedBox(height: 40),
            Container(
                height: MediaQuery.of(context).size.height / 3,
                child: Text(
                  "Cantidad de usuarios por cuantos alimentadores tienen.",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                )),
          ],
        ),
      ),
    );
  }

  void _getFeedersUsersSubscription() {
    _feedersUsersSubscription = FirebaseFirestore.instance
        .collection("feeders")
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        for (var doc in event.docs) {
          var feedersdata = doc.data();
          if (users.indexWhere(
                  (user) => user["user"] == feedersdata["ownerId"]) ==
              -1) {
            users.add({"user": feedersdata["ownerId"], "feeders": 0});
            var index = users
                .indexWhere((user) => user["user"] == feedersdata["ownerId"]);
            users[index]["feeders"]++;
          } else {
            var index = users
                .indexWhere((user) => user["user"] == feedersdata["ownerId"]);
            users[index]["feeders"]++;
          }
        }

        List<FeedersUsersBar> newData = [];
        for (int i = 0; i < users.length; i++) {
          newData.add(FeedersUsersBar(
            users: "User ${i}",
            feeders: users[i]["feeders"],
            barColor: charts.ColorUtil.fromDartColor(Colors.green),
          ));
        }
        setState(() {
          data = newData;
        });
      } else {
        setState(() {});
      }
    });
  }
}

class FeedersUsersBar {
  final String users;
  final int feeders;
  final charts.Color barColor;

  FeedersUsersBar(
      {required this.users, required this.feeders, required this.barColor});
}
