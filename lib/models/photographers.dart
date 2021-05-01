import 'package:flutter/material.dart';

enum Orders { Request, Accepted, Completed }

class Photographers {
  final String id;
  double ratings;
  String pricePerHour;
  List<String> specialization;
  Map<Orders, List<String>> contracts = {
    Orders.Request: [],
    Orders.Accepted: [],
    Orders.Completed: []
  };

  Photographers({
    @required this.id,
    this.specialization,
    this.ratings,
    this.pricePerHour,
    this.contracts,
  });
}
