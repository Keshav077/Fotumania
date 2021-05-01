import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../models/order_info.dart';
import '../providers/order_provider.dart';
import '../providers/user_provider.dart';

class OrderStatusScreen extends StatefulWidget {
  static String routeName = '/user/order-status';

  @override
  _OrderStatusScreenState createState() => _OrderStatusScreenState();
}

class _OrderStatusScreenState extends State<OrderStatusScreen> {
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
            height: mqs.height,
            width: mqs.width,
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
                                'Order Status',
                                style: Theme.of(context).textTheme.headline4,
                              ),
                            ],
                          ),
                        ),
                        ...orderProvider.getUserOrder().map(
                          (e) {
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
                                      if (e.orderInfo['service'] != null)
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
                                      if (e.orderInfo['Price'] != null)
                                        Row(
                                          children: [
                                            Text("Price: "),
                                            Text(
                                              e.orderInfo["price"],
                                            ),
                                          ],
                                        ),
                                      Row(
                                        children: [
                                          Text("Status: "),
                                          Text(
                                            e.orderStatus == OrderStatus.Ordered
                                                ? "Admin is looking for a suitable service provider"
                                                : e.orderStatus ==
                                                        OrderStatus.RequestSent
                                                    ? "A request has been sent to the service provider"
                                                    : e.orderStatus ==
                                                            OrderStatus.Assigned
                                                        ? "Your order has been assigned to"
                                                        : "Service Completed",
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
        ),
      ),
    );
  }
}
//    ));
//   }
// }
