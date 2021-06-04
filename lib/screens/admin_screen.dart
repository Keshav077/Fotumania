import 'package:firebase_auth/firebase_auth.dart' hide UserInfo;
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

  var _showLoading = false;

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
      await userProvider.loadUser();
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

    return !FirebaseAuth.instance.currentUser.emailVerified
        ? Scaffold(
            body: Center(
              child: Container(
                  width: mqs.width,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Theme.of(context).primaryColor,
                        Theme.of(context).primaryColorDark
                      ],
                      begin: Alignment.topRight,
                      end: Alignment.bottomLeft,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Please Verify Your Email",
                          style: Theme.of(context).textTheme.headline6),
                      SizedBox(height: 5),
                      Text(FirebaseAuth.instance.currentUser.email,
                          style: Theme.of(context).textTheme.subtitle1),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton(
                            child: Text("Resend"),
                            onPressed: () async {
                              setState(() {
                                _showLoading = true;
                              });
                              await FirebaseAuth.instance.currentUser
                                  .sendEmailVerification();
                              setState(() {
                                _showLoading = false;
                              });
                            },
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          ElevatedButton(
                            child: Text("Refresh"),
                            onPressed: () async {
                              await FirebaseAuth.instance.currentUser.reload();
                              setState(() {});
                            },
                          ),
                        ],
                      ),
                      if (_showLoading) CircularProgressIndicator(),
                    ],
                  )),
            ),
          )
        : Container(
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
                                    style:
                                        Theme.of(context).textTheme.headline4,
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
                                    await userProvider.logout(context);
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
