import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.provider.dart' show Orders;
import '../widgets/order_item.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = '/orders';

  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  Future? ordersFuture;

  Future getOrdersFuture() {
    return Provider.of<Orders>(context, listen: false).getOrders();
  }

  @override
  void initState() {
    ordersFuture = getOrdersFuture();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ordersProvider = Provider.of<Orders>(context, listen: false);
    print('ads');

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your orders'),
      ),
      body: FutureBuilder(
        future: ordersFuture,
        builder: (ctx, response) {
          if (response.connectionState == ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else {
            if (response.error == null) {
              return RefreshIndicator(
                onRefresh: ordersProvider.getOrders,
                child: Consumer<Orders>(
                  builder: (_, ordersProvider, __) => ListView.builder(
                    itemCount: ordersProvider.orders.length,
                    itemBuilder: (ctx, index) =>
                        OrderItem(ordersProvider.orders[index]),
                  ),
                ),
              );
            } else {
              return const Center(
                child: Text('Error'),
              );
            }
          }
        },
      ),
    );
  }
}
