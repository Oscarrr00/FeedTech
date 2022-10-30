import 'package:flutter/material.dart';

class SelectedChart extends StatelessWidget {
  final String text;
  final String image;
  final dynamic page;
  SelectedChart({
    Key? key,
    required this.text,
    required this.image,
    this.page,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => page,
            ),
          );
        },
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.all(10),
          decoration: BoxDecoration(border: Border.all(color: Colors.black)),
          child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            Image.asset("${image}", height: 100, width: 100),
            Text("${text}",
                style: TextStyle(fontSize: 20), textAlign: TextAlign.center)
          ]),
        ),
      ),
    );
  }
}
