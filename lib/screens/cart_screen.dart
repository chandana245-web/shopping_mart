import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/custom_widgets.dart';
import '../theme/app_theme.dart';

// EXPERIMENT 5(b): Reading/mutating shared Provider state from another screen.
// EXPERIMENT 8: AnimatedSize / implicit animation when items are removed.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final items = cart.items.values.toList();

    final delivery = cart.subtotal >= 2500 ? 0.0 : 99.0;
    return Scaffold(
      appBar: AppBar(title: const Text('Your bag')),
      body: items.isEmpty
          ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [
              const Icon(Icons.shopping_bag_outlined, size: 64, color: AppTheme.primary),
              const SizedBox(height: 12),
              const Text('Your bag is taking a breather.', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
              const SizedBox(height: 12),
              OutlinedButton.icon(onPressed: () => Navigator.popUntil(context, ModalRoute.withName('/')), icon: const Icon(Icons.arrow_back), label: const Text('Continue shopping')),
            ]))
          : Column(children: [
              Expanded(child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  return AnimatedSize(
                    duration: const Duration(milliseconds: 250),
                    child: Card(margin: const EdgeInsets.only(bottom: 12), clipBehavior: Clip.antiAlias, child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                        SizedBox(width: 86, height: 112, child: ClipRRect(borderRadius: BorderRadius.circular(8), child: ProductImage(product: item.product))),
                        const SizedBox(width: 12),
                        Expanded(child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                          Text(item.product.name, maxLines: 2, overflow: TextOverflow.ellipsis, style: const TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 4),
                          Text('Size ${item.size} · ${item.color}', style: const TextStyle(color: Colors.black54, fontSize: 12)),
                          const SizedBox(height: 5),
                          Text(item.product.formattedPrice, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w700)),
                          Row(children: [
                            IconButton(visualDensity: VisualDensity.compact, onPressed: () => context.read<CartProvider>().decrementQuantity(item.key), icon: const Icon(Icons.remove_circle_outline)),
                            Text('${item.quantity}'),
                            IconButton(visualDensity: VisualDensity.compact, onPressed: () => context.read<CartProvider>().incrementQuantity(item.key), icon: const Icon(Icons.add_circle_outline)),
                            const Spacer(),
                            Text('₹${item.total.toStringAsFixed(0)}', style: const TextStyle(fontWeight: FontWeight.w700)),
                            IconButton(tooltip: 'Remove item', visualDensity: VisualDensity.compact, onPressed: () => context.read<CartProvider>().removeItem(item.key), icon: const Icon(Icons.delete_outline, color: Colors.redAccent)),
                          ]),
                        ])),
                      ]),
                    )),
                  );
                },
              )),
              SafeArea(top: false, child: Padding(padding: const EdgeInsets.all(18), child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                _SummaryRow(label: 'Subtotal', value: '₹${cart.subtotal.toStringAsFixed(0)}'),
                _SummaryRow(label: 'Delivery', value: delivery == 0 ? 'Free' : '₹${delivery.toStringAsFixed(0)}'),
                const Divider(),
                _SummaryRow(label: 'Total', value: '₹${(cart.subtotal + delivery).toStringAsFixed(0)}', bold: true),
                const SizedBox(height: 12),
                FilledButton.icon(onPressed: () => Navigator.pushNamed(context, '/checkout'), icon: const Icon(Icons.lock_outline), label: const Text('Proceed to checkout'), style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(48))),
              ]))),
            ]),
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;
  const _SummaryRow({required this.label, required this.value, this.bold = false});

  @override
  Widget build(BuildContext context) => Padding(padding: const EdgeInsets.symmetric(vertical: 4), child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w700 : FontWeight.normal, fontSize: bold ? 17 : 14)), Text(value, style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w600, fontSize: bold ? 17 : 14))]));
}
