import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.provider.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = '/orders';

  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<Orders>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your orders'),
      ),
      body: ListView.builder(
        itemCount: ordersProvider.orders.length,
        itemBuilder: (ctx, index) => OrderItem(ordersProvider.orders[index]),
      ),
    );
  }
}
