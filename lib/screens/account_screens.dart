import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/custom_widgets.dart';

class WishlistScreen extends StatelessWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final products = context.watch<CartProvider>().wishlistProducts;
    return Scaffold(
      appBar: AppBar(title: const Text('Wishlist')),
      body: products.isEmpty
          ? const Center(child: Text('Your wishlist is waiting for a little love.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: products.length,
              itemBuilder: (context, index) => _WishlistTile(product: products[index]),
            ),
    );
  }
}

class _WishlistTile extends StatelessWidget {
  final Product product;
  const _WishlistTile({required this.product});

  @override
  Widget build(BuildContext context) => Card(
        margin: const EdgeInsets.only(bottom: 12),
        clipBehavior: Clip.antiAlias,
        child: ListTile(
          contentPadding: const EdgeInsets.all(8),
          leading: SizedBox(width: 58, height: 72, child: ProductImage(product: product)),
          title: Text(product.name),
          subtitle: Text(product.formattedPrice),
          onTap: () => Navigator.pushNamed(context, '/detail', arguments: product),
          trailing: IconButton(tooltip: 'Remove from wishlist', icon: const Icon(Icons.favorite, color: Colors.pink), onPressed: () => context.read<CartProvider>().toggleWishlist(product)),
        ),
      );
}

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    return Scaffold(
      appBar: AppBar(title: const Text('Your profile')),
      body: ListView(padding: const EdgeInsets.all(20), children: [
        const CircleAvatar(radius: 36, child: Icon(Icons.person_outline, size: 38)),
        const SizedBox(height: 12),
        Text(cart.userName ?? 'Fashion Lover', textAlign: TextAlign.center, style: Theme.of(context).textTheme.titleLarge),
        Text(cart.userEmail ?? '', textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
        const SizedBox(height: 24),
        ListTile(leading: const Icon(Icons.receipt_long_outlined), title: const Text('Order history'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.pushNamed(context, '/orders')),
        ListTile(leading: const Icon(Icons.favorite_border), title: const Text('Wishlist'), trailing: const Icon(Icons.chevron_right), onTap: () => Navigator.pushNamed(context, '/wishlist')),
        const Divider(),
        ListTile(leading: const Icon(Icons.logout, color: Colors.redAccent), title: const Text('Logout'), onTap: () {
          context.read<CartProvider>().logout();
          Navigator.pushNamedAndRemoveUntil(context, '/login', (route) => false);
        }),
        const Padding(padding: EdgeInsets.only(top: 18), child: Text('Demo profile · Shopping Mart does not connect to an account service.', textAlign: TextAlign.center, style: TextStyle(color: Colors.black54, fontSize: 12))),
      ]),
    );
  }
}

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final orders = context.watch<CartProvider>().orders;
    return Scaffold(
      appBar: AppBar(title: const Text('Order history')),
      body: orders.isEmpty
          ? const Center(child: Text('Your demo orders will appear here.'))
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return Card(child: ListTile(
                  leading: const Icon(Icons.local_mall_outlined),
                  title: Text('Order ${order.id}'),
                  subtitle: Text('${order.items.length} styles · ${order.createdAt.toLocal().toString().split('.').first}'),
                  trailing: Text('₹${order.total.toStringAsFixed(0)}'),
                  onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => OrderConfirmationScreen(order: order, fromHistory: true))),
                ));
              },
            ),
    );
  }
}

class OrderConfirmationScreen extends StatelessWidget {
  final DemoOrder order;
  final bool fromHistory;
  const OrderConfirmationScreen({super.key, required this.order, this.fromHistory = false});

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: Text(fromHistory ? 'Order details' : 'Order confirmed')),
        body: ListView(padding: const EdgeInsets.all(20), children: [
          if (!fromHistory) const Icon(Icons.check_circle_outline, size: 64, color: Colors.green),
          Text(fromHistory ? 'Order ${order.id}' : 'Thank you, ${order.customerName}!', textAlign: TextAlign.center, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 8),
          Text('Demo order ID: ${order.id}', textAlign: TextAlign.center),
          const SizedBox(height: 20),
          for (final item in order.items) ListTile(
            leading: SizedBox(width: 48, child: ProductImage(product: item.product)),
            title: Text(item.product.name),
            subtitle: Text('${item.size} · ${item.color} · Qty ${item.quantity}'),
            trailing: Text('₹${item.total.toStringAsFixed(0)}'),
          ),
          const Divider(),
          ListTile(title: const Text('Payment'), trailing: Text(order.paymentMethod)),
          ListTile(title: const Text('Delivery address'), subtitle: Text(order.address)),
          if (order.deliveryInstructions.isNotEmpty) ListTile(title: const Text('Delivery instructions'), subtitle: Text(order.deliveryInstructions)),
          ListTile(title: const Text('Subtotal'), trailing: Text('₹${order.subtotal.toStringAsFixed(0)}')),
          ListTile(title: const Text('Delivery'), trailing: Text(order.deliveryCharge == 0 ? 'Free' : '₹${order.deliveryCharge.toStringAsFixed(0)}')),
          ListTile(title: const Text('Total paid'), trailing: Text('₹${order.total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.bold))),
          const SizedBox(height: 18),
          FilledButton(onPressed: () => Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false), child: const Text('Continue shopping')),
        ]),
      );
}