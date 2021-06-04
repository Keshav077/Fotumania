import 'package:flutter/material.dart';
import 'package:fotumania/models/item_data.dart';
import 'dart:convert';

import 'package:http/http.dart' as http;

class ItemProvider with ChangeNotifier {
  List<ItemData> _itemsList = [];

  List<ItemData> get itemsList {
    return [..._itemsList];
  }

  Future<void> fetchItemsFromServer() async {
    Uri url = Uri.parse(
        "https://fotumania-33638-default-rtdb.firebaseio.com/items.json");
    try {
      final response = await http.get(url);
      final items = json.decode(response.body) as Map<String, dynamic>;
      if (items == null) {
        return;
      }
      List<ItemData> loadedData = [];
      items.forEach(
        (key, value) {
          loadedData.add(
            ItemData(
              itemId: key,
              content: items[key]['content'],
              classes: items[key]['classes'],
              imageUrl: items[key]['imageUrl'],
              name: items[key]['name'],
              serviceId: items[key]['serviceId'],
              hasClasses: items[key]['hasClasses'],
              needDate: items[key]['needDate'],
              needImage: items[key]['needImage'],
              needLocation: items[key]['needLocation'],
            ),
          );
        },
      );
      _itemsList = loadedData;
      notifyListeners();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> addItemToService({
    String serviceId,
    String name,
    List<Map<String, dynamic>> classes,
    String imageUrl,
    String content,
    bool needDate,
    bool needLocation,
    bool needImage,
    bool hasClasses,
  }) async {
    try {
      Uri url = Uri.parse(
          "https://fotumania-33638-default-rtdb.firebaseio.com/items.json");
      final response = await http.post(
        url,
        body: json.encode(
          {
            'serviceId': serviceId,
            'name': name,
            'imageUrl': imageUrl,
            'content': content,
            'classes': classes,
            'needDate': needDate,
            'needLocation': needLocation,
            'needImage': needImage,
            'hasClasses': hasClasses,
          },
        ),
      );
      ItemData item = ItemData(
        serviceId: serviceId,
        itemId: json.decode(response.body)['name'],
        name: name,
        imageUrl: imageUrl,
        content: content,
        classes: classes,
      );
      _itemsList.add(item);

      notifyListeners();
    } catch (error) {
      throw Exception(error);
    }
  }

  List<ItemData> getItemsOfService(String serviceId) {
    return itemsList
        .where((element) => element.serviceId == serviceId)
        .toList();
  }

  Future<void> editItem({
    String id,
    String name,
    String imageUrl,
    String content,
    List<Map<String, dynamic>> classes,
    bool needLocation,
    bool needDate,
    bool needImage,
    bool hasClasses,
  }) async {
    final itemInd = _itemsList.indexWhere((item) => item.itemId == id);
    Uri url = Uri.parse(
        "https://fotumania-33638-default-rtdb.firebaseio.com/items/$id.json");
    try {
      final response = await http.patch(
        url,
        body: json.encode(
          {
            "name": name,
            "imageUrl": imageUrl,
            "content": content,
            "classes": classes,
            'needDate': needDate,
            'needLocation': needLocation,
            'needImage': needImage,
            'hasClasses': hasClasses,
          },
        ),
      );
      if (response.statusCode >= 400) throw Exception("Something went wrong!");

      _itemsList[itemInd].name = name;
      _itemsList[itemInd].imageUrl = imageUrl;
      _itemsList[itemInd].content = content;
      _itemsList[itemInd].classes = classes;

      notifyListeners();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> removeClassFromItem(String itemId, int classIndex) async {
    final index = _itemsList.indexWhere((element) => element.itemId == itemId);
    Uri url = Uri.parse(
        "https://fotumania-33638-default-rtdb.firebaseio.com/items/${_itemsList[index].itemId}/classes/$classIndex.json");
    try {
      final response = await http.delete(url);
      if (response.statusCode >= 400) throw Exception("Error");
    } catch (error) {
      throw Exception(error);
    }
    _itemsList[index].classes.removeAt(classIndex);
    notifyListeners();
  }
}
