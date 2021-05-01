import 'package:flutter/cupertino.dart';
import 'package:fotumania/models/order_info.dart';
import '../models/order_info.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';

class OrderProvider with ChangeNotifier {
  List<OrderInfo> _orders = [];

  List<OrderInfo> get orders {
    return [..._orders];
  }

  Future<void> setRatings(String id, String userId, double ratings) async {
    try {
      final index = _orders.indexWhere((element) => element.orderId == id);
      Uri url = Uri.parse(
          "https://fotumania-33638-default-rtdb.firebaseio.com/users/$userId/orders/$id/orderInfo.json");
      await http.put(
        url,
        body: {'ratings': ratings.toString()},
      );
      _orders[index].orderInfo['ratings'] = ratings.toString();
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }

  Future<void> sendRequestToProvider({
    String orderId,
    String providerId,
    String userId,
  }) async {
    try {
      Uri url = Uri.parse(
          "https://fotumania-33638-default-rtdb.firebaseio.com/users/$userId/orders/$orderId.json");
      final response =
          await http.patch(url, body: json.encode({"orderStatus": "1"}));
      if (response.statusCode >= 400) throw Exception("Couldn't send request!");
      for (int i = 0; i < _orders.length; i++) {
        if (_orders[i].orderId == orderId) {
          _orders[i].orderStatus = OrderStatus.RequestSent;
          _orders[i].providerId = providerId;
        }
      }
      notifyListeners();
    } catch (error) {
      throw Exception(error);
    }
  }

  Future<void> orderAssigned(
      String orderId, String providerId, String userId) async {
    try {
      Uri url = Uri.parse(
          "https://fotumania-33638-default-rtdb.firebaseio.com/users/$userId/orders/$orderId.json");

      final response = await http.patch(
        url,
        body: json.encode(
          {
            "orderStatus": "2",
            "providerId": providerId,
          },
        ),
      );
      if (response.statusCode >= 400) {
        throw Exception("Error");
      }
      for (int i = 0; i < _orders.length; i++) {
        if (_orders[i].orderId == orderId) {
          _orders[i].orderStatus = OrderStatus.Assigned;
          _orders[i].providerId = providerId;
        }
      }
      notifyListeners();
    } catch (error) {
      throw Exception("Error");
    }
  }

  Future<void> orderCompleted(String id, String userId) async {
    try {
      Uri url = Uri.parse(
          "https://fotumania-33638-default-rtdb.firebaseio.com/users/$userId/orders/$id.json");
      final response = await http.patch(
        url,
        body: json.encode(
          {"orderStatus": "3"},
        ),
      );
      if (response.statusCode >= 400) {
        throw Exception("Error");
      }
      for (int i = 0; i < _orders.length; i++) {
        if (_orders[i].orderId == id)
          _orders[i].orderStatus = OrderStatus.Completed;
      }
      notifyListeners();
    } catch (error) {
      throw Exception("Error updating!");
    }
  }

  List<OrderInfo> getAssignedOrders(OrderStatus show) {
    List<OrderInfo> result = [];
    for (int i = 0; i < _orders.length; i++) {
      if (_orders[i].orderStatus == show) result.add(_orders[i]);
    }
    return result;
  }

  OrderInfo getOrderById(String id) {
    return _orders.firstWhere((element) => element.orderId == id);
  }

  Future<void> fetchAndSetOrders() async {
    try {
      Uri url = Uri.parse(
          "https://fotumania-33638-default-rtdb.firebaseio.com/users/${FirebaseAuth.instance.currentUser.uid}/orders.json");
      final response = await http.get(url);
      final List<OrderInfo> loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      if (extractedData == null) {
        return;
      }
      extractedData.forEach((orderId, orderData) {
        loadedOrders.add(OrderInfo(
          orderId: orderId,
          orderInfo: orderData["orderInfo"],
          userId: orderData["userId"],
          orderDate: DateTime.parse(orderData["orderDate"]),
          orderStatus: getOrderStatusFromJson(orderData["orderStatus"]),
        ));
      });
      _orders = loadedOrders;
      print(_orders);
      notifyListeners();
    } catch (error) {
      throw Exception("Error fetching data");
    }
  }

  OrderStatus getOrderStatusFromJson(String status) {
    switch (status) {
      case "1":
        return OrderStatus.RequestSent;
      case "2":
        return OrderStatus.Assigned;
      case "3":
        return OrderStatus.Completed;
      default:
        return OrderStatus.Ordered;
    }
  }

  Future<String> createOrder(
      Map<String, dynamic> orderDetails, String userId) async {
    try {
      Uri url = Uri.parse(
          "https://fotumania-33638-default-rtdb.firebaseio.com/users/$userId/orders.json");
      final date = DateTime.now();
      final response = await http.post(
        url,
        body: json.encode({
          "orderInfo": orderDetails,
          "orderDate": date.toIso8601String(),
          "orderStatus": "0",
        }),
      );
      OrderInfo newOrder = OrderInfo(
        orderInfo: orderDetails,
        userId: userId,
        orderDate: date,
        orderId: json.decode(response.body)['name'],
      );
      _orders.add(newOrder);
      notifyListeners();
      return newOrder.orderId;
    } catch (error) {
      print(error);
      throw Exception("Something went wrong!");
    }
  }

  String orderDetailsToString(Map<String, dynamic> order) {
    String res = '';
    order.forEach((key, value) {
      res += key + ": " + value.toString() + "\n";
    });
    return res;
  }

  List<OrderInfo> getUserOrder() {
    List<OrderInfo> userOrders = [];
    _orders.forEach((element) {
      if (element.orderStatus != OrderStatus.Completed) userOrders.add(element);
    });
    return userOrders;
  }

  List<OrderInfo> getUserRecentOrders() {
    List<OrderInfo> userOrders = [];
    _orders.forEach((element) {
      if (element.orderStatus == OrderStatus.Completed) userOrders.add(element);
    });
    return userOrders;
  }
}
