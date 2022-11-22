import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedtech/blocs/feeders/bloc/pair_feeders_repository.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class FoodHoursPage extends StatefulWidget {
  final Feeder feeder;
  const FoodHoursPage({
    Key? key,
    required this.feeder,
  }) : super(key: key);

  @override
  State<FoodHoursPage> createState() => _FoodHoursPageState();
}

class _FoodHoursPageState extends State<FoodHoursPage> {
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _feedPerHourSubscription;
  late List<TimeLine> data;

  void initState() {
    data = [];
    for (int i = 0; i <= 24; i++) {
      data.add(
        TimeLine(
          hour: i,
          times: 0,
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
        measureFn: (TimeLine series, _) => series.times,
        colorFn: (TimeLine series, _) => series.barColor,
      )
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Veces que se vació"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(flex: 20, child: SizedBox.expand()),
            Text(
              "Horas a las que tu mascota vació el plato de alimento.",
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
              "Esta grafica muestra a que hora comió tu mascota este día y la cantidad de veces que se vació el plato.",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Expanded(flex: 30, child: SizedBox.expand()),
          ],
        ),
      ),
    );
  }

  void _getFeedPerHourSubscription() {
    _feedPerHourSubscription = FirebaseFirestore.instance
        .collection("foodPresent")
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
              times: 0,
              barColor: charts.ColorUtil.fromDartColor(Colors.blue),
            ),
          );
        }
        List<TimeLine> newData = data;
        for (var doc in event.docs) {
          final feedPerHour = doc.data();
          final DateTime date = feedPerHour["timestamp"].toDate();
          final timeNow = DateTime.now();
          if (date.day == timeNow.day &&
              date.month == timeNow.month &&
              timeNow.year == timeNow.year) {
            if (feedPerHour["hasFoodPresent"]) {
              continue;
            }
            if (newData.isEmpty) {
              newData.add(TimeLine(
                  hour: date.hour,
                  times: 1,
                  barColor: charts.ColorUtil.fromDartColor(Colors.blue)));
            } else {
              final index =
                  newData.indexWhere((time) => date.hour == time.hour);
              if (index >= 0) {
                newData[index].times++;
              } else {
                newData.add(TimeLine(
                    hour: date.hour,
                    times: 1,
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
  int times;
  final charts.Color barColor;

  TimeLine({required this.hour, required this.times, required this.barColor});
}
