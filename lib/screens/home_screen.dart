import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/product.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';
import '../widgets/product_card.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  String _category = 'All';
  String _audience = 'All';
  String _sort = 'Featured';
  String _collection = 'Trending';
  int _navigationIndex = 0;

  static const _audiences = ['All', 'Girls', 'Kids', 'Women'];
  static const _categories = [
    'All',
    'Dresses',
    'Party Wear',
    'Tops and Bottoms',
    'Co-ord Sets',
    'Ethnic Wear',
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<Product> _filteredProducts() {
    final query = _searchController.text.trim().toLowerCase();
    final products = sampleProducts.where((product) {
      final matchesCategory =
          _category == 'All' || product.category == _category;
      final matchesAudience =
          _audience == 'All' || product.audience == _audience;
      final matchesQuery = query.isEmpty ||
          '${product.name} ${product.category} ${product.audience}'
              .toLowerCase()
              .contains(query);
      final collectionIds = switch (_collection) {
        'New arrivals' => {
            'p7',
            'p8',
            'p9',
            'p10',
            'p12',
            'p13',
            'p14',
            'p15',
            'p16'
          },
        'Best sellers' => {'p1', 'p5', 'p11', 'p14'},
        _ => {'p1', 'p2', 'p6', 'p7', 'p11', 'p12'},
      };
      final matchesCollection =
          _category == 'All' &&
                  _audience == 'All' &&
                  query.isEmpty
              ? collectionIds.contains(product.id)
              : true;
      return matchesCategory &&
          matchesAudience &&
          matchesQuery &&
          matchesCollection;
    }).toList();
    if (_sort == 'Price: low to high') {
      products.sort((a, b) => a.price.compareTo(b.price));
    } else if (_sort == 'Price: high to low') {
      products.sort((a, b) => b.price.compareTo(a.price));
    } else if (_sort == 'Top rated') {
      products.sort((a, b) => b.rating.compareTo(a.rating));
    }
    return products;
  }

  void _selectNavigation(int index) {
    setState(() => _navigationIndex = index);
    if (index == 1) {
      showModalBottomSheet<void>(
          context: context,
          builder: (context) => SafeArea(
                  child: ListView(shrinkWrap: true, children: [
                const ListTile(
                    title: Text('Shop by category',
                        style: TextStyle(fontWeight: FontWeight.w800))),
                for (final category in _categories)
                  ListTile(
                      title: Text(category),
                      trailing: _category == category
                          ? const Icon(Icons.check, color: AppTheme.primary)
                          : null,
                      onTap: () {
                        setState(() => _category = category);
                        Navigator.pop(context);
                      }),
              ])));
    } else if (index == 2) {
      Navigator.pushNamed(context, '/wishlist')
          .then((_) => setState(() => _navigationIndex = 0));
    } else if (index == 3) {
      Navigator.pushNamed(context, '/cart')
          .then((_) => setState(() => _navigationIndex = 0));
    } else if (index == 4) {
      Navigator.pushNamed(context, '/profile')
          .then((_) => setState(() => _navigationIndex = 0));
    }
  }

  Future<void> _addWithVariant(Product product) async {
    String? selectedSize;
    String? selectedColor;
    final selected = await showModalBottomSheet<CartItem>(
      context: context,
      isScrollControlled: true,
      builder: (sheetContext) => StatefulBuilder(
          builder: (context, setSheetState) => SafeArea(
                child: Padding(
                    padding: const EdgeInsets.fromLTRB(22, 20, 22, 24),
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product.name,
                              style: const TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w800)),
                          const SizedBox(height: 14),
                          const Text('Choose a size',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          Wrap(
                              spacing: 8,
                              children: product.sizes
                                  .map((size) => ChoiceChip(
                                      label: Text(size),
                                      selected: selectedSize == size,
                                      onSelected: (_) => setSheetState(
                                          () => selectedSize = size)))
                                  .toList()),
                          const SizedBox(height: 14),
                          const Text('Choose a color',
                              style: TextStyle(fontWeight: FontWeight.w700)),
                          const SizedBox(height: 8),
                          Wrap(
                              spacing: 8,
                              children: product.colors
                                  .map((color) => ChoiceChip(
                                      label: Text(color),
                                      selected: selectedColor == color,
                                      onSelected: (_) => setSheetState(
                                          () => selectedColor = color)))
                                  .toList()),
                          const SizedBox(height: 18),
                          SizedBox(
                              width: double.infinity,
                              child: FilledButton.icon(
                                onPressed: selectedSize == null ||
                                        selectedColor == null
                                    ? null
                                    : () => Navigator.pop(
                                        sheetContext,
                                        CartItem(
                                            product: product,
                                            size: selectedSize!,
                                            color: selectedColor!)),
                                icon: const Icon(Icons.shopping_bag_outlined),
                                label: const Text('Add selected style to bag'),
                              )),
                        ])),
              )),
    );
    if (selected == null || !mounted) return;
    context.read<CartProvider>().addToCart(selected.product,
        size: selected.size, color: selected.color);
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(
            '${product.name} added · ${selected.size}, ${selected.color}')));
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final products = _filteredProducts();
    final width = MediaQuery.sizeOf(context).width;
    final columns = width < 620
        ? 2
        : width < 980
            ? 3
            : width < 1300
                ? 4
                : 5;
    return Scaffold(
      appBar: AppBar(
        title: const Row(mainAxisSize: MainAxisSize.min, children: [
          Icon(Icons.shopping_bag_outlined, color: AppTheme.primary),
          SizedBox(width: 8),
          Text('Shopping Mart', style: TextStyle(fontWeight: FontWeight.w800))
        ]),
        actions: [
          IconButton(
              tooltip: 'Wishlist',
              onPressed: () => Navigator.pushNamed(context, '/wishlist'),
              icon: const Icon(Icons.favorite_border)),
          _CartAction(
              count: cart.itemCount,
              onPressed: () => Navigator.pushNamed(context, '/cart')),
          IconButton(
              tooltip: 'Profile',
              onPressed: () => Navigator.pushNamed(context, '/profile'),
              icon: const Icon(Icons.account_circle_outlined)),
          const SizedBox(width: 8),
        ],
      ),
      body: CustomScrollView(slivers: [
        SliverToBoxAdapter(
            child: Padding(
          padding: EdgeInsets.fromLTRB(
              width < 600 ? 16 : 32, 18, width < 600 ? 16 : 32, 0),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text('A little more you.',
                style: Theme.of(context)
                    .textTheme
                    .headlineMedium
                    ?.copyWith(fontWeight: FontWeight.w800)),
            const SizedBox(height: 4),
            const Text('Styles for every age and occasion.',
                style: TextStyle(color: Colors.black54)),
            const SizedBox(height: 18),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: const Color(0xFFF4E9F6),
                  image: const DecorationImage(
                      image: NetworkImage(
                          'https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=1500&q=85'),
                      fit: BoxFit.cover,
                      opacity: .24)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('GIRLS, KIDS & WOMEN',
                        style: TextStyle(
                            letterSpacing: 1.4,
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: AppTheme.primary)),
                    const SizedBox(height: 7),
                    const Text('A style for\nevery story.',
                        style: TextStyle(
                            fontSize: 26,
                            height: 1.1,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 10),
                    FilledButton(
                        onPressed: () => setState(() {
                              _audience = 'Girls';
                              _category = 'All';
                            }),
                        child: const Text('Shop girls styles')),
                  ]),
            ),
            const SizedBox(height: 20),
            TextField(
                controller: _searchController,
                onChanged: (_) => setState(() {}),
                decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.search),
                    hintText: 'Search girls, kids, women styles...',
                    suffixIcon: _searchController.text.isEmpty
                        ? null
                        : IconButton(
                            onPressed: () {
                              _searchController.clear();
                              setState(() {});
                            },
                            icon: const Icon(Icons.close)))),
            const SizedBox(height: 16),
            const Text('Shop for',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
            const SizedBox(height: 9),
            SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _audiences.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final audience = _audiences[index];
                    return ChoiceChip(
                        label: Text(audience),
                        selected: _audience == audience,
                        onSelected: (_) =>
                            setState(() => _audience = audience));
                  },
                )),
            const SizedBox(height: 14),
            const Text('Shop by style',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 17)),
            const SizedBox(height: 9),
            SizedBox(
                height: 38,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: _categories.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final category = _categories[index];
                    return ChoiceChip(
                        label: Text(category),
                        selected: _category == category,
                        onSelected: (_) =>
                            setState(() => _category = category));
                  },
                )),
            const SizedBox(height: 18),
            Wrap(
                spacing: 8,
                children: ['Trending', 'New arrivals', 'Best sellers']
                    .map((collection) => ChoiceChip(
                        label: Text(collection),
                        selected: _collection == collection,
                        onSelected: (_) =>
                            setState(() => _collection = collection)))
                    .toList()),
            const SizedBox(height: 14),
            Row(children: [
              Expanded(
                  child: Text(
                      _searchController.text.isNotEmpty
                          ? 'Search results'
                          : _category != 'All'
                              ? _category
                              : _audience != 'All'
                                  ? '$_audience styles'
                                  : _collection,
                      style: const TextStyle(
                          fontWeight: FontWeight.w800, fontSize: 20))),
              DropdownButton<String>(
                  value: _sort,
                  underline: const SizedBox.shrink(),
                  items: const [
                    'Featured',
                    'Price: low to high',
                    'Price: high to low',
                    'Top rated'
                  ]
                      .map((sort) => DropdownMenuItem(
                          value: sort,
                          child:
                              Text(sort, style: const TextStyle(fontSize: 12))))
                      .toList(),
                  onChanged: (value) =>
                      setState(() => _sort = value ?? 'Featured')),
            ]),
            const SizedBox(height: 8),
          ]),
        )),
        if (products.isEmpty)
          const SliverFillRemaining(
              hasScrollBody: false,
              child: Center(
                  child:
                      Text('No styles match that search. Try another term.')))
        else
          SliverPadding(
            padding: EdgeInsets.fromLTRB(
                width < 600 ? 12 : 32, 0, width < 600 ? 12 : 32, 24),
            sliver: SliverGrid(
              delegate: SliverChildBuilderDelegate((context, index) {
                final product = products[index];
                return ProductCard(
                  product: product,
                  isWishlisted: cart.isWishlisted(product),
                  onTap: () => Navigator.pushNamed(context, '/detail',
                      arguments: product),
                  onWishlist: () =>
                      context.read<CartProvider>().toggleWishlist(product),
                  onAddToCart: () => _addWithVariant(product),
                  onBuyNow: () => Navigator.pushNamed(context, '/detail',
                      arguments: product),
                );
              }, childCount: products.length),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: columns,
                  crossAxisSpacing: 12,
                  mainAxisSpacing: 14,
                  mainAxisExtent: width < 600 ? 380 : 405),
            ),
          ),
      ]),
      bottomNavigationBar: width < 760
          ? NavigationBar(
              selectedIndex: _navigationIndex,
              onDestinationSelected: _selectNavigation,
              destinations: const [
                  NavigationDestination(
                      icon: Icon(Icons.home_outlined),
                      selectedIcon: Icon(Icons.home),
                      label: 'Home'),
                  NavigationDestination(
                      icon: Icon(Icons.category_outlined), label: 'Categories'),
                  NavigationDestination(
                      icon: Icon(Icons.favorite_border), label: 'Wishlist'),
                  NavigationDestination(
                      icon: Icon(Icons.shopping_bag_outlined), label: 'Cart'),
                  NavigationDestination(
                      icon: Icon(Icons.person_outline), label: 'Profile'),
                ])
          : null,
    );
  }
}

class _CartAction extends StatelessWidget {
  final int count;
  final VoidCallback onPressed;
  const _CartAction({required this.count, required this.onPressed});

  @override
  Widget build(BuildContext context) =>
      Stack(alignment: Alignment.center, children: [
        IconButton(
            tooltip: 'Shopping cart',
            onPressed: onPressed,
            icon: const Icon(Icons.shopping_bag_outlined)),
        if (count > 0)
          Positioned(
              right: 4,
              top: 4,
              child: Container(
                  padding: const EdgeInsets.all(4),
                  decoration: const BoxDecoration(
                      color: AppTheme.primary, shape: BoxShape.circle),
                  child: Text('$count',
                      style:
                          const TextStyle(color: Colors.white, fontSize: 9)))),
      ]);
}
