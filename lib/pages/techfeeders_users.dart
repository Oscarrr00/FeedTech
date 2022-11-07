import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class TechFeedersUsers extends StatelessWidget {
  const TechFeedersUsers({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<UserBar> data = [
      UserBar(
        month: "1",
        users: 20,
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
      UserBar(
        month: "2",
        users: 10,
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
      UserBar(
        month: "3",
        users: 15,
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
      UserBar(
        month: "4",
        users: 7,
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
      UserBar(
        month: "5",
        users: 14,
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
      UserBar(
        month: "6",
        users: 17,
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
      UserBar(
        month: "7",
        users: 21,
        barColor: charts.ColorUtil.fromDartColor(Colors.green),
      ),
    ];

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
        title: Text("Alimentadores por usuario"),
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
              ),
            ),
            SizedBox(height: 40),
            Container(
                height: MediaQuery.of(context).size.height / 3,
                child: Text(
                  "Cantidad de usuarios por cuantos alimentadores tienen.",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                )),
          ],
        ),
      ),
    );
  }
}

class UserBar {
  final String month;
  final int users;
  final charts.Color barColor;

  UserBar({required this.month, required this.users, required this.barColor});
}
