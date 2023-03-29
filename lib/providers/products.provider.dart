import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../models/http_exception.dart';
import './product.provider.dart';

class Products with ChangeNotifier {
  List<Product> _products = [];

  List<Product> get products {
    return [..._products];
  }

  List<Product> get favoriteProducts {
    return _products.where((p) => p.isFavorite == true).toList();
  }

  Product findById(String id) {
    return _products.firstWhere((p) => p.id == id);
  }

  Future<void> getProducts() async {
    final url = Uri.https(
      'flutter-shop-713a6-default-rtdb.europe-west1.firebasedatabase.app',
      'products.json',
    );

    try {
      http.Response response = await http.get(url);

      final data = jsonDecode(response.body) as Map<String, dynamic>?;
      final List<Product> newProducts = [];

      if (data == null) return;

      data.forEach((key, value) {
        newProducts.add(
          Product(
            id: key,
            title: value['title'],
            description: value['description'],
            price: value['price'],
            imageUrl: value['imageUrl'],
            isFavorite: value['isFavorite'],
          ),
        );
      });

      _products = newProducts;

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addProduct(Product product) async {
    final url = Uri.https(
      'flutter-shop-713a6-default-rtdb.europe-west1.firebasedatabase.app',
      'products.json',
    );

    try {
      http.Response response = await http.post(url, body: jsonEncode(product));

      final newProduct = Product(
        id: jsonDecode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      );

      _products.add(newProduct);

      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product product) async {
    final index = _products.indexWhere((p) => p.id == id);

    final url = Uri.parse(
        'https://flutter-shop-713a6-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');

    try {
      await http.patch(
        url,
        body: json.encode({
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
        }),
      );

      _products[index] = product;
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> deleteProduct(String id) async {
    final url = Uri.parse(
        'https://flutter-shop-713a6-default-rtdb.europe-west1.firebasedatabase.app/products/$id.json');

    final index = _products.indexWhere((p) => p.id == id);
    Product? product = _products[index];

    _products.removeAt(index);
    notifyListeners();

    final response = await http.delete(url);

    if (response.statusCode >= 400) {
      _products.insert(index, product);
      notifyListeners();
      throw HttpException('Could not delete product');
    }

    product = null;
  }
}
