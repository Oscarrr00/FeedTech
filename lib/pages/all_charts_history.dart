import 'package:feedtech/blocs/feeders/bloc/pair_feeders_repository.dart';
import 'package:feedtech/items/selected_chart.dart';
import 'package:feedtech/pages/food_per_day.dart';
import 'package:feedtech/pages/food_per_hours.dart';
import 'package:feedtech/pages/grams_per_hour.dart';
import 'package:feedtech/pages/heatmap_food.dart';
import 'package:feedtech/pages/quantity_food.dart';
import 'package:feedtech/widgets/firebase_login.dart';
import 'package:flutter/material.dart';

class AllChartsPage extends StatelessWidget {
  final Feeder feeder;
  const AllChartsPage({
    Key? key,
    required this.feeder,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Métricas"),
      ),
      body: Column(children: [
        SelectedChart(
          text: "¿Cuántas porciones ha comido tu mascota por día?",
          image: "assets/images/Linechart.png",
          page: FoodDayPage(feeder: feeder),
        ),
        Expanded(
          child: Row(
            children: [
              SelectedChart(
                  text: "Cantidad de alimento restante",
                  image: "assets/images/quantity.png",
                  page: QuantityFoodPage(
                    feeder: feeder,
                  )),
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
                text: "¿A qué hora se acabó el alimento del plato?",
                image: "assets/images/line_dots_chart.png",
                page: FoodHoursPage(feeder: feeder),
              ),
              SelectedChart(
                  text: "Cantidad de porciones servidas por hora",
                  image: "assets/images/line_dots_chart.png",
                  page: GramsHoursPage(feeder: feeder)),
            ],
          ),
        ),
      ]),
    );
  }
}
