import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/core/models/order.dart';
import 'package:ecommerce_app/core/models/product.dart';
import 'package:ecommerce_app/core/services/cart_service.dart';

class OrderService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Order> createOrder({
    required List<CartItem> items,
    required double total,
    required String shippingAddress,
  }) async {
    final orderRef = _firestore.collection('orders').doc();
    final order = Order(
      id: orderRef.id,
      items: items.map((item) => OrderItem(
        productId: item.product.id,
        productName: item.product.name,
        quantity: item.quantity,
        price: item.product.price,
      )).toList(),
      total: total,
      status: OrderStatus.processing,
      createdAt: DateTime.now(),
      shippingAddress: shippingAddress,
    );

    await orderRef.set(order.toMap());
    return order;
  }

  Stream<List<Order>> getUserOrders(String userId) {
    return _firestore
        .collection('orders')
        .where('userId', isEqualTo: userId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Order.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<void> updateOrderStatus(String orderId, OrderStatus status) async {
    await _firestore
        .collection('orders')
        .doc(orderId)
        .update({'status': status.toString()});
  }
}