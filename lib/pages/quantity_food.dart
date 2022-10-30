import 'package:feedtech/widgets/firebase_login.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class QuantityFoodPage extends StatelessWidget {
  const QuantityFoodPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<CapacityBar> data = [
      CapacityBar(
        day: "",
        portions: 50,
        barColor:
            charts.ColorUtil.fromDartColor(Color.fromARGB(255, 235, 23, 23)),
      )
    ];

    List<charts.Series<CapacityBar, String>> capacity = [
      charts.Series(
          id: "Time history",
          data: data,
          domainFn: (CapacityBar series, _) => series.day,
          measureFn: (CapacityBar series, _) => series.portions,
          colorFn: (CapacityBar series, _) => series.barColor)
    ];

    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Capacidad del alimentador"),
          ],
        ),
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
                primaryMeasureAxis: const charts.NumericAxisSpec(
                  tickProviderSpec:
                      charts.BasicNumericTickProviderSpec(zeroBound: false),
                  viewport: charts.NumericExtents(0, 100),
                ),
              ),
            ),
            SizedBox(height: 40),
            Container(
                height: MediaQuery.of(context).size.height / 3,
                child: Text(
                  "Porcentaje de capacidad llena del alimentador",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                )),
          ],
        ),
      ),
    );
  }
}

class CapacityBar {
  final String day;
  final int portions;
  final charts.Color barColor;

  CapacityBar(
      {required this.day, required this.portions, required this.barColor});
}
