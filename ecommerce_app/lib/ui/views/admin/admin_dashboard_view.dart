import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ecommerce_app/core/services/order_service.dart';
import 'package:ecommerce_app/core/services/product_service.dart';
import 'package:ecommerce_app/ui/views/admin/admin_orders_view.dart';
import 'package:ecommerce_app/ui/views/admin/admin_products_view.dart';
import 'package:ecommerce_app/ui/views/admin/admin_users_view.dart';

class AdminDashboardView extends StatefulWidget {
  const AdminDashboardView({super.key});

  @override
  State<AdminDashboardView> createState() => _AdminDashboardViewState();
}

class _AdminDashboardViewState extends State<AdminDashboardView> {
  int _currentIndex = 0;

  final List<Widget> _tabs = [
    const AdminProductsView(),
    const AdminOrdersView(),
    const AdminUsersView(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Admin Dashboard'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // TODO: Implement admin logout
            },
          ),
        ],
      ),
      body: IndexedStack(
        index: _currentIndex,
        children: _tabs,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) => setState(() => _currentIndex = index),
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.shopping_bag),
            label: 'Products',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.list_alt),
            label: 'Orders',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people),
            label: 'Users',
          ),
        ],
      ),
    );
  }
}