import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../widgets/custom_widgets.dart';
import '../theme/app_theme.dart';

// EXPERIMENT 5(a): StatefulWidget using setState for local UI state (quantity).
// EXPERIMENT 8: Hero continuation + fade-in animation for description.
class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen>
    with SingleTickerProviderStateMixin {
  int _quantity = 1;
  String? _size;
  String? _color;

  late final AnimationController _fadeController = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 500),
  )..forward();
  late final Animation<double> _fade =
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn);

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void _increment() => setState(() {
        if (_quantity < widget.product.stock) _quantity++;
      });
  void _decrement() => setState(() {
        if (_quantity > 1) _quantity--;
      });

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    final width = MediaQuery.sizeOf(context).width;
    final cart = context.watch<CartProvider>();

    void showSelectionError() {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Choose a size and color before continuing.')));
    }

    bool hasSelection() {
      if (product.sizes.isNotEmpty && _size == null ||
          product.colors.isNotEmpty && _color == null) {
        showSelectionError();
        return false;
      }
      return true;
    }

    return Scaffold(
      appBar: AppBar(title: Text(product.name)),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1100),
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Flex(
              direction: width > 760 ? Axis.horizontal : Axis.vertical,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ExpandedIfWide(
                    isWide: width > 760,
                    child: AspectRatio(
                      aspectRatio: width > 760 ? .82 : 1.05,
                      child: ClipRRect(
                          borderRadius: BorderRadius.circular(18),
                          child: Hero(
                              tag: product.id,
                              child: ProductImage(product: product))),
                    )),
                if (width > 760)
                  const SizedBox(width: 32)
                else
                  const SizedBox(height: 22),
                ExpandedIfWide(
                    isWide: width > 760,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                                color: AppTheme.lavender,
                                borderRadius: BorderRadius.circular(30)),
                            child: Text(
                                '${product.audience} · ${product.category}',
                                style: const TextStyle(
                                    color: AppTheme.primary,
                                    fontWeight: FontWeight.w600))),
                        const SizedBox(height: 12),
                        FadeTransition(
                          opacity: _fade,
                          child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(product.name,
                                    style: const TextStyle(
                                        fontSize: 26,
                                        fontWeight: FontWeight.bold)),
                                const SizedBox(height: 8),
                                Row(children: [
                                  const Icon(Icons.star,
                                      color: Color(0xFFE5A63A), size: 18),
                                  Text(' ${product.rating} · Demo rating',
                                      style: const TextStyle(
                                          color: Colors.black54))
                                ]),
                                const SizedBox(height: 8),
                                Row(children: [
                                  Text(product.formattedPrice,
                                      style: const TextStyle(
                                          fontSize: 22,
                                          color: AppTheme.primary,
                                          fontWeight: FontWeight.bold)),
                                  if (product.originalPrice != null) ...[
                                    const SizedBox(width: 10),
                                    Text(
                                        '₹${product.originalPrice!.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                            color: Colors.black45,
                                            decoration:
                                                TextDecoration.lineThrough))
                                  ],
                                ]),
                                const SizedBox(height: 14),
                                Text(product.description,
                                    style: const TextStyle(
                                        fontSize: 15,
                                        height: 1.5,
                                        color: Colors.black87)),
                              ]),
                        ),
                        const SizedBox(height: 18),
                        Text(
                            'Size${_size == null ? ' · Required' : ' · $_size'}',
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Wrap(
                            spacing: 8,
                            children: product.sizes
                                .map((size) => ChoiceChip(
                                    label: Text(size),
                                    selected: _size == size,
                                    onSelected: (_) =>
                                        setState(() => _size = size)))
                                .toList()),
                        const SizedBox(height: 16),
                        Text(
                            'Color${_color == null ? ' · Required' : ' · $_color'}',
                            style:
                                const TextStyle(fontWeight: FontWeight.w700)),
                        const SizedBox(height: 8),
                        Wrap(
                            spacing: 8,
                            children: product.colors
                                .map((color) => ChoiceChip(
                                    label: Text(color),
                                    selected: _color == color,
                                    onSelected: (_) =>
                                        setState(() => _color = color)))
                                .toList()),
                        const SizedBox(height: 16),
                        Text('${product.stock} pieces available',
                            style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.w600)),
                        Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              IconButton(
                                  onPressed: _decrement,
                                  icon:
                                      const Icon(Icons.remove_circle_outline)),
                              Text('$_quantity',
                                  style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600)),
                              IconButton(
                                  onPressed: _increment,
                                  icon: const Icon(Icons.add_circle_outline)),
                            ]),
                        const SizedBox(height: 8),
                        FilledButton.icon(
                          onPressed: () {
                            if (!hasSelection()) return;
                            cart.addToCart(product,
                                size: _size!,
                                color: _color!,
                                quantity: _quantity);
                            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                                content:
                                    Text('${product.name} added to your bag')));
                          },
                          icon: const Icon(Icons.shopping_bag_outlined),
                          label: const Text('Add to cart'),
                          style: FilledButton.styleFrom(
                              minimumSize: const Size.fromHeight(48)),
                        ),
                        const SizedBox(height: 10),
                        OutlinedButton.icon(
                          onPressed: () {
                            if (!hasSelection()) return;
                            Navigator.pushNamed(context, '/checkout',
                                arguments: CartItem(
                                    product: product,
                                    size: _size!,
                                    color: _color!,
                                    quantity: _quantity));
                          },
                          icon: const Icon(Icons.bolt_outlined),
                          label: const Text('Buy now'),
                          style: OutlinedButton.styleFrom(
                              minimumSize: const Size.fromHeight(48)),
                        ),
                      ],
                    )),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class ExpandedIfWide extends StatelessWidget {
  final bool isWide;
  final Widget child;
  const ExpandedIfWide({super.key, required this.isWide, required this.child});

  @override
  Widget build(BuildContext context) => isWide ? Expanded(child: child) : child;
}
