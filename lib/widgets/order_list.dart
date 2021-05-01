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
            return InkWell(
              onTap: () {
                Navigator.of(context).pop(photographers[index].id);
              },
              child: ListTile(
                title: Text(
                  "ABC",
                  // userProvider.getUserById(photographers[index].id).userName,
                  style: Theme.of(context).textTheme.headline5,
                ),
              ),
            );
          },
          itemCount: photographers.length,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    OrderProvider orderProvider = Provider.of<OrderProvider>(context);
    PhotographersProvider photographersProvider =
        Provider.of<PhotographersProvider>(context);
    UserProvider userProvider =
        Provider.of<UserProvider>(context, listen: false);
    List<OrderInfo> orders =
        orderProvider.getAssignedOrders(widget.showAssignedList);

    return ListView.builder(
      itemBuilder: (ctx, index) {
        return ListTile(
          leading: CircleAvatar(
              child: Text(
            orders[index].orderId,
            // overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.caption,
          )),
          title: Text(orders[index].orderInfo['service']),
          subtitle: Container(
            padding: EdgeInsets.only(top: 10),
            child: orders[index].orderStatus != OrderStatus.RequestSent
                ? Text(
                    orders[index].userId,
                    style: Theme.of(context).textTheme.overline,
                  )
                : Text(
                    "XXX",
                    // "UserId ${orders[index].userId}\nRequest Sent to ${userProvider.getUserById(orders[index].providerId).userName}",
                    style: Theme.of(context).textTheme.overline,
                  ),
          ),
          trailing: orders[index].orderStatus == OrderStatus.Assigned
              ? Text("ABC")
              // userProvider.getUserById(orders[index].providerId).userName)
              : orders[index].orderStatus == OrderStatus.Completed
                  ? Text("Completed")
                  : InkWell(
                      onTap: () {
                        modalSheet(
                          context,
                          photographersProvider.filterPhotograpers(
                              serviceType:
                                  orders[index].orderInfo['serviceId']),
                          userProvider,
                        ).then(
                          (value) {
                            if (value != null) {
                              orderProvider.sendRequestToProvider(
                                orderId: orders[index].orderId,
                                providerId: value,
                              );
                              photographersProvider.assignOrder(
                                value,
                                orders[index].orderId,
                              );
                            }
                          },
                        );
                      },
                      child: Icon(
                        Icons.check_circle_outline_outlined,
                        size: 35,
                        color: Colors.white,
                      ),
                    ),
        );
      },
      itemCount: orders.length,
    );
  }
}
