import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/core/services/cart_service.dart';
import 'package:ecommerce_app/ui/views/checkout/checkout_view.dart';

class CartView extends StatelessWidget {
  const CartView({super.key});

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Cart'),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cartService.items.length,
              itemBuilder: (context, index) {
                final item = cartService.items[index];
                return Dismissible(
                  key: Key(item.product.id),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    color: Colors.red,
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.only(right: 20),
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    cartService.removeFromCart(item.product.id);
                  },
                  child: ListTile(
                    leading: Image.network(
                      item.product.imageUrl,
                      width: 50,
                      height: 50,
                      fit: BoxFit.cover,
                    ),
                    title: Text(item.product.name),
                    subtitle: Text(
                      '\$${item.product.price.toStringAsFixed(2)} x ${item.quantity}',
                    ),
                    trailing: Text(
                      '\$${(item.product.price * item.quantity).toStringAsFixed(2)}',
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Total:',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '\$${cartService.totalPrice.toStringAsFixed(2)}',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: cartService.items.isEmpty
                        ? null
                        : () {
                            Navigator.pushNamed(context, '/checkout');
                          },
                    child: const Text('Proceed to Checkout'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}