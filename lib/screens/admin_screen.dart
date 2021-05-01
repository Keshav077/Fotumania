import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './edit_service.dart';
import '../widgets/admin_work_space.dart';

import '../models/order_info.dart';
import '../models/user_info.dart';

import '../screens/profile_screen.dart';

import '../providers/items_provider.dart';
import '../providers/user_provider.dart';

class AdminHome extends StatefulWidget {
  static String routeName = '/admin-home';

  @override
  _AdminHomeState createState() => _AdminHomeState();
}

class _AdminHomeState extends State<AdminHome> {
  bool _isInit = false;
  var _isLoading = false;
  UserInfo user;
  UserProvider userProvider;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_isInit) {
      setState(
        () {
          _isLoading = true;
        },
      );
      await Provider.of<ItemProvider>(context, listen: false)
          .fetchItemsFromServer();
      userProvider = Provider.of<UserProvider>(context, listen: false);
      user = userProvider.user;
      setState(
        () {
          _isLoading = false;
        },
      );
      _isInit = true;
    }
  }

  OrderStatus showOrders = OrderStatus.Ordered;

  @override
  Widget build(BuildContext context) {
    Size mqs = Size(
        MediaQuery.of(context).size.width,
        MediaQuery.of(context).size.height -
            MediaQuery.of(context).padding.top);

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).primaryColor,
            Theme.of(context).primaryColorDark,
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
      ),
      child: SafeArea(
        child: Scaffold(
            body: Container(
          width: mqs.width,
          height: mqs.height,
          padding: EdgeInsets.symmetric(horizontal: mqs.height * 0.015),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Theme.of(context).primaryColor,
                Theme.of(context).primaryColorDark,
              ],
              begin: Alignment.topRight,
              end: Alignment.bottomLeft,
            ),
          ),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                )
              : Column(
                  children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            child: Text(
                              user.userName,
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ),
                          Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (ctx) => Profile(user),
                                ),
                              );
                            },
                            icon: Icon(Icons.person),
                          ),
                          IconButton(
                            onPressed: () async {
                              await userProvider.logout();
                            },
                            icon: Icon(Icons.logout),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(bottom: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.of(context).pushNamed(
                                EditService.routeName,
                              );
                            },
                            child: tiles(
                              mqs,
                              "Edit/Add Service Info",
                              context,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(child: AdminWorkSpace()),
                  ],
                ),
        )),
      ),
    );
  }
}

Widget tiles(Size mqs, String title, BuildContext context) {
  return Container(
    height: mqs.height * 0.1,
    width: mqs.width * 0.91,
    alignment: Alignment.center,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.black26,
    ),
    child: Text(
      title,
      style: Theme.of(context).textTheme.headline6,
    ),
  );
}
