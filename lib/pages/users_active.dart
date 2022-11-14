import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class UsersActive extends StatelessWidget {
  const UsersActive({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<UserBar> data = [
      UserBar(
        month: "1",
        users: 50,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue),
      ),
      UserBar(
        month: "2",
        users: 30,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue),
      ),
      UserBar(
        month: "3",
        users: 70,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue),
      ),
      UserBar(
        month: "4",
        users: 20,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue),
      ),
      UserBar(
        month: "5",
        users: 30,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue),
      ),
      UserBar(
        month: "6",
        users: 80,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue),
      ),
      UserBar(
        month: "7",
        users: 50,
        barColor: charts.ColorUtil.fromDartColor(Colors.blue),
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
        title: Text("Numero de Usuarios activos"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              "Usuarios por mes",
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
                  "Cantidad de usuarios activos al mommento: 160",
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
