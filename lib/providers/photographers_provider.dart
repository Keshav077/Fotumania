import 'package:flutter/cupertino.dart';

import '../models/photographers.dart';

class PhotographersProvider with ChangeNotifier {
  List<Photographers> _photographers = [
    Photographers(id: "1", pricePerHour: "2000", ratings: 4.5, contracts: {
      Orders.Request: [],
      Orders.Accepted: [],
      Orders.Completed: [],
    }, specialization: [
      '-MYWSrrscs1PhJnhUqpu',
    ]),
    Photographers(
      id: "2",
      pricePerHour: "1500",
      ratings: 4.8,
      specialization: [
        '-MYWSrrscs1PhJnhUqpu',
      ],
      contracts: {
        Orders.Request: [],
        Orders.Accepted: [],
        Orders.Completed: [],
      },
    ),
  ];

  List<Photographers> get photographers {
    return [..._photographers];
  }

  Photographers getPhotographerWithId(String id) {
    return _photographers[
        _photographers.indexWhere((element) => element.id == id)];
  }

  void editPhotographerDetails(
      {String id, String pricePerHour, String specialization}) {
    int index = _photographers.indexWhere((element) => element.id == id);
    _photographers[index].pricePerHour = pricePerHour;
    _photographers[index].specialization = specialization.split(', ');
  }

  List<Photographers> filterPhotograpers({String serviceType}) {
    List<Photographers> result = [];
    for (int i = 0; i < _photographers.length; i++) {
      if (_photographers[i].specialization.contains(serviceType))
        result.add(_photographers[i]);
    }
    return result;
  }

  void assignOrder(String id, String orderId) {
    for (int i = 0; i < _photographers.length; i++) {
      if (_photographers[i].id == id) {
        _photographers[i].contracts[Orders.Request].add(orderId);
      }
    }
    notifyListeners();
  }

  void acceptOrder(String id, String orderId) {
    for (int i = 0; i < _photographers.length; i++) {
      if (_photographers[i].id == id) {
        _photographers[i].contracts[Orders.Request].remove(orderId);
        _photographers[i].contracts[Orders.Accepted].add(orderId);
      }
    }
    notifyListeners();
  }

  void orderCompleted(String id, String orderId) {
    for (int i = 0; i < _photographers.length; i++) {
      if (_photographers[i].id == id) {
        _photographers[i].contracts[Orders.Accepted].remove(orderId);
        _photographers[i].contracts[Orders.Completed].add(orderId);
      }
    }
    notifyListeners();
  }
}
