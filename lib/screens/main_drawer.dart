import 'package:flutter/material.dart';
import 'package:fotumania/providers/user_provider.dart';
import 'package:fotumania/screens/order_status.dart';
import 'package:fotumania/screens/recent_orders.dart';

import 'package:provider/provider.dart';

class MainDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          DrawerHeader(
            child: Container(
              width: double.infinity,
              alignment: Alignment.bottomLeft,
              child: Stack(
                alignment: Alignment.bottomLeft,
                children: [
                  Container(
                    margin: EdgeInsets.all(25),
                    // decoration: BoxDecoration(
                    //   borderRadius: BorderRadius.circular(10),
                    //   color: Colors.black54,
                    // ),
                  ),
                  Text("Menu", style: Theme.of(context).textTheme.headline6),
                ],
              ),
            ),
            decoration: BoxDecoration(
                gradient: LinearGradient(
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
              colors: [Colors.blue[600], Colors.blue[800]],
            )),
          ),
          Column(
            children: [
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(OrderStatusScreen.routeName);
                },
                leading: Icon(Icons.local_shipping_rounded),
                title: Text("Order Status"),
              ),
              ListTile(
                onTap: () {
                  Navigator.of(context).pushNamed(RecentOrdersScreen.routeName);
                },
                leading: Icon(Icons.access_time_sharp),
                title: Text("Recent Orders"),
              ),
              ListTile(
                leading: Icon(Icons.feedback_outlined),
                title: Text("Feedback"),
              ),
              ListTile(
                title: Text("Support"),
              ),
              ElevatedButton(
                  onPressed: () {
                    Provider.of<UserProvider>(
                      context,
                      listen: false,
                    ).logout();
                  },
                  child: Text("Logout"))
            ],
          ),
        ],
      ),
    );
  }
}
