import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './providers/orders.provider.dart';
import './providers/cart.provider.dart';
import './providers/products.provider.dart';
import './screens/product_details.screen.dart';
import './screens/orders.screen.dart';
import './screens/products_overview.screen.dart';
import './screens/cart.screen.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Products(),
        ),
        ChangeNotifierProvider(
          create: (_) => Cart(),
        ),
        ChangeNotifierProvider(
          create: (_) => Orders(),
        ),
      ],
      child: MaterialApp(
        title: 'Shop',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.deepOrange,
        ),
        routes: {
          ProductsOverviewScreen.routeName: (ctx) =>
              const ProductsOverviewScreen(),
          ProductDetailsScreen.routeName: (ctx) => const ProductDetailsScreen(),
          CartScreen.routeName: (ctx) => const CartScreen(),
          OrdersScreen.routeName: (ctx) => const OrdersScreen(),
        },
      ),
    );
  }
}
