import 'package:feedtech/items/selected_chart.dart';
import 'package:feedtech/pages/techfeeders_active.dart';
import 'package:feedtech/pages/techfeeders_users.dart';
import 'package:feedtech/pages/users_active.dart';
import 'package:flutter/material.dart';

class AdminPage extends StatelessWidget {
  const AdminPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Metricas Administrador'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SelectedChart(
              text: "Usuarios activos",
              image: "assets/images/bar_graph.png",
              page: UsersActive(),
            ),
            SelectedChart(
              text: "Alimentadores activos",
              image: "assets/images/bar_graph.png",
              page: TechFeedersActive(),
            ),
            SelectedChart(
              text: "Promedio de alimentadores por usuario",
              image: "assets/images/bar_chart.png",
              page: TechFeedersUsers(),
            ),
          ],
        ));
  }
}
