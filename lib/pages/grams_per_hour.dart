import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedtech/blocs/feeders/bloc/pair_feeders_repository.dart';
import 'package:feedtech/widgets/firebase_login.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class GramsHoursPage extends StatefulWidget {
  final Feeder feeder;
  const GramsHoursPage({
    Key? key,
    required this.feeder,
  }) : super(key: key);

  @override
  State<GramsHoursPage> createState() => _GramsHoursPageState();
}

class _GramsHoursPageState extends State<GramsHoursPage> {
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _feedPerHourSubscription;
  late List<TimeLine> data;
  void initState() {
    data = [];
    for (int i = 0; i <= 24; i++) {
      data.add(
        TimeLine(
          hour: i,
          portions: 0,
          barColor: charts.ColorUtil.fromDartColor(Colors.blue),
        ),
      );
    }
    _getFeedPerHourSubscription();
    super.initState();
  }

  @override
  void dispose() async {
    _feedPerHourSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<TimeLine, num>> timeline = [
      charts.Series(
          id: "Time history",
          data: data,
          domainFn: (TimeLine series, _) => series.hour,
          measureFn: (TimeLine series, _) => series.portions,
          colorFn: (TimeLine series, _) => series.barColor)
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Porciones consumidas por hora"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(flex: 20, child: SizedBox.expand()),
            Text(
              "Porciones de alimento servidas por hora en el último día.",
              style: TextStyle(fontSize: 18),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 40),
            Expanded(
              flex: 50,
              child: charts.LineChart(
                timeline,
                domainAxis: const charts.NumericAxisSpec(
                  tickProviderSpec:
                      charts.BasicNumericTickProviderSpec(zeroBound: false),
                  viewport: charts.NumericExtents(0, 24),
                ),
                defaultRenderer:
                    new charts.LineRendererConfig(includePoints: true),
              ),
            ),
            Text(
              "Tiempo",
            ),
            SizedBox(height: 40),
            Text(
              "Esta grafica indica cuántas porciones han sido servidas a tu mascota cada hora en el último día.",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Expanded(flex: 30, child: SizedBox.expand()),
          ],
        ),
      ),
    );
  }

  int _checkAlreadyInList(dynamic newData, int hour) {
    for (int i = 0; i < newData.length; i++) {
      if (newData[i].hour == hour) {
        return i;
      }
    }
    return -1;
  }

  void _getFeedPerHourSubscription() {
    _feedPerHourSubscription = FirebaseFirestore.instance
        .collection("foodGiven")
        .where(
          "feeder",
          isEqualTo: FirebaseFirestore.instance
              .collection("feeders")
              .doc(widget.feeder.feederId),
        )
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        data = [];
        for (int i = 0; i <= 24; i++) {
          data.add(
            TimeLine(
              hour: i,
              portions: 0,
              barColor: charts.ColorUtil.fromDartColor(Colors.blue),
            ),
          );
        }
        List<TimeLine> newData = data;
        for (var doc in event.docs) {
          var feedPerHour = doc.data();
          var date = feedPerHour["timestamp"].toDate();
          if (date.day == DateTime.now().day) {
            if (newData.length <= 0) {
              newData.add(TimeLine(
                  hour: date.hour,
                  portions: feedPerHour["numberOfPortions"],
                  barColor: charts.ColorUtil.fromDartColor(Colors.blue)));
            } else {
              var index = _checkAlreadyInList(newData, date.hour);
              if (index != -1) {
                int portions = feedPerHour["numberOfPortions"].round();
                newData[index].portions += portions;
              } else {
                newData.add(TimeLine(
                    hour: date.hour,
                    portions: feedPerHour["numberOfPortions"],
                    barColor: charts.ColorUtil.fromDartColor(Colors.blue)));
              }
            }
          }
          newData.sort((a, b) => a.hour.compareTo(b.hour));
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

class TimeLine {
  final int hour;
  int portions;
  final charts.Color barColor;

  TimeLine(
      {required this.hour, required this.portions, required this.barColor});
}
