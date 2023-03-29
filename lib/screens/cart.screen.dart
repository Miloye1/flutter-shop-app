import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/cart_item.dart';
import '../providers/orders.provider.dart';
import '../providers/cart.provider.dart' show Cart;

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';

  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cartProvider = Provider.of<Cart>(context);
    final ordersProvider = Provider.of<Orders>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your cart'),
      ),
      body: Column(
        children: [
          Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      '\$${cartProvider.totalAmount.toStringAsFixed(2)}',
                      style: const TextStyle(color: Colors.white),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(
                      cartProvider: cartProvider,
                      ordersProvider: ordersProvider),
                ],
              ),
            ),
          ),
          const SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemCount: cartProvider.itemCount,
              itemBuilder: (ctx, index) => CartItem(
                cartProvider.cartItems.values.toList()[index].id,
                cartProvider.cartItems.values.toList()[index].price,
                cartProvider.cartItems.values.toList()[index].title,
                cartProvider.cartItems.values.toList()[index].quantity,
                cartProvider.cartItems.keys.toList()[index],
              ),
            ),
          )
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    super.key,
    required this.cartProvider,
    required this.ordersProvider,
  });

  final Cart cartProvider;
  final Orders ordersProvider;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: (widget.cartProvider.totalAmount <= 0 || isLoading)
          ? null
          : () async {
              setState(() {
                isLoading = true;
              });
              await widget.ordersProvider.addOrder(
                widget.cartProvider.cartItems.values.toList(),
                widget.cartProvider.totalAmount,
              );

              setState(() {
                isLoading = false;
              });

              widget.cartProvider.clearCart();
            },
      child: isLoading
          ? const CircularProgressIndicator()
          : const Text('ORDER NOW'),
    );
  }
}
