import 'package:flutter/material.dart';
import 'package:fotumania/models/item_data.dart';
import 'package:fotumania/screens/service_details_screen.dart';

class ServiceClassesScreen extends StatelessWidget {
  static const routeName = "/service-classes";
  // final ItemData itemData;
  // ServiceClassesScreen(this.itemData);

  Widget buildClass(
    Map<String, dynamic> serviceClass,
    BuildContext context,
    ItemData itemData,
  ) {
    Size mqs = MediaQuery.of(context).size;
    TextStyle style = TextStyle(
        fontFamily: 'Oswald',
        fontSize: mqs.height * 0.045,
        color: Colors.white,
        fontWeight: FontWeight.bold);
    return InkWell(
      onTap: () {
        Navigator.of(context).pushNamed(ServiceDetails.routeName,
            arguments: {"itemData": itemData, "classInfo": serviceClass});
      },
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25),
          color: Colors.grey[900],
          boxShadow: [
            BoxShadow(
                color: Colors.black45,
                blurRadius: 5,
                offset: Offset(-2, 2),
                spreadRadius: 2)
          ],
          // gradient: LinearGradient(
          //   colors: [
          //     Colors.grey[800],
          //     Colors.grey[900],
          //   ],
          //   begin: Alignment.topLeft,
          //   end: Alignment.bottomRight,
          // ),
        ),
        alignment: Alignment.center,
        margin: EdgeInsets.only(bottom: 10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "${serviceClass['class']}",
              style: style,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    ItemData itemData = ModalRoute.of(context).settings.arguments as ItemData;
    BoxDecoration decoration = BoxDecoration(
      gradient: LinearGradient(
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
        colors: [
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColorDark,
        ],
      ),
    );
    return Container(
      decoration: decoration,
      child: SafeArea(
        child: Scaffold(
          body: Container(
            decoration: decoration,
            padding: EdgeInsets.fromLTRB(20, 0, 20, 20),
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: MediaQuery.of(context).size.height * 0.1,
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        icon: Icon(Icons.arrow_back_ios),
                      ),
                      Text(
                        itemData.name,
                        style: Theme.of(context).textTheme.headline4,
                      ),
                    ],
                  ),
                ),
                ...itemData.classes.map(
                  (e) => Expanded(
                    child: buildClass(
                      e,
                      context,
                      itemData,
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
