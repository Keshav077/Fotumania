import 'package:flutter/material.dart';
import 'package:fotumania/providers/photographers_provider.dart';
import 'package:provider/provider.dart';

class TestScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    PhotographersProvider photographersProvider =
        Provider.of<PhotographersProvider>(context, listen: false);
    return Scaffold(
        body: Align(
      alignment: Alignment.center,
      child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
        ElevatedButton(
          child: Text("Create Photographer"),
          onPressed: () {
            photographersProvider.createPhotographer("12345");
          },
        ),
        ElevatedButton(
          child: Text("Fetch Photographer"),
          onPressed: () {
            photographersProvider.fetchAllPhotographers();
          },
        ),
        ElevatedButton(
          onPressed: () {
            photographersProvider.assignOrder('-M_QwOfLh135ldizj5vu', 'o1');
          },
          child: Text("Assign Order"),
        ),
        ElevatedButton(
          onPressed: () {
            photographersProvider.acceptOrder('-M_QwOfLh135ldizj5vu', 'o1');
          },
          child: Text("Accept Order"),
        ),
        ElevatedButton(
          onPressed: () {
            photographersProvider.orderCompleted('-M_QwOfLh135ldizj5vu', 'o1');
          },
          child: Text("Complete Order"),
        ),
      ]),
    ));
  }
}
