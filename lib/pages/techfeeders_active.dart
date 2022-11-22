import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TechFeedersActive extends StatefulWidget {
  const TechFeedersActive({
    Key? key,
  }) : super(key: key);

  @override
  State<TechFeedersActive> createState() => _TechFeedersActiveState();
}

class _TechFeedersActiveState extends State<TechFeedersActive> {
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _feedersActiveSubscription;
  var countFeeders = 0;
  List<FeederBar> data = [
    FeederBar(
      month: "1",
      feeders: 11,
      barColor: charts.ColorUtil.fromDartColor(Colors.orange),
    ),
    FeederBar(
      month: "2",
      feeders: 10,
      barColor: charts.ColorUtil.fromDartColor(Colors.orange),
    ),
    FeederBar(
      month: "3",
      feeders: 12,
      barColor: charts.ColorUtil.fromDartColor(Colors.orange),
    ),
    FeederBar(
      month: "4",
      feeders: 17,
      barColor: charts.ColorUtil.fromDartColor(Colors.orange),
    ),
    FeederBar(
      month: "5",
      feeders: 16,
      barColor: charts.ColorUtil.fromDartColor(Colors.orange),
    ),
    FeederBar(
      month: "6",
      feeders: 4,
      barColor: charts.ColorUtil.fromDartColor(Colors.orange),
    ),
    FeederBar(
      month: "7",
      feeders: 7,
      barColor: charts.ColorUtil.fromDartColor(Colors.orange),
    ),
    FeederBar(
      month: "8",
      feeders: 12,
      barColor: charts.ColorUtil.fromDartColor(Colors.orange),
    ),
    FeederBar(
      month: "9",
      feeders: 2,
      barColor: charts.ColorUtil.fromDartColor(Colors.orange),
    ),
    FeederBar(
      month: "10",
      feeders: 8,
      barColor: charts.ColorUtil.fromDartColor(Colors.orange),
    ),
    FeederBar(
      month: "11",
      feeders: 5,
      barColor: charts.ColorUtil.fromDartColor(Colors.orange),
    ),
    FeederBar(
      month: "12",
      feeders: 0,
      barColor: charts.ColorUtil.fromDartColor(Colors.orange),
    )
  ];
  void initState() {
    _getFeedersActiveSubscription();
    super.initState();
  }

  @override
  void dispose() async {
    _feedersActiveSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<FeederBar, String>> capacity = [
      charts.Series(
          id: "Time history",
          data: data,
          domainFn: (FeederBar series, _) => series.month,
          measureFn: (FeederBar series, _) => series.feeders,
          colorFn: (FeederBar series, _) => series.barColor)
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Numero de alimentadores activos"),
      ),
      body: (data.length <= 0)
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "Alimentadores activos por mes",
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
                        "Cantidad de alimentadores activos al mommento: ${countFeeders}",
                        style: TextStyle(fontSize: 20),
                        textAlign: TextAlign.center,
                      )),
                ],
              ),
            ),
    );
  }

  void _getFeedersActiveSubscription() {
    _feedersActiveSubscription = FirebaseFirestore.instance
        .collection("feeders")
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        countFeeders = event.docs.length;
        setState(() {
          data = [...data];
          data[10] = FeederBar(
            month: "11",
            feeders: countFeeders,
            barColor: charts.ColorUtil.fromDartColor(
                Color.fromARGB(255, 214, 101, 1)),
          );
        });
      } else {
        setState(() {});
      }
    });
  }
}

class FeederBar {
  final String month;
  final int feeders;
  final charts.Color barColor;

  FeederBar(
      {required this.month, required this.feeders, required this.barColor});
}
