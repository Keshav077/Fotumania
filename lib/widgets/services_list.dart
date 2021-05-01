import 'package:flutter/material.dart';
import 'package:fotumania/providers/items_provider.dart';

import 'package:fotumania/widgets/service_item_card.dart';
import 'package:provider/provider.dart';

import '../models/item_data.dart';

class ServiceList extends StatelessWidget {
  final String serviceId;
  final double widthRatio;

  ServiceList({this.serviceId, this.widthRatio});

  @override
  Widget build(BuildContext context) {
    final List<ItemData> services =
        Provider.of<ItemProvider>(context).getItemsOfService(serviceId);
    return ListView(
      key: ValueKey(serviceId),
      scrollDirection: Axis.horizontal,
      children: services.map((service) {
        return ServiceItem(
          item: service,
          widthRatio: widthRatio,
        );
      }).toList(),
    );
  }
}
