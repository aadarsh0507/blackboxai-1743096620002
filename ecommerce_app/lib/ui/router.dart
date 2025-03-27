import 'package:flutter/material.dart';
import 'package:ecommerce_app/ui/views/auth/login_view.dart';
import 'package:ecommerce_app/ui/views/auth/register_view.dart';
import 'package:ecommerce_app/ui/views/home_view.dart';
import 'package:ecommerce_app/ui/views/product/product_detail_view.dart';
import 'package:ecommerce_app/ui/views/cart/cart_view.dart';
import 'package:ecommerce_app/ui/views/checkout/checkout_view.dart';

class Router {
  static Route<dynamic> generateRoute(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => const HomeView());
      case '/login':
        return MaterialPageRoute(builder: (_) => const LoginView());
      case '/register':
        return MaterialPageRoute(builder: (_) => const RegisterView());
      case '/product':
        return MaterialPageRoute(
          builder: (_) => ProductDetailView(product: settings.arguments),
        );
      case '/cart':
        return MaterialPageRoute(builder: (_) => const CartView());
      case '/checkout':
        return MaterialPageRoute(builder: (_) => const CheckoutView());
      case '/profile':
        return MaterialPageRoute(builder: (_) => const ProfileView());
      case '/orders':
        return MaterialPageRoute(builder: (_) => const OrderHistoryView());
      case '/admin':
        return MaterialPageRoute(
          builder: (_) => FutureBuilder<bool>(
            future: Provider.of<AuthService>(_, listen: false).isAdmin(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                );
              }
              if (snapshot.data == true) {
                return const AdminDashboardView();
              }
              return const Scaffold(
                body: Center(child: Text('Unauthorized Access')),
              );
            },
          ),
        );
      default:
        return MaterialPageRoute(
          builder: (_) => Scaffold(
            body: Center(
              child: Text('No route defined for ${settings.name}'),
            ),
          ),
        );
    }
  }
}
