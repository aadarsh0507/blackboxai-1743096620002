import 'package:flutter/material.dart';
import 'package:ecommerce_app/ui/widgets/rtl_aware_widget.dart';
import 'package:ecommerce_app/utils/rtl_utils.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/core/models/product.dart';
import 'package:ecommerce_app/core/services/cart_service.dart';

class ProductDetailView extends StatelessWidget {
  final Product product;

  const ProductDetailView({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    final cartService = Provider.of<CartService>(context);
    int quantity = 1;

    return Scaffold(
      appBar: AppBar(
        title: Text(product.name),
        actions: [
          IconButton(
            icon: const Icon(Icons.shopping_cart),
            onPressed: () {
              Navigator.pushNamed(context, '/cart');
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: Image.network(
                product.imageUrl,
                fit: BoxFit.cover,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    style: Theme.of(context).textTheme.headline5?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '\$${product.price.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.headline6?.copyWith(
                          color: Theme.of(context).colorScheme.secondary,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      const Icon(Icons.star, color: Colors.amber, size: 20),
                      Text(
                        ' ${product.rating.toStringAsFixed(1)} (${product.reviewCount} reviews)',
                        style: Theme.of(context).textTheme.subtitle1,
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: Theme.of(context).textTheme.subtitle1?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    product.description,
                    style: Theme.of(context).textTheme.bodyText2,
                  ),
                  const SizedBox(height: 24),
                  if (product.stock > 0)
                    StatefulBuilder(
                      builder: (context, setState) {
                        return Row(
                          children: [
                            IconButton(
                              icon: const Icon(Icons.remove),
                              onPressed: quantity > 1
                                  ? () => setState(() => quantity--)
                                  : null,
                            ),
                            Text(
                              quantity.toString(),
                              style: Theme.of(context).textTheme.headline6,
                            ),
                            IconButton(
                              icon: const Icon(Icons.add),
                              onPressed: quantity < product.stock
                                  ? () => setState(() => quantity++)
                                  : null,
                            ),
                            const Spacer(),
                            ElevatedButton.icon(
                              icon: const Icon(Icons.shopping_cart),
                              label: const Text('Add to Cart'),
                              onPressed: () {
                                cartService.addToCart(product, quantity);
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Text(
                                        '${product.name} added to cart!'),
                                  ),
                                );
                              },
                            ),
                          ],
                        );
                      },
                    )
                  else
                    Text(
                      'Out of Stock',
                      style: Theme.of(context).textTheme.subtitle1?.copyWith(
                            color: Colors.red,
                          ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}