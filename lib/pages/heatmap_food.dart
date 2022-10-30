import 'package:feedtech/widgets/firebase_login.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class HeatMapFoodPage extends StatelessWidget {
  const HeatMapFoodPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("¿Cómo ha comido tu mascota?"),
            ],
          ),
        ),
        body: Container());
  }
}
