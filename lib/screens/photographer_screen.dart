import 'package:flutter/material.dart';
import 'package:fotumania/models/order_info.dart';
import 'package:fotumania/models/photographers.dart';
import 'package:fotumania/models/user_info.dart';
import 'package:fotumania/providers/order_provider.dart';
import 'package:fotumania/providers/photographers_provider.dart';
import 'package:fotumania/providers/user_provider.dart';
import 'package:fotumania/screens/profile_screen.dart';
import 'package:provider/provider.dart';

class PhotographersScreen extends StatefulWidget {
  static final routeName = "./photographersList";

  @override
  _PhotographersScreenState createState() => _PhotographersScreenState();
}

class _PhotographersScreenState extends State<PhotographersScreen> {
  Orders showOrders = Orders.Request;

  @override
  Widget build(BuildContext context) {
    UserProvider userProvider = Provider.of<UserProvider>(context);
    PhotographersProvider photographersProvider =
        Provider.of<PhotographersProvider>(context);
    OrderProvider orderProvider = Provider.of<OrderProvider>(context);

    UserInfo user = userProvider.user;
    Photographers photographersInfo =
        photographersProvider.getPhotographerWithId(user.userId);

    MediaQueryData mqc = MediaQuery.of(context);
    double height = mqc.size.height - mqc.padding.top;
    double width = mqc.size.width;
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
        top: true,
        child: Scaffold(
          body: Container(
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
            padding: EdgeInsets.all(10),
            child: Column(
              children: [
                Container(
                  height: height * 0.07,
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    children: [
                      InkWell(
                        child: Icon(Icons.more_vert_rounded),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      Text(
                        "FOTUMANIA",
                        style: Theme.of(context).textTheme.headline6,
                      )
                    ],
                  ),
                ),
                PhotographerAnalytics(
                    height: height,
                    width: width,
                    photographersInfo: photographersInfo,
                    user: user),
                Container(
                  // color: Colors.red,
                  margin: EdgeInsets.symmetric(vertical: 10),
                  height: height * 0.06,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          setState(() {
                            showOrders = Orders.Request;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: showOrders == Orders.Request
                                ? Colors.red
                                : Colors.redAccent[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(3),
                          width: width * 0.3,
                          child: Text(
                            "Order Requests",
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            showOrders = Orders.Accepted;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: showOrders == Orders.Accepted
                                ? Colors.amber
                                : Colors.amberAccent[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(3),
                          width: width * 0.3,
                          child: Text(
                            "Orders Accepted",
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            showOrders = Orders.Completed;
                          });
                        },
                        child: Container(
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            color: showOrders == Orders.Completed
                                ? Colors.green
                                : Colors.greenAccent[100],
                            borderRadius: BorderRadius.circular(10),
                          ),
                          padding: EdgeInsets.all(3),
                          width: width * 0.3,
                          child: Text(
                            "Orders Completed",
                            style: Theme.of(context).textTheme.caption,
                          ),
                        ),
                      )
                    ],
                  ),
                ),
                Expanded(
                  child: ListView.builder(
                    itemBuilder: (ctx, index) {
                      OrderInfo orderInfo = orderProvider.getOrderById(
                          photographersInfo.contracts[showOrders][index]);
                      return ListTile(
                        leading: Text(
                          orderInfo.orderId,
                          style: Theme.of(context).textTheme.headline6,
                        ),
                        title: Text(
                          orderInfo.orderInfo['service'],
                          style: Theme.of(context).textTheme.subtitle1,
                        ),
                        subtitle: Text(
                          "${orderInfo.userId}\n${orderInfo.orderDate.toString()}",
                          style: Theme.of(context).textTheme.overline,
                        ),
                        trailing: showOrders == Orders.Completed
                            ? null
                            : InkWell(
                                onTap: () {
                                  showDialog(
                                    context: context,
                                    builder: (ctx) {
                                      return AlertDialog(
                                        buttonPadding:
                                            EdgeInsets.only(right: 40),
                                        actionsPadding:
                                            EdgeInsets.only(right: 10),
                                        title: Text(
                                            showOrders == Orders.Request
                                                ? "Are you sure you wanna accept this job?"
                                                : "Are you sure you have completed this job?",
                                            style: Theme.of(context)
                                                .textTheme
                                                .subtitle2),
                                        actions: [
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop(true);
                                            },
                                            child: Text(
                                              "Yes",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                          ),
                                          InkWell(
                                            onTap: () {
                                              Navigator.of(context).pop(false);
                                            },
                                            child: Text(
                                              "No",
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodyText1,
                                            ),
                                          ),
                                        ],
                                      );
                                    },
                                  ).then(
                                    (value) {
                                      if (showOrders == Orders.Request) {
                                        if (value == true) {
                                          photographersProvider.acceptOrder(
                                              user.userId, orderInfo.orderId);
                                          orderProvider.orderAssigned(
                                            orderInfo.orderId,
                                            user.userId,
                                            orderInfo.userId,
                                          );
                                        }
                                      }
                                      if (showOrders == Orders.Accepted) {
                                        if (value == true) {
                                          photographersProvider.orderCompleted(
                                              user.userId, orderInfo.orderId);
                                          orderProvider.orderCompleted(
                                              orderInfo.orderId,
                                              orderInfo.userId);
                                        }
                                      }
                                    },
                                  );
                                },
                                child: Icon(
                                  Icons.check_circle_rounded,
                                  color: Colors.white,
                                  size: 40,
                                ),
                              ),
                      );
                    },
                    itemCount: photographersInfo.contracts[showOrders].length,
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

class PhotographerAnalytics extends StatelessWidget {
  const PhotographerAnalytics({
    Key key,
    @required this.height,
    @required this.width,
    @required this.photographersInfo,
    @required this.user,
  }) : super(key: key);

  final double height;
  final double width;
  final Photographers photographersInfo;
  final UserInfo user;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        // color: Theme.of(context).primaryColor,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Container(
            padding: EdgeInsets.all(5),
            // color: Colors.blue,
            height: height * (height > 800 ? 0.31 : 0.4),
            width: width * 0.55,
            child: GridView(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 10,
                  crossAxisSpacing: 10,
                  childAspectRatio: height > 800 ? 3 / 3.31 : 3 / 3.55,
                  crossAxisCount: 2),
              children: [
                buildPhotographerAnalytics(
                    context,
                    "Order\nRequests",
                    photographersInfo.contracts[Orders.Request].length
                        .toString()),
                buildPhotographerAnalytics(
                    context,
                    "Orders\nAccepted",
                    photographersInfo.contracts[Orders.Accepted].length
                        .toString()),
                buildPhotographerAnalytics(
                    context,
                    "Orders\nCompleted",
                    photographersInfo.contracts[Orders.Completed].length
                        .toString()),
                buildPhotographerAnalytics(
                    context, "Ratings", photographersInfo.ratings.toString()),
              ],
            ),
          ),
          Container(
            // color: Colors.blue,
            height: height * (height > 800 ? 0.3 : 0.4),
            width: width * 0.4,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => Profile(user),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      border: Border.all(width: 5, color: Colors.white),
                      boxShadow: [
                        BoxShadow(
                          offset: Offset(-2, 2),
                          blurRadius: 2,
                          spreadRadius: 4,
                          color: Colors.black26,
                        ),
                      ],
                      image: DecorationImage(
                          image: NetworkImage(
                            user.imageUrl,
                          ),
                          fit: BoxFit.cover),
                      shape: BoxShape.circle,
                    ),
                    height: height * 0.2,
                    width: width * 0.35,
                  ),
                ),
                Container(
                  height: height * 0.1,
                  // color: Colors.green,
                  alignment: Alignment.topCenter,
                  child: Text(
                    "Hello!\n" + user.userName,
                    textAlign: TextAlign.center,
                    style: Theme.of(context).textTheme.headline6,
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }
}

Widget buildPhotographerAnalytics(
    BuildContext context, String title, String value) {
  return Container(
    margin: EdgeInsets.only(top: 4, bottom: 8, left: 7, right: 5),
    decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        gradient: LinearGradient(
          colors: [
            Colors.blue[600],
            Colors.blue[800],
          ],
          begin: Alignment.topRight,
          end: Alignment.bottomLeft,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black26,
            blurRadius: 3,
            offset: Offset(-2, 2),
            spreadRadius: 3,
          )
        ]),
    child: GridTile(
      header: Text(
        title,
        style: Theme.of(context).textTheme.button,
        textAlign: TextAlign.center,
      ),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Text(
          value,
          style: Theme.of(context).textTheme.headline2,
        ),
      ),
    ),
  );
}
