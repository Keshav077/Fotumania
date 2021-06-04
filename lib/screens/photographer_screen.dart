import 'package:firebase_auth/firebase_auth.dart' hide UserInfo;
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
  UserProvider userProvider;
  PhotographersProvider photographersProvider;
  OrderProvider orderProvider;
  UserInfo user;
  Photographers photographersInfo;
  bool isInit = false, isLoading = false, ordersLoading = false;

  var _showLoading = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!isInit) {
      setState(() {
        isLoading = true;
      });
      await userProvider.loadUser();
      await userProvider.fetchAllUsers();
      await photographersProvider.fetchAllPhotographers();
      await orderProvider.fetchAllOrders();
      user = userProvider.user;
      photographersInfo =
          photographersProvider.getPhotographerWithId(user.userId);
      setState(() {
        isLoading = false;
      });
      isInit = true;
    }
  }

  Future<void> onRefresh() async {
    await userProvider.loadUser();
    await photographersProvider.fetchAllPhotographers();
    photographersInfo =
        photographersProvider.getPhotographerWithId(user.userId);
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    userProvider = Provider.of<UserProvider>(context, listen: false);
    photographersProvider =
        Provider.of<PhotographersProvider>(context, listen: false);
    orderProvider = Provider.of<OrderProvider>(context, listen: false);
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mqc = MediaQuery.of(context);
    double height = mqc.size.height - mqc.padding.top;
    double width = mqc.size.width;
    return !FirebaseAuth.instance.currentUser.emailVerified
        ? Scaffold(
            body: Center(
              child: Container(
                  width: width,
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
                  child: isLoading
                      ? Center(child: CircularProgressIndicator())
                      : RefreshIndicator(
                          onRefresh: onRefresh,
                          child: Column(
                            children: [
                              Container(
                                height: height * 0.07,
                                padding: EdgeInsets.symmetric(horizontal: 10),
                                child: Row(
                                  children: [
                                    // InkWell(
                                    //   child: Icon(Icons.more_vert_rounded),
                                    // ),
                                    // SizedBox(
                                    //   width: 10,
                                    // ),
                                    Text(
                                      "FOTUMANIA",
                                      style:
                                          Theme.of(context).textTheme.headline4,
                                    ),
                                    Spacer(),
                                    IconButton(
                                        onPressed: () {
                                          userProvider.logout(context);
                                        },
                                        icon: Icon(Icons.logout)),
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
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: EdgeInsets.all(3),
                                        width: width * 0.3,
                                        child: Text(
                                          "Order Requests",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: EdgeInsets.all(3),
                                        width: width * 0.3,
                                        child: Text(
                                          "Orders Accepted",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
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
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        ),
                                        padding: EdgeInsets.all(3),
                                        width: width * 0.3,
                                        child: Text(
                                          "Orders Completed",
                                          style: Theme.of(context)
                                              .textTheme
                                              .caption,
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: ordersLoading
                                    ? Center(child: CircularProgressIndicator())
                                    : ListView.builder(
                                        itemBuilder: (ctx, index) {
                                          OrderInfo orderInfo = orderProvider
                                              .getOrderById(photographersInfo
                                                      .contracts[showOrders]
                                                  [index]);
                                          // return Text(orderInfo.orderId);

                                          return Container(
                                            margin: EdgeInsets.only(bottom: 10),
                                            padding: EdgeInsets.all(10),
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(20),
                                              color: Colors.white12,
                                            ),
                                            child: Column(
                                              children: [
                                                Row(
                                                  children: [
                                                    Text("Order id: "),
                                                    Text(
                                                      orderInfo.orderId,
                                                    ),
                                                    Spacer(),
                                                    Text(orderInfo.orderDate
                                                        .toString()
                                                        .split(' ')[0]
                                                        .split('-')
                                                        .reversed
                                                        .join('/'))
                                                  ],
                                                ),
                                                if (orderInfo.userId != null)
                                                  Row(
                                                    children: [
                                                      Text("Customer Name: "),
                                                      Text(
                                                        userProvider
                                                            .getUserById(
                                                                orderInfo
                                                                    .userId)
                                                            .userName,
                                                      ),
                                                    ],
                                                  ),
                                                if (orderInfo
                                                        .orderInfo['service'] !=
                                                    null)
                                                  Row(
                                                    children: [
                                                      Text("Service: "),
                                                      Text(
                                                        orderInfo.orderInfo[
                                                            'service'],
                                                      ),
                                                    ],
                                                  ),
                                                if (orderInfo
                                                        .orderInfo['date'] !=
                                                    null)
                                                  Row(
                                                    children: [
                                                      Text("Date: "),
                                                      Text(
                                                        orderInfo.orderInfo[
                                                                "date"] +
                                                            " " +
                                                            orderInfo.orderInfo[
                                                                "time"],
                                                      ),
                                                    ],
                                                  ),

                                                if (orderInfo
                                                        .orderInfo['price'] !=
                                                    null)
                                                  Row(
                                                    children: [
                                                      Text("Price: "),
                                                      Text(
                                                        orderInfo
                                                            .orderInfo["price"],
                                                      ),
                                                    ],
                                                  ),
                                                // if (orderInfo.providerId != null)
                                                //   if (orderInfo.orderStatus == OrderStatus.RequestSent)
                                                //     Row(
                                                //       children: [
                                                //         Text("Request Sent to: "),
                                                //         Text(
                                                //           userProvider
                                                //               .getUserById(orderInfo.providerId)
                                                //               .userName,
                                                //         ),
                                                //       ],
                                                //     ),
                                                // if (orderInfo.providerId != null)
                                                //   if (orderInfo.orderStatus == OrderStatus.Assigned)
                                                //     Row(
                                                //       children: [
                                                //         Text("Assigned to: "),
                                                //         Text(
                                                //           userProvider
                                                //               .getUserById(orderInfo.providerId)
                                                //               .userName,
                                                //         ),
                                                //       ],
                                                //     ),

                                                // Row(
                                                //   children: [
                                                //     Text("Status: "),
                                                //     e.orderStatus == OrderStatus.Ordered
                                                //         ? Text(
                                                //             "Admin is looking for a suitable service provider")
                                                //         : e.orderStatus == OrderStatus.RequestSent
                                                //             ? Text(
                                                //                 "A request has been sent to the service provider")
                                                //             : e.orderStatus == OrderStatus.Assigned
                                                //                 ? Text(
                                                //                     "Your order has been assigned to ${userProvider.getUserById(e.providerId).userName}")
                                                //                 : Text(
                                                //                     "Service Completed",
                                                //                   ),
                                                //   ],
                                                // ),
                                                orderInfo.orderStatus ==
                                                        OrderStatus.Completed
                                                    ? Text("Completed")
                                                    : showOrders ==
                                                            Orders.Completed
                                                        ? null
                                                        : InkWell(
                                                            onTap: () {
                                                              showDialog(
                                                                context:
                                                                    context,
                                                                builder: (ctx) {
                                                                  return AlertDialog(
                                                                    buttonPadding:
                                                                        EdgeInsets.only(
                                                                            right:
                                                                                40),
                                                                    actionsPadding:
                                                                        EdgeInsets.only(
                                                                            right:
                                                                                10),
                                                                    title: Text(
                                                                        showOrders == Orders.Request
                                                                            ? "Are you sure you want to accept this job?"
                                                                            : "Are you sure you have completed this job?",
                                                                        style: TextStyle(
                                                                            fontSize:
                                                                                20,
                                                                            color:
                                                                                Colors.black)),
                                                                    actions: [
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop(true);
                                                                        },
                                                                        child:
                                                                            Text(
                                                                          "Yes",
                                                                          style: Theme.of(context)
                                                                              .textTheme
                                                                              .bodyText1,
                                                                        ),
                                                                      ),
                                                                      InkWell(
                                                                        onTap:
                                                                            () {
                                                                          Navigator.of(context)
                                                                              .pop(false);
                                                                        },
                                                                        child:
                                                                            Text(
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
                                                                (value) async {
                                                                  if (showOrders ==
                                                                      Orders
                                                                          .Request) {
                                                                    if (value ==
                                                                        true) {
                                                                      await photographersProvider.acceptOrder(
                                                                          photographersInfo
                                                                              .photographerId,
                                                                          orderInfo
                                                                              .orderId);
                                                                      await orderProvider
                                                                          .orderAssigned(
                                                                        orderInfo
                                                                            .orderId,
                                                                        user.userId,
                                                                        orderInfo
                                                                            .userId,
                                                                      );
                                                                      setState(
                                                                          () {});
                                                                    }
                                                                  }
                                                                  if (showOrders ==
                                                                      Orders
                                                                          .Accepted) {
                                                                    if (value ==
                                                                        true) {
                                                                      setState(
                                                                          () {});
                                                                      await photographersProvider.orderCompleted(
                                                                          photographersInfo
                                                                              .photographerId,
                                                                          orderInfo
                                                                              .orderId);
                                                                      await orderProvider.orderCompleted(
                                                                          orderInfo
                                                                              .orderId,
                                                                          orderInfo
                                                                              .userId);
                                                                      setState(
                                                                          () {});
                                                                    }
                                                                  }
                                                                },
                                                              );
                                                            },
                                                            child: showOrders ==
                                                                    Orders
                                                                        .Request
                                                                ? Text("Accept")
                                                                : Text(
                                                                    "Complete"),
                                                          ),
                                              ],
                                            ),
                                          );

                                          // return ListTile(
                                          //   leading: CircleAvatar(
                                          //     child: Text(
                                          //       orderInfo.orderId,
                                          //       // style:
                                          //       //     Theme.of(context).textTheme.headline6,
                                          //     ),
                                          //   ),
                                          //   title: Text(
                                          //     orderInfo.orderInfo['service'],
                                          //     style: Theme.of(context).textTheme.subtitle1,
                                          //   ),
                                          //   subtitle: Text(
                                          //     "${orderInfo.userId}\n${orderInfo.orderDate.toString()}",
                                          //     style: Theme.of(context).textTheme.overline,
                                          //   ),
                                          //   trailing: showOrders == Orders.Completed
                                          //       ? null
                                          //       : InkWell(
                                          //           onTap: () {
                                          //             showDialog(
                                          //               context: context,
                                          //               builder: (ctx) {
                                          //                 return AlertDialog(
                                          //                   buttonPadding:
                                          //                       EdgeInsets.only(right: 40),
                                          //                   actionsPadding:
                                          //                       EdgeInsets.only(right: 10),
                                          //                   title: Text(
                                          //                       showOrders == Orders.Request
                                          //                           ? "Are you sure you wanna accept this job?"
                                          //                           : "Are you sure you have completed this job?",
                                          //                       style: Theme.of(context)
                                          //                           .textTheme
                                          //                           .subtitle2),
                                          //                   actions: [
                                          //                     InkWell(
                                          //                       onTap: () {
                                          //                         Navigator.of(context)
                                          //                             .pop(true);
                                          //                       },
                                          //                       child: Text(
                                          //                         "Yes",
                                          //                         style: Theme.of(context)
                                          //                             .textTheme
                                          //                             .bodyText1,
                                          //                       ),
                                          //                     ),
                                          //                     InkWell(
                                          //                       onTap: () {
                                          //                         Navigator.of(context)
                                          //                             .pop(false);
                                          //                       },
                                          //                       child: Text(
                                          //                         "No",
                                          //                         style: Theme.of(context)
                                          //                             .textTheme
                                          //                             .bodyText1,
                                          //                       ),
                                          //                     ),
                                          //                   ],
                                          //                 );
                                          //               },
                                          //             ).then(
                                          //               (value) async {
                                          //                 if (showOrders ==
                                          //                     Orders.Request) {
                                          //                   if (value == true) {
                                          //                     await photographersProvider
                                          //                         .acceptOrder(
                                          //                             photographersInfo
                                          //                                 .photographerId,
                                          //                             orderInfo.orderId);
                                          //                     await orderProvider
                                          //                         .orderAssigned(
                                          //                       orderInfo.orderId,
                                          //                       user.userId,
                                          //                       orderInfo.userId,
                                          //                     );
                                          //                     setState(() {});
                                          //                   }
                                          //                 }
                                          //                 if (showOrders ==
                                          //                     Orders.Accepted) {
                                          //                   if (value == true) {
                                          //                     await photographersProvider
                                          //                         .orderCompleted(
                                          //                             photographersInfo
                                          //                                 .photographerId,
                                          //                             orderInfo.orderId);
                                          //                     await orderProvider
                                          //                         .orderCompleted(
                                          //                             orderInfo.orderId,
                                          //                             orderInfo.userId);
                                          //                     setState(() {});
                                          //                   }
                                          //                 }
                                          //               },
                                          //             );
                                          //           },
                                          //           child: Icon(
                                          //             Icons.check_circle_rounded,
                                          //             color: Colors.white,
                                          //             size: 40,
                                          //           ),
                                          //         ),
                                          // );
                                        },
                                        itemCount:
                                            photographersInfo.contracts == null
                                                ? 0
                                                : photographersInfo
                                                    .contracts[showOrders]
                                                    .length,
                                      ),
                              )
                            ],
                          ),
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
                buildPhotographerAnalytics(context, "Ratings",
                    photographersInfo.ratings.toStringAsFixed(1)),
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
                            user.imageUrl == null
                                ? "https://cdn.pixabay.com/photo/2018/04/18/18/56/user-3331256__340.png"
                                : user.imageUrl,
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
