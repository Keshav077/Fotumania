import 'package:flutter/material.dart';
import 'package:fotumania/models/order_info.dart';
import 'package:fotumania/providers/order_provider.dart';
import 'package:fotumania/widgets/order_list.dart';
import 'package:provider/provider.dart';
import 'package:toast/toast.dart';

class AdminWorkSpace extends StatefulWidget {
  @override
  _AdminWorkSpaceState createState() => _AdminWorkSpaceState();
}

class _AdminWorkSpaceState extends State<AdminWorkSpace> {
  OrderStatus show = OrderStatus.Ordered;
  bool _isInit = false, _isLoading = false;

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (!_isInit) {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<OrderProvider>(context, listen: false)
            .fetchAndSetOrders();
      } catch (error) {
        Toast.show("Error Loading... Please Refresh!", context,
            duration: 2, backgroundColor: Colors.red);
      }
      setState(() {
        _isLoading = false;
      });

      _isInit = true;
    }
  }

  Future<void> _refreshPage(BuildContext context) async {
    try {
      await Provider.of<OrderProvider>(context, listen: false)
          .fetchAndSetOrders();
    } catch (error) {
      Toast.show(
        "Error Loading... Please Refresh!",
        context,
        duration: 2,
        backgroundColor: Colors.red,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size mqs = MediaQuery.of(context).size;
    return Container(
      // padding: EdgeInsets.all(15),
      child: RefreshIndicator(
        onRefresh: () => _refreshPage(context),
        child: Column(
          children: [
            Container(
              height: mqs.height * 0.04,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  InkWell(
                    onTap: () {
                      setState(
                        () {
                          show = OrderStatus.Ordered;
                        },
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: mqs.width * 0.2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: show == OrderStatus.Ordered
                              ? Colors.redAccent
                              : Colors.redAccent[100]),
                      child: Text(
                        "Orders",
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(
                        () {
                          show = OrderStatus.RequestSent;
                        },
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: mqs.width * 0.2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: show == OrderStatus.RequestSent
                              ? Colors.orangeAccent
                              : Colors.orangeAccent[100]),
                      child: Text(
                        "Requests Sent",
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(
                        () {
                          show = OrderStatus.Assigned;
                        },
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: mqs.width * 0.2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: show == OrderStatus.Assigned
                              ? Colors.amber
                              : Colors.amberAccent[100]),
                      child: Text(
                        "Assigned",
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      setState(
                        () {
                          show = OrderStatus.Completed;
                        },
                      );
                    },
                    child: Container(
                      alignment: Alignment.center,
                      width: mqs.width * 0.2,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: show == OrderStatus.Completed
                              ? Colors.greenAccent
                              : Colors.greenAccent[100]),
                      child: Text(
                        "Completed",
                        style: Theme.of(context).textTheme.caption,
                      ),
                    ),
                  )
                ],
              ),
            ),
            SizedBox(
              height: 10,
            ),
            Expanded(
              child: _isLoading
                  ? Center(
                      child: CircularProgressIndicator(
                      backgroundColor: Colors.white,
                      valueColor: AlwaysStoppedAnimation(Colors.blue),
                    ))
                  : OrderList(show),
            ),
          ],
        ),
      ),
    );
  }
}
