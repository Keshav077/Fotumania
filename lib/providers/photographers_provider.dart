import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:fotumania/exception/user_name_exists.dart';
import 'package:http/http.dart' as http;

import '../models/photographers.dart';

class PhotographersProvider with ChangeNotifier {
  List<Photographers> _photographers = [];

  Future<void> createPhotographer(String id) async {
    // print(id);
    Uri url = Uri.parse(
        'https://fotumania-33638-default-rtdb.firebaseio.com/photographers.json');
    try {
      final response = await http.post(
        url,
        body: json.encode({
          'id': id,
          'isVerified': "false",
          'specialization': '',
          'ratings': "3",
          'contracts': ['', '', ''],
        }),
      );
      print(json.decode(response.body));
      final photoId = json.decode(response.body)['name'];
      _photographers.add(Photographers(
          id: id,
          photographerId: photoId,
          isVerified: false,
          ratings: 3,
          specialization: []));
      print(_photographers);
      notifyListeners();
    } catch (error) {
      print(error);
      throw UserNameExistsException("Couldn't create the account");
    }
  }

  Future<void> fetchAllPhotographers() async {
    _photographers = [];
    Uri url = Uri.parse(
        'https://fotumania-33638-default-rtdb.firebaseio.com/photographers.json');
    try {
      final response = await http.get(url);
      final extracted = json.decode(response.body) as Map<String, dynamic>;
      extracted.forEach((key, value) {
        _photographers.add(
          Photographers(
            id: value['id'],
            photographerId: key,
            isVerified: value['isVerified'].toLowerCase() == 'true',
            ratings: double.parse(value['ratings']),
            specialization: value['specialization'].split(","),
            contracts: convertToContracts(value['contracts']),
          ),
        );
      });
      print(_photographers);
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Map<Orders, List<String>> convertToContracts(
      List<dynamic> extractedContracts) {
    return {
      Orders.Request:
          extractedContracts[0] == "" ? [] : extractedContracts[0].split(","),
      Orders.Accepted:
          extractedContracts[1] == "" ? [] : extractedContracts[1].split(","),
      Orders.Completed:
          extractedContracts[2] == "" ? [] : extractedContracts[2].split(","),
    };
  }

  List<Photographers> get photographers {
    return [..._photographers];
  }

  Photographers getPhotographerWithId(String id) {
    print(id);
    print(_photographers);
    return _photographers[
        _photographers.indexWhere((element) => element.id == id)];
  }

  Future<void> updateRatings(String id, double ratings) async {
    try {
      Uri url = Uri.parse(
          'https://fotumania-33638-default-rtdb.firebaseio.com/photographers/$id.json');
      int index =
          _photographers.indexWhere((element) => element.photographerId == id);
      int completed = _photographers[index].contracts[Orders.Completed].length;
      final r = ((_photographers[index].ratings * (completed - 1) + ratings) /
          completed);
      await http.patch(url, body: json.encode({'ratings': r.toString()}));
      _photographers[index].ratings = r;
    } catch (error) {
      print(error);
    }
  }

  Future verifyPhotographer(String id) async {
    try {
      Uri url = Uri.parse(
          'https://fotumania-33638-default-rtdb.firebaseio.com/photographers/$id.json');
      await http.patch(url, body: json.encode({'isVerified': 'true'}));
      _photographers[_photographers
              .indexWhere((element) => element.photographerId == id)]
          .isVerified = true;
    } catch (error) {
      print(error);
    }
  }

  List<Photographers> filterPhotograpers({String serviceType}) {
    List<Photographers> result = [];
    print(serviceType);
    for (int i = 0; i < _photographers.length; i++) {
      if (_photographers[i].specialization.contains(serviceType))
        result.add(_photographers[i]);
    }
    return result;
  }

  Future<void> assignOrder(String id, String orderId) async {
    try {
      Uri url = Uri.parse(
          'https://fotumania-33638-default-rtdb.firebaseio.com/photographers/$id/contracts.json');
      int index =
          _photographers.indexWhere((element) => element.photographerId == id);
      print(_photographers[index].contracts[Orders.Request].length);
      String req = _photographers[index].contracts[Orders.Request] == null ||
              _photographers[index].contracts[Orders.Request].length == 0
          ? orderId
          : _photographers[index].contracts[Orders.Request].join(',') +
              ',' +
              orderId;
      print(req);
      final response = await http.patch(url, body: json.encode({'0': req}));
      if (response.statusCode >= 400) throw Exception();
      _photographers[index].contracts[Orders.Request].add(orderId);
    } catch (error) {
      print("Something went wrong");
    }
    notifyListeners();
  }

  Future<void> acceptOrder(String id, String orderId) async {
    // try {
    Uri url = Uri.parse(
        'https://fotumania-33638-default-rtdb.firebaseio.com/photographers/$id/contracts.json');
    int index =
        _photographers.indexWhere((element) => element.photographerId == id);
    // print(_photographers);
    // print(index);
    final requestedOrders = [
      ..._photographers[index].contracts[Orders.Request]
    ];
    final acceptedOrders = [
      ..._photographers[index].contracts[Orders.Accepted]
    ];

    requestedOrders.remove(orderId);
    acceptedOrders.add(orderId);

    String request = requestedOrders.join(',');
    String accepted = acceptedOrders.join(',');
    print(request + " " + accepted);
    final response =
        await http.patch(url, body: json.encode({'0': request, '1': accepted}));
    if (response.statusCode >= 400) throw Exception();
    _photographers[index].contracts[Orders.Request] = requestedOrders;
    _photographers[index].contracts[Orders.Accepted] = acceptedOrders;
    // } catch (error) {
    //   print(
    //       "Something went wrong when assigning the order to the service provider");
    // }
    notifyListeners();
  }

  Future<void> orderCompleted(String id, String orderId) async {
    try {
      Uri url = Uri.parse(
          'https://fotumania-33638-default-rtdb.firebaseio.com/photographers/$id/contracts.json');
      int index =
          _photographers.indexWhere((element) => element.photographerId == id);
      print(index);
      final acceptedOrders = [
        ..._photographers[index].contracts[Orders.Accepted]
      ];
      final completedOrders = [
        ..._photographers[index].contracts[Orders.Completed]
      ];

      bool acc = acceptedOrders.remove(orderId);
      completedOrders.add(orderId);
      print(acc);
      if (!acc) throw Exception();

      String accepted = acceptedOrders.join(',');
      String completed = completedOrders.join(',');

      final response = await http.patch(url,
          body: json.encode({'1': accepted, '2': completed}));

      if (response.statusCode >= 400) throw Exception();

      _photographers[index].contracts[Orders.Accepted] = acceptedOrders;
      _photographers[index].contracts[Orders.Completed] = completedOrders;
    } catch (error) {
      print(
          "Something went wrong when updating the completed status in the server");
    }
    notifyListeners();
    // for (int i = 0; i < _photographers.length; i++) {
    //   if (_photographers[i].id == id) {
    //     _photographers[i].contracts[Orders.Accepted].remove(orderId);
    //     _photographers[i].contracts[Orders.Completed].add(orderId);
    //   }
    // }
    // notifyListeners();
  }
}

// void editPhotographerDetails(
//     {String id, String pricePerHour, String specialization}) {
//   int index = _photographers.indexWhere((element) => element.id == id);

//   _photographers[index].specialization = specialization.split(', ');
// }
