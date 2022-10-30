import 'package:feedtech/widgets/firebase_login.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class FoodDayPage extends StatelessWidget {
  const FoodDayPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<TimeLine> data = [
      TimeLine(
        day: 1,
        portions: 5,
        barColor:
            charts.ColorUtil.fromDartColor(Color.fromARGB(255, 20, 243, 180)),
      ),
      TimeLine(
        day: 2,
        portions: 7,
        barColor:
            charts.ColorUtil.fromDartColor(Color.fromARGB(255, 20, 243, 180)),
      ),
      TimeLine(
        day: 3,
        portions: 9,
        barColor:
            charts.ColorUtil.fromDartColor(Color.fromARGB(255, 20, 243, 180)),
      ),
      TimeLine(
        day: 4,
        portions: 2,
        barColor:
            charts.ColorUtil.fromDartColor(Color.fromARGB(255, 20, 243, 180)),
      ),
      TimeLine(
        day: 5,
        portions: 9,
        barColor:
            charts.ColorUtil.fromDartColor(Color.fromARGB(255, 20, 243, 180)),
      ),
      TimeLine(
        day: 8,
        portions: 5,
        barColor:
            charts.ColorUtil.fromDartColor(Color.fromARGB(255, 20, 243, 180)),
      ),
      TimeLine(
        day: 12,
        portions: 4,
        barColor:
            charts.ColorUtil.fromDartColor(Color.fromARGB(255, 20, 243, 180)),
      ),
      TimeLine(
        day: 16,
        portions: 3,
        barColor:
            charts.ColorUtil.fromDartColor(Color.fromARGB(255, 20, 243, 180)),
      ),
    ];

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
              "Dias que a comido la mascota",
            ),
            Expanded(
              child: charts.LineChart(
                timeline,
                domainAxis: const charts.NumericAxisSpec(
                  tickProviderSpec:
                      charts.BasicNumericTickProviderSpec(zeroBound: false),
                  viewport: charts.NumericExtents(0, 30),
                ),
              ),
            ),
            Text(
              "Tiempo",
            ),
            SizedBox(height: 40),
            Container(
                height: MediaQuery.of(context).size.height / 3,
                child: Text(
                  "Esta grafica indica la cantidad de comida en gramos que ha comido tu mascota por dia",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                )),
          ],
        ),
      ),
    );
  }
}

class TimeLine {
  final int day;
  final int portions;
  final charts.Color barColor;

  TimeLine({required this.day, required this.portions, required this.barColor});
}
