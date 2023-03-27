import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/product.provider.dart';
import '../providers/products.provider.dart';
import '../widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFavorites;

  const ProductGrid(this.showFavorites, {super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<Products>(context);

    List<Product> products = [];

    if (showFavorites) {
      products = provider.favoriteProducts;
    } else {
      products = provider.products;
    }

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: products[index],
        child: const ProductItem(),
      ),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
    );
  }
}
