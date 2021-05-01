import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

import '../providers/order_provider.dart';
import '../providers/user_provider.dart';

class RecentOrdersScreen extends StatefulWidget {
  static String routeName = '/user/recent-orders';

  @override
  _RecentOrdersScreenState createState() => _RecentOrdersScreenState();
}

class _RecentOrdersScreenState extends State<RecentOrdersScreen> {
  bool _isInit = false, _isLoading = false;
  OrderProvider orderProvider;
  UserProvider userProvider;
  LinearGradient gradient;
  Size mqs;
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_isInit) {
      orderProvider = Provider.of<OrderProvider>(context, listen: false);
      userProvider = Provider.of<UserProvider>(context, listen: false);
      mqs = MediaQuery.of(context).size;
      gradient = LinearGradient(
        colors: [
          Theme.of(context).primaryColor,
          Theme.of(context).primaryColorDark,
        ],
        begin: Alignment.topRight,
        end: Alignment.bottomLeft,
      );
      setState(() {
        _isLoading = true;
      });
      await orderProvider.fetchAndSetOrders();
      setState(() {
        _isLoading = false;
      });
      _isInit = true;
    }
  }

  Future<void> _onRefresh() async {
    await orderProvider.fetchAndSetOrders();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: gradient,
      ),
      child: SafeArea(
          child: Scaffold(
        body: Container(
          decoration: BoxDecoration(
            gradient: gradient,
          ),
          padding: EdgeInsets.symmetric(
              horizontal: mqs.width * 0.03, vertical: mqs.height * 0.01),
          child: _isLoading
              ? Center(
                  child: CircularProgressIndicator(
                    backgroundColor: Colors.white,
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _onRefresh,
                  child: ListView(
                    children: [
                      Container(
                        height: mqs.height * 0.07,
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                              icon: Icon(Icons.arrow_back_ios),
                            ),
                            Text(
                              'Recent Orders',
                              style: Theme.of(context).textTheme.headline4,
                            ),
                          ],
                        ),
                      ),
                      ...orderProvider.getUserRecentOrders().map(
                        (e) {
                          // UserInfo photographer =
                          //     userProvider.getUserById(e.providerId);
                          return Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(20),
                                  color: Colors.white12,
                                ),
                                child: Column(
                                  children: [
                                    Row(
                                      children: [
                                        Text("Order id: "),
                                        Text(
                                          e.orderId,
                                        ),
                                        Spacer(),
                                        Text(e.orderDate
                                            .toString()
                                            .split(' ')[0]
                                            .replaceAll('-', '/'))
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Service: "),
                                        Text(
                                          e.orderInfo['service'],
                                        ),
                                      ],
                                    ),
                                    if (e.orderInfo['date'] != null)
                                      Row(
                                        children: [
                                          Text("Date: "),
                                          Text(
                                            e.orderInfo["date"] +
                                                " " +
                                                e.orderInfo["time"],
                                          ),
                                        ],
                                      ),
                                    Row(
                                      children: [
                                        Text("Price: "),
                                        Text(
                                          e.orderInfo["Price"],
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Status: "),
                                        Text(
                                          "Service Completed",
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text("Rate the Photographer: "),
                                        Spacer(),
                                        RatingBar.builder(
                                          itemSize: 30,
                                          initialRating: 3,
                                          minRating: 1,
                                          ignoreGestures:
                                              e.orderInfo['ratings'] == null
                                                  ? false
                                                  : true,
                                          direction: Axis.horizontal,
                                          allowHalfRating: true,
                                          itemCount: 5,
                                          itemPadding: EdgeInsets.symmetric(
                                              horizontal: 4.0),
                                          itemBuilder: (context, _) => Icon(
                                            Icons.star,
                                            color: Colors.amber,
                                          ),
                                          onRatingUpdate: (rating) {
                                            orderProvider.setRatings(
                                                e.orderId, e.userId, rating);
                                            setState(() {});
                                          },
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(
                                height: 10,
                              ),
                            ],
                          );
                        },
                      ),
                    ],
                  ),
                ),
        ),
      )),
    );
  }
}
