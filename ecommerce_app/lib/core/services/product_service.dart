import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ecommerce_app/core/models/product.dart';

class ProductService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Stream<List<Product>> getProducts() {
    return _firestore
        .collection('products')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Product.fromMap(doc.data(), doc.id))
            .toList());
  }

  Future<Product?> getProductById(String id) async {
    final doc = await _firestore.collection('products').doc(id).get();
    return doc.exists ? Product.fromMap(doc.data()!, doc.id) : null;
  }

  Future<List<Product>> getFeaturedProducts() async {
    final snapshot = await _firestore
        .collection('products')
        .where('isFeatured', isEqualTo: true)
        .limit(8)
        .get();
    return snapshot.docs
        .map((doc) => Product.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<Product>> searchProducts(String query) async {
    final snapshot = await _firestore
        .collection('products')
        .where('name', isGreaterThanOrEqualTo: query)
        .where('name', isLessThan: query + 'z')
        .get();
    return snapshot.docs
        .map((doc) => Product.fromMap(doc.data(), doc.id))
        .toList();
  }

  Future<List<Product>> getProductsByCategory(String category) async {
    final snapshot = await _firestore
        .collection('products')
        .where('categories', arrayContains: category)
        .get();
    return snapshot.docs
        .map((doc) => Product.fromMap(doc.data(), doc.id))
        .toList();
  }
}