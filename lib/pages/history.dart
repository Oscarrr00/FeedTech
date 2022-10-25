import 'package:feedtech/widgets/firebase_login.dart';
import 'package:flutter/material.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<dynamic>? history;
    return Scaffold(
      body: (history != null)
                  ? Expanded(
                      child: Container(
                        child: ListView(
                          scrollDirection: Axis.vertical,
                          children: List.generate(history.length, (index) {
                            return ItemHistory(thistory: history[index]);
                          }),
                        ),
                      ),
                    )
                  : Expanded(child: Container()),,
    );
  }
}
