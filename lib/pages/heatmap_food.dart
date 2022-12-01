import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_heatmap_calendar/flutter_heatmap_calendar.dart';

class HeatMapFoodPage extends StatelessWidget {
  const HeatMapFoodPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("Hábitos alimenticios"),
        ),
        body: Stack(
          children: [
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    "¿Cómo ha comido tu mascota?",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                    textAlign: TextAlign.center,
                  ),
                  SizedBox(height: 16),
                  Card(child: HeatMapWidget()),
                  SizedBox(height: 72),
                ],
              ),
            ),
            Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(3),
                color: Color.fromARGB(81, 0, 0, 0),
              ),
              height: double.infinity,
              width: double.infinity,
            ),
            BottomPremiumWidget(),
          ],
        ));
  }
}

class BottomPremiumWidget extends StatelessWidget {
  const BottomPremiumWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        color: Colors.white,
        width: double.infinity,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 16),
              Text(
                "Encontraste una función premium!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 8),
              Text("Suscríbete para ver!"),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class HeatMapWidget extends StatelessWidget {
  const HeatMapWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: HeatMapCalendar(
        datasets: Map.fromEntries(
          List.generate(
            30,
            (index) {
              return MapEntry(
                  DateTime(2022, 12, index + 1), Random.secure().nextInt(101));
            },
          ),
        ),
        initDate: DateTime(2022, 12, 1),
        colorMode: ColorMode.color,
        size: 38,
        colorTipCount: 20,
        colorsets: {
          0: Color.fromARGB(255, 244, 67, 54),
          5: Color.fromARGB(255 - 25 * 1, 244, 67, 54),
          10: Color.fromARGB(255 - 25 * 2, 244, 67, 54),
          15: Color.fromARGB(255 - 25 * 3, 244, 67, 54),
          20: Color.fromARGB(255 - 25 * 4, 244, 67, 54),
          25: Color.fromARGB(255 - 25 * 5, 244, 67, 54),
          30: Color.fromARGB(255 - 25 * 6, 244, 67, 54),
          35: Color.fromARGB(255 - 25 * 7, 244, 67, 54),
          40: Color.fromARGB(255 - 25 * 8, 244, 67, 54),
          45: Color.fromARGB(255 - 25 * 9, 244, 67, 54),
          50: Color.fromARGB(255 - 25 * 10, 76, 175, 80),
          55: Color.fromARGB(255 - 25 * 9, 76, 175, 80),
          60: Color.fromARGB(255 - 25 * 8, 76, 175, 80),
          65: Color.fromARGB(255 - 25 * 7, 76, 175, 80),
          70: Color.fromARGB(255 - 25 * 6, 76, 175, 80),
          75: Color.fromARGB(255 - 25 * 5, 76, 175, 80),
          80: Color.fromARGB(255 - 25 * 4, 76, 175, 80),
          85: Color.fromARGB(255 - 25 * 3, 76, 175, 80),
          90: Color.fromARGB(255 - 25 * 2, 76, 175, 80),
          95: Color.fromARGB(255 - 25 * 1, 76, 175, 80),
          100: Color.fromARGB(255, 76, 175, 80),
        },
        margin: EdgeInsets.all(3),
        colorTipHelper: [
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 8, bottom: 8),
              child: Text(
                "Mal",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(top: 8, bottom: 8),
              child: Text(
                "Bien",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                ),
                textAlign: TextAlign.center,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
