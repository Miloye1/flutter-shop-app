import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/cart.screen.dart';
import '../providers/products.provider.dart';
import '../providers/cart.provider.dart';
import '../widgets/app_drawer.dart';
import '../widgets/product_grid.dart';
import '../widgets/badge.dart';

enum FilterOptions {
  favorites,
  all,
}

class ProductsOverviewScreen extends StatefulWidget {
  static const routeName = '/';

  const ProductsOverviewScreen({super.key});

  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  var showFavorites = false;
  var loading = true;

  @override
  void initState() {
    super.initState();

    Provider.of<Products>(context, listen: false).getProducts().then((value) {
      setState(() {
        loading = false;
      });
    });
  }

  void toggleFavoriteProducts(FilterOptions value) {
    setState(() {
      if (FilterOptions.favorites == value) {
        showFavorites = true;
      } else {
        showFavorites = false;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Shop'),
        actions: [
          PopupMenuButton(
            onSelected: toggleFavoriteProducts,
            icon: const Icon(Icons.more_vert),
            itemBuilder: (_) => [
              const PopupMenuItem(
                value: FilterOptions.favorites,
                child: Text('Only favorites'),
              ),
              const PopupMenuItem(
                value: FilterOptions.all,
                child: Text('Show all'),
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (_, cartProvider, ch) => CustomBadge(
              value: cartProvider.itemCount.toString(),
              child: ch!,
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: loading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ProductGrid(showFavorites),
      drawer: const AppDrawer(),
    );
  }
}
