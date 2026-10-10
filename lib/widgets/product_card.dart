import 'package:flutter/material.dart';
import '../models/product.dart';
import '../theme/app_theme.dart';
import 'custom_widgets.dart';

class ProductCard extends StatefulWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAddToCart;
  final VoidCallback onBuyNow;
  final VoidCallback onWishlist;
  final bool isWishlisted;

  const ProductCard({super.key, required this.product, required this.onTap, required this.onAddToCart, required this.onBuyNow, required this.onWishlist, required this.isWishlisted});

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: AnimatedScale(
        scale: _hovered ? 1.025 : 1,
        duration: const Duration(milliseconds: 180),
        curve: Curves.easeOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 180),
          decoration: BoxDecoration(borderRadius: BorderRadius.circular(14), boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: _hovered ? .13 : .045), blurRadius: _hovered ? 18 : 8, offset: Offset(0, _hovered ? 8 : 3))]),
          child: Card(
            margin: EdgeInsets.zero,
            clipBehavior: Clip.antiAlias,
            child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
              Expanded(flex: 5, child: Stack(fit: StackFit.expand, children: [
                InkWell(onTap: widget.onTap, child: Hero(tag: product.id, child: ProductImage(product: product))),
                Positioned(left: 8, top: 8, child: Container(padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 4), decoration: BoxDecoration(color: Colors.white.withValues(alpha: .92), borderRadius: BorderRadius.circular(20)), child: Text(product.category, style: const TextStyle(fontSize: 9, fontWeight: FontWeight.w600)))),
                Positioned(right: 4, top: 2, child: IconButton(tooltip: widget.isWishlisted ? 'Remove from wishlist' : 'Add to wishlist', onPressed: widget.onWishlist, icon: Icon(widget.isWishlisted ? Icons.favorite : Icons.favorite_border, color: AppTheme.primary, size: 20))),
              ])),
              Expanded(flex: 5, child: Padding(
                padding: const EdgeInsets.fromLTRB(10, 7, 10, 8),
                child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
                  InkWell(onTap: widget.onTap, child: Text(product.name, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700))),
                  const SizedBox(height: 3),
                  Row(children: [
                    Text(product.formattedPrice, style: const TextStyle(color: AppTheme.primary, fontWeight: FontWeight.w800, fontSize: 13)),
                    if (product.originalPrice != null) ...[const SizedBox(width: 5), Text('₹${product.originalPrice!.toStringAsFixed(0)}', style: const TextStyle(fontSize: 10, color: Colors.black45, decoration: TextDecoration.lineThrough))],
                    const Spacer(), const Icon(Icons.star, color: Color(0xFFE5A63A), size: 14), Text(' ${product.rating}', style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600)),
                  ]),
                  const SizedBox(height: 3),
                  Text('Sizes ${product.sizes.join(', ')}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Colors.black54)),
                  Text('Colors ${product.colors.join(', ')}', maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(fontSize: 10, color: Colors.black54)),
                  const Spacer(),
                  Row(children: [
                    Expanded(child: SizedBox(height: 31, child: OutlinedButton(onPressed: widget.onAddToCart, style: OutlinedButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact), child: const Text('Add to cart', style: TextStyle(fontSize: 10))))),
                    const SizedBox(width: 6),
                    Expanded(child: SizedBox(height: 31, child: FilledButton(onPressed: widget.onBuyNow, style: FilledButton.styleFrom(padding: EdgeInsets.zero, visualDensity: VisualDensity.compact), child: const Text('Buy now', style: TextStyle(fontSize: 10))))),
                  ]),
                ]),
              )),
            ]),
          ),
        ),
      ),
    );
  }
}