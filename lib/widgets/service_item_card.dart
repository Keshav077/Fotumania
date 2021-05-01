import 'package:flutter/material.dart';
import 'package:fotumania/screens/service_details_screen.dart';
import 'package:provider/provider.dart';

import '../providers/user_provider.dart';

import '../screens/service_classes.dart';

import '../models/item_data.dart';

class ServiceItem extends StatelessWidget {
  final ItemData item;
  final double widthRatio;

  ServiceItem({this.item, this.widthRatio});

  void _nextPage(BuildContext context) {
    if (!item.hasClasses) {
      Navigator.of(context).pushNamed(
        ServiceDetails.routeName,
        arguments: {
          "itemData": item,
          "classInfo": (item.classes[0]),
        },
      );
    } else {
      Navigator.of(context)
          .pushNamed(ServiceClassesScreen.routeName, arguments: item);
    }
  }

  @override
  Widget build(BuildContext context) {
    Size mqs = MediaQuery.of(context).size;
    return ChangeNotifierProvider(
      create: (ctx) => UserProvider(),
      child: InkWell(
        onTap: () {
          _nextPage(context);
        },
        child: Container(
          decoration: BoxDecoration(
              image: DecorationImage(
                  image: NetworkImage(item.imageUrl), fit: BoxFit.cover),
              borderRadius: BorderRadius.all(
                Radius.circular(mqs.height > 800 ? 20 : 10),
              ),
              boxShadow: [
                BoxShadow(
                  spreadRadius: -2,
                  blurRadius: 3,
                  color: Colors.black,
                  offset: Offset(2, 2),
                )
              ]),
          margin: EdgeInsets.only(
            right: 5,
            top: 5,
            bottom: 5,
          ),
          width: mqs.width *
              (mqs.height > 2000
                  ? widthRatio - 0.2
                  : mqs.height > 800
                      ? widthRatio
                      : widthRatio - 0.1),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.2),
              borderRadius: BorderRadius.circular(mqs.height > 800 ? 20 : 5),
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.5),
                borderRadius: BorderRadius.circular(mqs.height > 800 ? 20 : 5),
              ),
              // bottomLeft: Radius.circular(20),
              alignment: Alignment.center,
              margin: EdgeInsets.only(
                  top: MediaQuery.of(context).size.height * 0.35),
              child: FittedBox(
                child: Text(
                  item.name,
                  style: Theme.of(context).textTheme.headline6,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
