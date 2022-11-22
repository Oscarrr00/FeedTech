import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:feedtech/blocs/feeders/bloc/pair_feeders_repository.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class FoodDayPage extends StatefulWidget {
  final Feeder feeder;
  const FoodDayPage({
    Key? key,
    required this.feeder,
  }) : super(key: key);

  @override
  State<FoodDayPage> createState() => _FoodDayPageState();
}

class _FoodDayPageState extends State<FoodDayPage> {
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _feedPerDaySubscription;
  late List<TimeLine> data;
  void initState() {
    data = [];
    for (int i = 0; i <= 24; i++) {
      data.add(
        TimeLine(
          day: i,
          portions: 0,
          barColor: charts.ColorUtil.fromDartColor(Colors.blue),
        ),
      );
    }
    _getFeedPerDaySubscription();
    super.initState();
  }

  @override
  void dispose() async {
    _feedPerDaySubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    List<charts.Series<TimeLine, num>> timeline = [
      charts.Series(
          id: "Time history",
          data: data,
          domainFn: (TimeLine series, _) => series.day,
          measureFn: (TimeLine series, _) => series.portions,
          colorFn: (TimeLine series, _) => series.barColor)
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("Horarios de Comida"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Expanded(flex: 20, child: SizedBox.expand()),
            Text(
              "Porciones de alimento servidas por día en el último mes.",
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
                  viewport: charts.NumericExtents(0, 31),
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
              "Esta grafica indica la cantidad de porciones que ha comido tu mascota por dia en el último mes.",
              style: TextStyle(fontSize: 20),
              textAlign: TextAlign.center,
            ),
            Expanded(flex: 30, child: SizedBox.expand()),
          ],
        ),
      ),
    );
  }

  int _checkAlreadyInList(dynamic newData, int day) {
    for (int i = 0; i < newData.length; i++) {
      if (newData[i].day == day) {
        return i;
      }
    }
    return -1;
  }

  void _getFeedPerDaySubscription() {
    _feedPerDaySubscription = FirebaseFirestore.instance
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
        for (int i = 0; i <= 31; i++) {
          data.add(
            TimeLine(
              day: i,
              portions: 0,
              barColor: charts.ColorUtil.fromDartColor(Colors.blue),
            ),
          );
        }
        List<TimeLine> newData = data;
        for (var doc in event.docs) {
          var feedPerHour = doc.data();
          var date = feedPerHour["timestamp"].toDate();
          if (date.month == DateTime.now().month) {
            if (newData.length <= 0) {
              newData.add(TimeLine(
                  day: date.day,
                  portions: feedPerHour["numberOfPortions"],
                  barColor: charts.ColorUtil.fromDartColor(
                      Color.fromARGB(255, 20, 243, 180))));
            }
            var index = _checkAlreadyInList(newData, date.day);
            if (index != -1) {
              int portions = feedPerHour["numberOfPortions"].round();
              newData[index].portions += portions;
            } else {
              newData.add(TimeLine(
                  day: date.day,
                  portions: feedPerHour["numberOfPortions"],
                  barColor: charts.ColorUtil.fromDartColor(
                      Color.fromARGB(255, 20, 243, 180))));
            }
          }
          newData.sort((a, b) => a.day.compareTo(b.day));
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
  final int day;
  int portions;
  final charts.Color barColor;

  TimeLine({required this.day, required this.portions, required this.barColor});
}
