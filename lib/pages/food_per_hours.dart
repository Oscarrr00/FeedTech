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
  List<TimeLine> data = [];
  void initState() {
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
          colorFn: (TimeLine series, _) => series.barColor)
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Horarios de Comida"),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(17.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Horas que a comido la mascota",
            ),
            Expanded(
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
            Container(
                height: MediaQuery.of(context).size.height / 3,
                child: Text(
                  "Esta grafica muestra a que horas a comido tu mascota",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                )),
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
        List<TimeLine> newData = [];
        for (var doc in event.docs) {
          var feedPerHour = doc.data();
          var date = feedPerHour["timestamp"].toDate();
          if (date.day == DateTime.now().day) {
            if (!feedPerHour["hasFoodPresent"]) {
              if (newData.length <= 0) {
                newData.add(TimeLine(
                    hour: date.hour,
                    times: 1,
                    barColor: charts.ColorUtil.fromDartColor(Colors.blue)));
              } else {
                var index = _checkAlreadyInList(newData, date.hour);
                if (index != -1) {
                  newData[index].times++;
                } else {
                  newData.add(TimeLine(
                      hour: date.hour,
                      times: 1,
                      barColor: charts.ColorUtil.fromDartColor(Colors.blue)));
                }
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
