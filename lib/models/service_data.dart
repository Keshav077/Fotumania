import 'package:flutter/cupertino.dart';

class ServiceData {
  final String serviceId;
  final String serviceName;
  final String serviceContent;
  final IconData icon;
  final double widthRatio;

  ServiceData({
    this.serviceId,
    this.serviceName,
    this.serviceContent,
    this.icon,
    this.widthRatio,
  });
}
