import 'package:flutter/material.dart';
import '../models/product.dart';

// EXPERIMENT 5(b): State management using Provider (ChangeNotifier)
class CartItem {
  final Product product;
  final String size;
  final String color;
  int quantity;
  CartItem({required this.product, this.size = '', this.color = '', this.quantity = 1});

  String get key => '${product.id}|$size|$color';

  double get total => product.price * quantity;

  CartItem copy() => CartItem(product: product, size: size, color: color, quantity: quantity);
}

class DemoOrder {
  final String id;
  final DateTime createdAt;
  final List<CartItem> items;
  final String customerName;
  final String address;
  final String paymentMethod;
  final double deliveryCharge;
  final String deliveryInstructions;

  DemoOrder({
    required this.id,
    required this.createdAt,
    required this.items,
    required this.customerName,
    required this.address,
    required this.paymentMethod,
    required this.deliveryCharge,
    this.deliveryInstructions = '',
  });

  double get subtotal => items.fold(0, (sum, item) => sum + item.total);
  double get total => subtotal + deliveryCharge;
}

class CartProvider extends ChangeNotifier {
  final Map<String, CartItem> _items = {};
  final Set<String> _wishlist = {};
  final List<DemoOrder> _orders = [];
  String? userName;
  String? userEmail;

  Map<String, CartItem> get items => _items;
  Set<String> get wishlist => _wishlist;
  List<DemoOrder> get orders => List.unmodifiable(_orders);
  List<Product> get wishlistProducts => sampleProducts.where((product) => _wishlist.contains(product.id)).toList();

  int get itemCount => _items.values.fold(0, (sum, item) => sum + item.quantity);

  double get subtotal => _items.values.fold(0.0, (sum, item) => sum + item.total);
  double get totalPrice => subtotal;

  void addToCart(Product product, {String size = '', String color = '', int quantity = 1}) {
    final key = '${product.id}|$size|$color';
    if (_items.containsKey(key)) {
      _items[key]!.quantity += quantity;
    } else {
      _items[key] = CartItem(product: product, size: size, color: color, quantity: quantity);
    }
    notifyListeners();
  }

  void incrementQuantity(String itemKey) {
    if (_items.containsKey(itemKey)) {
      _items[itemKey]!.quantity++;
      notifyListeners();
    }
  }

  void decrementQuantity(String itemKey) {
    if (_items.containsKey(itemKey)) {
      if (_items[itemKey]!.quantity > 1) {
        _items[itemKey]!.quantity--;
      } else {
        _items.remove(itemKey);
      }
      notifyListeners();
    }
  }

  void removeItem(String itemKey) {
    _items.remove(itemKey);
    notifyListeners();
  }

  bool isWishlisted(Product product) => _wishlist.contains(product.id);

  void toggleWishlist(Product product) {
    if (!_wishlist.add(product.id)) _wishlist.remove(product.id);
    notifyListeners();
  }

  void login({required String name, required String email}) {
    userName = name;
    userEmail = email;
    notifyListeners();
  }

  void logout() {
    userName = null;
    userEmail = null;
    notifyListeners();
  }

  DemoOrder createOrder({
    required List<CartItem> orderedItems,
    required String customerName,
    required String address,
    required String paymentMethod,
    required double deliveryCharge,
    String deliveryInstructions = '',
    bool clearCart = true,
  }) {
    final now = DateTime.now();
    final order = DemoOrder(
      id: 'SM${now.millisecondsSinceEpoch}',
      createdAt: now,
      items: orderedItems.map((item) => item.copy()).toList(),
      customerName: customerName,
      address: address,
      paymentMethod: paymentMethod,
      deliveryCharge: deliveryCharge,
      deliveryInstructions: deliveryInstructions,
    );
    _orders.insert(0, order);
    if (clearCart) _items.clear();
    notifyListeners();
    return order;
  }

  void clearCart() {
    _items.clear();
    notifyListeners();
  }
}
