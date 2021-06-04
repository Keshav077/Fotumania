import 'package:flutter/material.dart';
import 'package:fotumania/models/service_data.dart';

import '../providers/service_provider.dart';

class ServicesIcons extends StatelessWidget {
  final double iconSize;
  final String selectedItem;
  final Function setSelectedItem;
  final List<ServiceData> services = ServiceProvider().servicesList;

  ServicesIcons({
    @required this.selectedItem,
    @required this.setSelectedItem,
    @required this.iconSize,
  });

  @override
  Widget build(BuildContext context) {
    final Color iconColor = Colors.grey,
        iconActiveColor = Theme.of(context).primaryColor;
    return Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
      ...services.map((service) {
        return InkWell(
          child: Icon(
            service.icon,
            size: iconSize,
            color:
                selectedItem == service.serviceId ? iconActiveColor : iconColor,
          ),
          onTap: () {
            setSelectedItem(service.serviceId);
          },
        );
      }).toList()
    ]);
  }
}
