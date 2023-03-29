import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/cart_item.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem(this.id, this.amount, this.products, this.dateTime);
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> getOrders() async {
    final url = Uri.parse(
        'https://flutter-shop-713a6-default-rtdb.europe-west1.firebasedatabase.app/orders.json');

    final response = await http.get(url);
    final List<OrderItem> orders = [];
    final data = jsonDecode(response.body) as Map<String, dynamic>?;

    if (data == null) return;

    data.forEach((key, value) {
      orders.add(
        OrderItem(
          key,
          value['amount'],
          (value['products'] as List<dynamic>)
              .map((item) => CartItem(
                    item['id'],
                    item['title'],
                    item['quantity'],
                    item['price'],
                  ))
              .toList(),
          DateTime.parse(value['dateTime']),
        ),
      );
    });

    _orders = orders.reversed.toList();

    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> products, double total) async {
    final url = Uri.parse(
        'https://flutter-shop-713a6-default-rtdb.europe-west1.firebasedatabase.app/orders.json');

    final timestamp = DateTime.now();

    var response = await http.post(
      url,
      body: jsonEncode({
        'amount': total,
        'dateTime': timestamp.toIso8601String(),
        'products': products
            .map((p) => {
                  'id': p.id,
                  'title': p.title,
                  'price': p.price,
                  'quantity': p.quantity,
                })
            .toList(),
      }),
    );

    _orders.insert(
      0,
      OrderItem(
        jsonDecode(response.body)['name'],
        total,
        products,
        timestamp,
      ),
    );

    notifyListeners();
  }
}
