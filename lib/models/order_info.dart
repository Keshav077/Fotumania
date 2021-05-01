import 'package:flutter/material.dart';

enum OrderStatus { Ordered, RequestSent, Assigned, Completed }

class OrderInfo {
  final String orderId;
  final String userId;
  final Map<String, dynamic> orderInfo;
  DateTime orderDate;
  OrderStatus orderStatus = OrderStatus.Ordered;
  String providerId = "1";

  OrderInfo({
    @required this.orderId,
    @required this.orderInfo,
    @required this.userId,
    this.orderStatus,
    this.orderDate,
  });
}
