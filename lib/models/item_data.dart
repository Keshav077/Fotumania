import 'package:flutter/material.dart';

class ItemData {
  final String serviceId;
  final String itemId;
  final bool hasClasses, needDate, needLocation, needImage;
  String name;
  String imageUrl;
  String content;
  List<dynamic> classes;

  ItemData({
    @required this.serviceId,
    @required this.name,
    @required this.itemId,
    @required this.imageUrl,
    @required this.content,
    @required this.classes,
    this.hasClasses = false,
    this.needDate = false,
    this.needLocation = false,
    this.needImage = false,
  });
}
