import 'package:flutter/material.dart';
import 'package:fotumania/models/photographers.dart';
import 'package:fotumania/providers/order_provider.dart';
import 'package:fotumania/models/order_info.dart';
import 'package:fotumania/providers/photographers_provider.dart';
import 'package:fotumania/providers/user_provider.dart';
import 'package:provider/provider.dart';

class OrderList extends StatefulWidget {
  final OrderStatus showAssignedList;
  OrderList(this.showAssignedList);

  @override
  _OrderListState createState() => _OrderListState();
}

class _OrderListState extends State<OrderList> {
  Future modalSheet(BuildContext context, List<Photographers> photographers,
      UserProvider userProvider) {
    return showModalBottomSheet(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(25),
        ),
      ),
      context: context,
      builder: (ctx) {
        return ListView.builder(
          itemBuilder: (ctx, index) {
            return Column(
              children: [
                if (index == 0)
                  Container(
                    margin: EdgeInsets.all(10),
                    child: Text(
                      "Available Photographers",
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                InkWell(
                  onTap: () {
                    Navigator.of(context).pop(photographers[index].id);
                  },
                  child: ListTile(
                    title: Text(
                      userProvider
                          .getUserById(photographers[index].id)
                          .userName,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                    trailing: Text(
                      "Ratings: " +
                          photographers[index].ratings.toStringAsFixed(2),
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
              ],
            );
          },
          itemCount: photographers.length,
        );
      },
    );
  }

  OrderProvider orderProvider;
  PhotographersProvider photographersProvider;
  UserProvider userProvider;
  List<OrderInfo> orders;

  bool isInit = false, isLoading = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!isInit) {
      setState(() {
        isLoading = true;
      });
      orderProvider = Provider.of<OrderProvider>(context);
      photographersProvider = Provider.of<PhotographersProvider>(context);
      userProvider = Provider.of<UserProvider>(context, listen: false);
      // await orderProvider.fetchAllOrders();
      await userProvider.fetchAllUsers();
      await photographersProvider.fetchAllPhotographers();
      // await orderProvider.fetchAllOrders();
      isInit = true;
      setState(() {
        isLoading = false;
      });
    }
  }

  void fetchUsers() => userProvider.fetchAllUsers().then((_) {
        return;
      });

  void fetchPhotographers() =>
      photographersProvider.fetchAllPhotographers().then((value) {
        return;
      });

  @override
  Widget build(BuildContext context) {
    orders = orderProvider.getAssignedOrders(widget.showAssignedList);
    print(orders);

    return isLoading
        ? Center(
            child: CircularProgressIndicator(
              backgroundColor: Colors.white,
              valueColor: AlwaysStoppedAnimation(Colors.blue),
            ),
          )
        : ListView.builder(
            itemBuilder: (ctx, index) {
              return Container(
                margin: EdgeInsets.only(bottom: 10),
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
                          orders[index].orderId,
                        ),
                        Spacer(),
                        Text(orders[index]
                            .orderDate
                            .toString()
                            .split(' ')[0]
                            .split('-')
                            .reversed
                            .join('/'))
                      ],
                    ),
                    if (orders[index].orderInfo['service'] != null)
                      Row(
                        children: [
                          Text("Service: "),
                          Text(
                            orders[index].orderInfo['service'],
                          ),
                        ],
                      ),
                    if (orders[index].orderInfo['date'] != null)
                      Row(
                        children: [
                          Text("Date: "),
                          Text(
                            orders[index].orderInfo["date"] +
                                " " +
                                orders[index].orderInfo["time"],
                          ),
                        ],
                      ),
                    if (orders[index].orderInfo['price'] != null)
                      Row(
                        children: [
                          Text("Price: "),
                          Text(
                            orders[index].orderInfo["price"],
                          ),
                        ],
                      ),
                    if (orders[index].providerId != null)
                      if (orders[index].orderStatus == OrderStatus.RequestSent)
                        Row(
                          children: [
                            Text("Request Sent to: "),
                            Text(
                              userProvider
                                  .getUserById(orders[index].providerId)
                                  .userName,
                            ),
                          ],
                        ),
                    if (orders[index].providerId != null)
                      if (orders[index].orderStatus == OrderStatus.Assigned)
                        Row(
                          children: [
                            Text("Assigned to: "),
                            Text(
                              userProvider
                                  .getUserById(orders[index].providerId)
                                  .userName,
                            ),
                          ],
                        ),

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
                    orders[index].orderStatus == OrderStatus.Assigned
                        ? Text(userProvider
                            .getUserById(orders[index].providerId)
                            .userName)
                        : orders[index].orderStatus == OrderStatus.Completed
                            ? Text("Completed")
                            : InkWell(
                                onTap: () {
                                  modalSheet(
                                    context,
                                    photographersProvider.filterPhotograpers(
                                        serviceType:
                                            orders[index].orderInfo['service']),
                                    userProvider,
                                  ).then(
                                    (value) async {
                                      if (value != null) {
                                        await orderProvider
                                            .sendRequestToProvider(
                                                orderId: orders[index].orderId,
                                                providerId: value,
                                                userId: orders[index].userId);

                                        await photographersProvider.assignOrder(
                                          photographersProvider
                                              .getPhotographerWithId(value)
                                              .photographerId,
                                          orders[index].orderId,
                                        );
                                      }
                                    },
                                  );
                                },
                                child: Container(
                                  child: Text("Send Request"),
                                ),
                              ),
                  ],
                ),
              );

              // return ListTile(
              //   leading: CircleAvatar(
              //       child: Text(
              //     orders[index].orderId,
              //     // overflow: TextOverflow.ellipsis,
              //     style: Theme.of(context).textTheme.caption,
              //   )),
              //   title: Text(orders[index].orderInfo['service']),
              //   subtitle: Container(
              //     padding: EdgeInsets.only(top: 10),
              //     child: orders[index].orderStatus != OrderStatus.RequestSent
              //         ? Text(
              //             userProvider
              //                 .getUserById(orders[index].userId)
              //                 .userName,
              //             style: Theme.of(context).textTheme.overline,
              //           )
              //         : Text(
              //             "UserId ${orders[index].userId}\nRequest Sent to ${userProvider.getUserById(orders[index].providerId).userName}",
              //             style: Theme.of(context).textTheme.overline,
              //           ),
              //   ),
              //   trailing: orders[index].orderStatus == OrderStatus.Assigned
              //       ? Text(userProvider
              //           .getUserById(orders[index].providerId)
              //           .userName)
              //       : orders[index].orderStatus == OrderStatus.Completed
              //           ? Text("Completed")
              //           : InkWell(
              //               onTap: () {
              //                 modalSheet(
              //                   context,
              //                   photographersProvider.filterPhotograpers(
              //                       serviceType:
              //                           orders[index].orderInfo['service']),
              //                   userProvider,
              //                 ).then(
              //                   (value) async {
              //                     if (value != null) {
              //                       await orderProvider.sendRequestToProvider(
              //                           orderId: orders[index].orderId,
              //                           providerId: value,
              //                           userId: orders[index].userId);

              //                       await photographersProvider.assignOrder(
              //                         photographersProvider
              //                             .getPhotographerWithId(value)
              //                             .photographerId,
              //                         orders[index].orderId,
              //                       );
              //                     }
              //                   },
              //                 );
              //               },
              //               child: Icon(
              //                 Icons.check_circle_outline_outlined,
              //                 size: 35,
              //                 color: Colors.white,
              //               ),
              //             ),
              // );
            },
            itemCount: orders.length,
          );
  }
}
