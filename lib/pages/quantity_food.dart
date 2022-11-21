import 'dart:async';

import 'package:feedtech/blocs/feeders/bloc/pair_feeders_repository.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class QuantityFoodPage extends StatefulWidget {
  final Feeder feeder;
  const QuantityFoodPage({
    Key? key,
    required this.feeder,
  }) : super(key: key);

  @override
  State<QuantityFoodPage> createState() => _QuantityFoodPageState();
}

class _QuantityFoodPageState extends State<QuantityFoodPage> {
  late final StreamSubscription<QuerySnapshot<Map<String, dynamic>>>
      _foodLeftSubscription;
  double? percentageOfFoodLeft;

  @override
  void initState() {
    _getFirestoreFoodLeftSubscription();
    super.initState();
  }

  @override
  void dispose() async {
    _foodLeftSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Capacidad del alimentador"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.max,
          children: [
            Expanded(flex: 6, child: SizedBox.expand()),
            Text(
              "Cantidad de alimento restante",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
              textAlign: TextAlign.center,
            ),
            SizedBox(height: 32),
            percentageOfFoodLeft == null
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : percentageOfFoodLeft! <= 100
                    ? CircularPercentIndicator(
                        radius: 100,
                        lineWidth: 20.0,
                        percent: percentageOfFoodLeft! / 100,
                        animation: true,
                        animateFromLastPercent: true,
                        animationDuration: 800,
                        circularStrokeCap: CircularStrokeCap.round,
                        center: new Text(
                          "${percentageOfFoodLeft!.toStringAsFixed(2)}%",
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 24),
                        ),
                        progressColor: percentageOfFoodLeft! >= 30
                            ? Colors.green
                            : Colors.red,
                      )
                    : Text(
                        "Sin datos",
                        style: TextStyle(
                            fontSize: 16, fontWeight: FontWeight.w500),
                        textAlign: TextAlign.center,
                      ),
            Expanded(flex: 8, child: SizedBox.expand()),
          ],
        ),
      ),
    );
  }

  void _getFirestoreFoodLeftSubscription() {
    _foodLeftSubscription = FirebaseFirestore.instance
        .collection("foodLeft")
        .where(
          "feeder",
          isEqualTo: FirebaseFirestore.instance
              .collection("feeders")
              .doc(widget.feeder.feederId),
        )
        .orderBy("timestamp", descending: true)
        .limit(1)
        .snapshots()
        .listen((event) {
      if (event.docs.isNotEmpty) {
        final double percentageOfFoodLeftFirestore =
            event.docs.first.data()["percentageOfFoodLeft"];
        setState(() {
          percentageOfFoodLeft = percentageOfFoodLeftFirestore;
        });
      } else {
        setState(() {
          percentageOfFoodLeft = 200;
        });
      }
    });
  }
}
