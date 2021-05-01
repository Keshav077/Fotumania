import 'package:flutter/material.dart';

class ReviewList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height * 0.2;
    double width = MediaQuery.of(context).size.height * 0.4;
    return Card(
      child: ListView(scrollDirection: Axis.horizontal, children: [
        Container(
          height: height,
          width: width,
          child: Card(
            color: Colors.amber,
          ),
        ),
        Container(
          height: height,
          width: width,
          child: Card(
            color: Colors.green,
          ),
        ),
        Container(
          height: height,
          width: width,
          child: Card(
            color: Colors.purple,
          ),
        ),
      ]),
    );
  }
}
