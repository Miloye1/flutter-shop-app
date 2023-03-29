import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    required this.id,
    required this.title,
    required this.description,
    required this.price,
    required this.imageUrl,
    this.isFavorite = false,
  });

  Product copyWith({
    String? id,
    String? title,
    String? description,
    double? price,
    String? imageUrl,
  }) =>
      Product(
        id: id ?? this.id,
        title: title ?? this.title,
        description: description ?? this.description,
        price: price ?? this.price,
        imageUrl: imageUrl ?? this.imageUrl,
        isFavorite: isFavorite,
      );

  Future<void> toggleFavorite() async {
    isFavorite = !isFavorite;
    notifyListeners();

    final url = Uri.parse(
        'https://flutter-shop-713a6-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');

    try {
      var response =
          await http.patch(url, body: jsonEncode({'isFavorite': isFavorite}));

      if (response.statusCode >= 400) {
        isFavorite = !isFavorite;
        notifyListeners();
      }
    } catch (e) {
      isFavorite = !isFavorite;
      notifyListeners();
    }
  }

  @override
  String toString() {
    print('${id} ${title} ${description} ${price} ${imageUrl}');
    return super.toString();
  }

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'description': description,
      'price': price,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
    };
  }
}
