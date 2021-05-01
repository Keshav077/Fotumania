import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/items_provider.dart';
import '../providers/service_provider.dart';

import './editor.dart';

import '../models/service_data.dart';

class EditService extends StatelessWidget {
  static String routeName = '/admin-home/edit-service';

  Future<void> _refreshItems(BuildContext context) async {
    await Provider.of<ItemProvider>(context, listen: false)
        .fetchItemsFromServer();
  }

  @override
  Widget build(BuildContext context) {
    ServiceProvider serviceProvider = Provider.of<ServiceProvider>(
      context,
      listen: false,
    );
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
          body: RefreshIndicator(
            backgroundColor: Colors.white,
            color: Theme.of(context).primaryColor,
            onRefresh: () => _refreshItems(context),
            child: Container(
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
              child: ListView(
                children: [
                  ...serviceProvider.servicesList
                      .map((e) => buildServiceListCard(e, context))
                      .toList(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget buildServiceListCard(ServiceData service, BuildContext context) {
    ItemProvider itemProvider = Provider.of<ItemProvider>(
      context,
    );
    return Container(
      margin: EdgeInsets.all(10),
      padding: EdgeInsets.all(10),
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Colors.white12,
      ),
      child: Column(
        children: [
          Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              // color: Colors.blue[100],
            ),
            width: MediaQuery.of(context).size.width,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  service.serviceName,
                  textAlign: TextAlign.left,
                  style: Theme.of(context).textTheme.headline4,
                ),
                IconButton(
                  onPressed: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => Editor(
                          service.serviceId,
                          null,
                          true,
                        ),
                      ),
                    );
                  },
                  icon: Icon(Icons.add),
                ),
              ],
            ),
          ),
          Divider(
            color: Colors.white,
          ),
          ...itemProvider.getItemsOfService(service.serviceId).map(
                (e) => InkWell(
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (ctx) => Editor(null, e, false),
                      ),
                    );
                  },
                  child: Container(
                    width: double.infinity,
                    margin: EdgeInsets.all(5),
                    child: Text(
                      e.name,
                      style: Theme.of(context).textTheme.headline5,
                    ),
                  ),
                ),
              ),
        ],
      ),
    );
  }
}
