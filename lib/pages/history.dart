import 'package:feedtech/widgets/firebase_login.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HistoryPage extends StatelessWidget {
  const HistoryPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<TimeLine> data = [
      TimeLine(
        hour: 1,
        portions: 2,
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
      TimeLine(
        hour: 2,
        portions: 3,
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
      TimeLine(
        hour: 3,
        portions: 4,
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
      TimeLine(
        hour: 4,
        portions: 1,
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
      TimeLine(
        hour: 5,
        portions: 4,
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
      TimeLine(
        hour: 6,
        portions: 4,
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
      TimeLine(
        hour: 7,
        portions: 3,
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
      TimeLine(
        hour: 8,
        portions: 3,
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
    ];

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
              child: charts.LineChart(timeline,
                  domainAxis: const charts.NumericAxisSpec(
                    tickProviderSpec:
                        charts.BasicNumericTickProviderSpec(zeroBound: false),
                    viewport: charts.NumericExtents(0, 24),
                  )),
            ),
            Text(
              "Tiempo",
            ),
            SizedBox(height: 40),
            Container(
                height: MediaQuery.of(context).size.height / 3,
                child: Text(
                    "Esta grafica muestra a que horas a comido tu mascota")),
          ],
        ),
      ),
    );
  }
}

class TimeLine {
  final int hour;
  final int portions;
  final charts.Color barColor;

  TimeLine(
      {required this.hour, required this.portions, required this.barColor});
}
