import 'package:feedtech/widgets/firebase_login.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class QuantityFoodPage extends StatelessWidget {
  const QuantityFoodPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<TimeLine> data = [
      TimeLine(
        day: "1",
        portions: 50,
        barColor:
            charts.ColorUtil.fromDartColor(Color.fromARGB(255, 20, 243, 180)),
      )
    ];

    List<charts.Series<TimeLine, String>> capacity = [
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
              child: charts.BarChart(
                capacity,
                domainAxis: const charts.NumericAxisSpec(
                  viewport: charts.NumericExtents(0, 100),
                ),
              ),
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
  final String day;
  final int portions;
  final charts.Color barColor;

  TimeLine({required this.day, required this.portions, required this.barColor});
}
