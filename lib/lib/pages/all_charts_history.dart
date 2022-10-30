import 'package:feedtech/items/selected_chart.dart';
import 'package:feedtech/pages/food_per_day.dart';
import 'package:feedtech/pages/food_per_hours.dart';
import 'package:feedtech/pages/grams_per_hour.dart';
import 'package:feedtech/pages/heatmap_food.dart';
import 'package:feedtech/pages/quantity_food.dart';
import 'package:feedtech/widgets/firebase_login.dart';
import 'package:flutter/material.dart';

class AllChartsPage extends StatelessWidget {
  const AllChartsPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text("Métricas"),
          ],
        ),
      ),
      body: Column(children: [
        SelectedChart(
          text: "¿Cuánto ha comido tu mascota cada día?",
          image: "assets/images/Linechart.png",
          page: FoodDayPage(),
        ),
        Expanded(
          child: Row(
            children: [
              SelectedChart(
                  text: "Comida en el alimentador",
                  image: "assets/images/quantity.png",
                  page: QuantityFoodPage()),
              SelectedChart(
                  text: "¿Cómo ha comido tu mascota?",
                  image: "assets/images/color_chart.png",
                  page: HeatMapFoodPage())
            ],
          ),
        ),
        Expanded(
          child: Row(
            children: [
              SelectedChart(
                text: "¿A que hora comió tu mascota",
                image: "assets/images/line_dots_chart.png",
                page: FoodHoursPage(),
              ),
              SelectedChart(
                  text: "Cantidad que comió tu mascota por hora",
                  image: "assets/images/line_dots_chart.png",
                  page: GramsHoursPage()),
            ],
          ),
        ),
      ]),
    );
  }
}
