import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class UsersActive extends StatefulWidget {
  const UsersActive({
    Key? key,
  }) : super(key: key);

  @override
  State<UsersActive> createState() => _UsersActiveState();
}

class _UsersActiveState extends State<UsersActive> {
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _usersActiveSubscription;
  var countUsers = 0;
  List users = [];
  List<UserBar> data = [
    UserBar(
      month: "1",
      users: 11,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    UserBar(
      month: "2",
      users: 10,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    UserBar(
      month: "3",
      users: 12,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    UserBar(
      month: "4",
      users: 17,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    UserBar(
      month: "5",
      users: 16,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    UserBar(
      month: "6",
      users: 4,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    UserBar(
      month: "7",
      users: 7,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    UserBar(
      month: "8",
      users: 12,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    UserBar(
      month: "9",
      users: 2,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    UserBar(
      month: "10",
      users: 8,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    UserBar(
      month: "11",
      users: 5,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    ),
    UserBar(
      month: "12",
      users: 0,
      barColor: charts.ColorUtil.fromDartColor(Colors.blue),
    )
  ];
  void initState() {
    _getUsersActiveSubscription();
    super.initState();
  }

  @override
  void dispose() async {
    _usersActiveSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<UserBar, String>> capacity = [
      charts.Series(
          id: "Time history",
          data: data,
          domainFn: (UserBar series, _) => series.month,
          measureFn: (UserBar series, _) => series.users,
          colorFn: (UserBar series, _) => series.barColor)
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Numero de Usuarios activos"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: (data.length <= 0)
            ? Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Usuarios por mes",
                    style: TextStyle(fontSize: 24),
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
                        "Cantidad de usuarios activos al momento: ${countUsers}",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      )),
                ],
              ),
      ),
    );
  }

  void _getUsersActiveSubscription() {
    _usersActiveSubscription = FirebaseFirestore.instance
        .collection("feeders")
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        for (var doc in event.docs) {
          var feedersdata = doc.data();
          if (!users.contains(feedersdata["ownerId"])) {
            users.add(feedersdata["ownerId"]);
            countUsers++;
          }
        }
        setState(() {
          data = [...data];
          data[10] = UserBar(
              month: "11",
              users: countUsers,
              barColor: charts.ColorUtil.fromDartColor(
                  Color.fromARGB(255, 1, 73, 131)));
        });
      } else {
        setState(() {});
      }
    });
  }
}

class UserBar {
  final String month;
  final int users;
  final charts.Color barColor;

  UserBar({required this.month, required this.users, required this.barColor});
}
