import 'package:flutter/material.dart';

class CardBuilder extends StatelessWidget {
  final String heading;
  final String number;
  const CardBuilder({Key? key, required this.heading, required this.number})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Card(
        elevation: 4.0,
        child: Column(
          children: [
            ListTile(
              title: Text(heading),
            ),
            Container(
                alignment: Alignment.center,
                height: 180.0,
                child: Text(number,
                    style:
                        TextStyle(fontSize: 45, fontWeight: FontWeight.bold))),
            Container(
              padding: EdgeInsets.all(16.0),
              alignment: Alignment.centerLeft,
            ),
          ],
        ));
  }
}
