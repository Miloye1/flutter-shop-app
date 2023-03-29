import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product.screen.dart';
import '../widgets/user_product_item.dart';
import '../widgets/app_drawer.dart';
import '../providers/products.provider.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = '/user-products';
  const UserProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final productProvider = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your products'),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: productProvider.getProducts,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.builder(
            itemCount: productProvider.products.length,
            itemBuilder: (_, index) => Column(
              children: [
                UserProductItem(
                  productProvider.products[index].id,
                  productProvider.products[index].title,
                  productProvider.products[index].imageUrl,
                ),
                const Divider(),
              ],
            ),
          ),
        ),
      ),
      drawer: const AppDrawer(),
    );
  }
}
