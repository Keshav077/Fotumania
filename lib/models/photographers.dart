import 'package:flutter/material.dart';

enum Orders { Request, Accepted, Completed }

class Photographers {
  final String id;
  final String photographerId;
  double ratings;
  List<String> specialization;
  bool isVerified;
  Map<Orders, List<String>> contracts;

  Photographers({
    @required this.id,
    this.photographerId,
    this.specialization,
    this.ratings,
    this.contracts,
    this.isVerified = false,
  });
}
