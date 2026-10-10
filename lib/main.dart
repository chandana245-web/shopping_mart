import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/product.dart';
import 'providers/cart_provider.dart';
import 'theme/app_theme.dart';
import 'screens/home_screen.dart';
import 'screens/product_detail_screen.dart';
import 'screens/cart_screen.dart';
import 'screens/checkout_screen.dart';
import 'screens/auth_screen.dart';
import 'screens/account_screens.dart';

void main() {
  runApp(const ShoppingMartApp());
}

class ShoppingMartApp extends StatelessWidget {
  const ShoppingMartApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => CartProvider(),
      child: MaterialApp(
        title: 'Shopping Mart',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.theme, // EXPERIMENT 6(b)
        initialRoute: '/login',
        routes: {
          '/': (context) => const HomeScreen(),
          '/login': (context) => const AuthScreen(),
          '/wishlist': (context) => const WishlistScreen(),
          '/profile': (context) => const ProfileScreen(),
          '/orders': (context) => const OrderHistoryScreen(),
          '/cart': (context) => const CartScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/checkout') {
            final argument = settings.arguments;
            return MaterialPageRoute(builder: (context) => CheckoutScreen(buyNowItem: argument is CartItem ? argument : null));
          }
          if (settings.name == '/detail') {
            final arguments = settings.arguments;
            if (arguments is! Product) return null;
            return MaterialPageRoute(
              builder: (context) => ProductDetailScreen(product: arguments),
            );
          }
          if (settings.name == '/confirmation' && settings.arguments is DemoOrder) {
            final order = settings.arguments as DemoOrder;
            return MaterialPageRoute(builder: (context) => OrderConfirmationScreen(order: order));
          }
          return null;
        },
      ),
    );
  }
}
