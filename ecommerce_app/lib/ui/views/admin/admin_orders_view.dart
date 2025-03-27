import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/core/services/order_service.dart';
import 'package:ecommerce_app/core/models/order.dart';
import 'package:ecommerce_app/ui/views/order/order_detail_view.dart';

class AdminOrdersView extends StatelessWidget {
  const AdminOrdersView({super.key});

  @override
  Widget build(BuildContext context) {
    final orderService = Provider.of<OrderService>(context);

    return Scaffold(
      body: StreamBuilder<List<Order>>(
        stream: orderService.getAllOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No orders found'));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => OrderDetailView(orderId: order.id),
                      ),
                    );
                  },
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Order #${order.id.substring(0, 8).toUpperCase()}',
                              style: const TextStyle(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Chip(
                              label: Text(
                                order.status.toString().split('.').last,
                                style: const TextStyle(color: Colors.white),
                              ),
                              backgroundColor: _getStatusColor(order.status),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${order.items.length} items • \$${order.total.toStringAsFixed(2)}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Placed on ${_formatDate(order.createdAt)}',
                          style: const TextStyle(color: Colors.grey),
                        ),
                        if (order.status == OrderStatus.processing)
                          const SizedBox(height: 16),
                        if (order.status == OrderStatus.processing)
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => _updateOrderStatus(
                                    context,
                                    order.id,
                                    OrderStatus.shipped,
                                  ),
                                  child: const Text('Mark as Shipped'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: () => _updateOrderStatus(
                                    context,
                                    order.id,
                                    OrderStatus.cancelled,
                                  ),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: Colors.red,
                                    side: const BorderSide(color: Colors.red),
                                  ),
                                  child: const Text('Cancel Order'),
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Color _getStatusColor(OrderStatus status) {
    switch (status) {
      case OrderStatus.processing:
        return Colors.orange;
      case OrderStatus.shipped:
        return Colors.blue;
      case OrderStatus.delivered:
        return Colors.green;
      case OrderStatus.cancelled:
        return Colors.red;
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  Future<void> _updateOrderStatus(
    BuildContext context,
    String orderId,
    OrderStatus status,
  ) async {
    await Provider.of<OrderService>(context, listen: false)
        .updateOrderStatus(orderId, status);
  }
}