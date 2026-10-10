class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final String category;
  final List<String> sizes;
  final List<String> colors;
  final double rating;
  final double? originalPrice;
  final int stock;

  const Product({
    required this.id,
    required this.name,
    required this.price,
    required this.imageUrl,
    required this.description,
    required this.category,
    required this.sizes,
    required this.colors,
    required this.rating,
    this.originalPrice,
    this.stock = 12,
  });

  String get formattedPrice => '₹${price.toStringAsFixed(0)}';
  String get emoji => '👗';
}

final List<Product> sampleProducts = [
  const Product(
    id: 'p1',
    name: 'Rose Garden Midi Dress', price: 1899, originalPrice: 2499,
    imageUrl: 'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=900&q=85', category: 'Western Dresses', rating: 4.8,
    sizes: ['XS', 'S', 'M', 'L', 'XL'], colors: ['Rose', 'Ivory', 'Sage'],
    description: 'A breezy floral midi dress with a flattering waist and soft, breathable fabric. Made for sunny plans and slow weekends.',
  ),
  const Product(
    id: 'p2',
    name: 'Lavender Evening Maxi', price: 3290, originalPrice: 3990,
    imageUrl: 'https://images.unsplash.com/photo-1539008835657-9e8e9680c956?auto=format&fit=crop&w=900&q=85', category: 'Maxi Dresses', rating: 4.7,
    sizes: ['S', 'M', 'L', 'XL'], colors: ['Lavender', 'Black'],
    description: 'A graceful full-length silhouette with a fluid drape and subtle gathered detailing for celebrations after dark.',
  ),
  const Product(
    id: 'p3',
    name: 'Midnight Satin Party Dress', price: 2499,
    imageUrl: 'https://images.unsplash.com/photo-1566174053879-31528523f8ae?auto=format&fit=crop&w=900&q=85', category: 'Party Wear', rating: 4.6,
    sizes: ['XS', 'S', 'M', 'L'], colors: ['Black', 'Wine'],
    description: 'A polished satin party dress with a clean neckline and a comfortable lining. An easy favourite for special evenings.',
  ),
  const Product(
    id: 'p4',
    name: 'Everyday Cotton Sundress', price: 1299, originalPrice: 1699,
    imageUrl: 'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?auto=format&fit=crop&w=900&q=85', category: 'Casual Dresses', rating: 4.5,
    sizes: ['S', 'M', 'L', 'XL', 'XXL'], colors: ['Blue', 'White', 'Yellow'],
    description: 'Lightweight cotton, easy movement, and a cheerful print make this an everyday warm-weather staple.',
  ),
  const Product(
    id: 'p5',
    name: 'Mehendi Anarkali Set', price: 2799,
    imageUrl: 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?auto=format&fit=crop&w=900&q=85', category: 'Traditional and Ethnic Wear', rating: 4.8,
    sizes: ['S', 'M', 'L', 'XL'], colors: ['Green', 'Pink'],
    description: 'An elegant printed Anarkali set with delicate detailing and a soft lining, designed for festive gatherings.',
  ),
  const Product(
    id: 'p6',
    name: 'Petal Print Everyday Kurti', price: 999, originalPrice: 1399,
    imageUrl: 'https://images.unsplash.com/photo-1583391733956-6c78276477e7?auto=format&fit=crop&w=900&q=85', category: 'Kurtis', rating: 4.4,
    sizes: ['S', 'M', 'L', 'XL', 'XXL'], colors: ['Pink', 'Teal', 'White'],
    description: 'A soft straight-cut kurti with an all-over floral print and side slits for comfortable all-day wear.',
  ),
  const Product(
    id: 'p7', name: 'Sunday Brunch Linen Shirt', price: 1190,
    imageUrl: 'https://images.unsplash.com/photo-1598554747436-c9293d6a588f?auto=format&fit=crop&w=900&q=85', category: 'Tops and Shirts', rating: 4.3,
    sizes: ['XS', 'S', 'M', 'L', 'XL'], colors: ['White', 'Lilac', 'Coral'],
    description: 'Relaxed-fit linen blend shirt with a crisp collar and easy roll-tab sleeves. Wear tucked or loose.',
  ),
  const Product(
    id: 'p8', name: 'Pleated Daydream Skirt', price: 1499,
    imageUrl: 'https://images.unsplash.com/photo-1583496661160-fb5886a0aaaa?auto=format&fit=crop&w=900&q=85', category: 'Skirts', rating: 4.5,
    sizes: ['XS', 'S', 'M', 'L'], colors: ['Lilac', 'Black', 'Cream'],
    description: 'A floaty pleated skirt with a comfortable waistband and a swish-worthy midi length.',
  ),
  const Product(
    id: 'p9', name: 'Soft Focus Co-ord Set', price: 2199, originalPrice: 2899,
    imageUrl: 'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?auto=format&fit=crop&w=900&q=85', category: 'Co-ord Sets', rating: 4.7,
    sizes: ['S', 'M', 'L', 'XL'], colors: ['Blush', 'Sage', 'Blue'],
    description: 'A matching top and wide-leg trouser set in a soft drapey fabric. Two pieces, plenty of outfit possibilities.',
  ),
  const Product(
    id: 'p10', name: 'Little Bloom Tiered Frock', price: 1599,
    imageUrl: 'https://images.unsplash.com/photo-1503944583220-79d8926ad5e2?auto=format&fit=crop&w=900&q=85', category: 'Frocks', rating: 4.6,
    sizes: ['XS', 'S', 'M', 'L'], colors: ['Pink', 'Yellow', 'Blue'],
    description: 'A playful tiered frock with delicate puff sleeves and a lightweight cotton feel for little celebrations.',
  ),
  const Product(
    id: 'p11', name: 'Starlight Occasion Gown', price: 4299,
    imageUrl: 'https://images.unsplash.com/photo-1566174053879-31528523f8ae?auto=format&fit=crop&w=900&q=85', category: 'Gowns', rating: 4.9,
    sizes: ['S', 'M', 'L', 'XL'], colors: ['Rose', 'Navy'],
    description: 'A flowing occasion gown with a softly structured bodice and an elegant full skirt for memorable moments.',
  ),
  const Product(
    id: 'p12', name: 'Weekend High-Rise Jeans', price: 1799, originalPrice: 2299,
    imageUrl: 'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?auto=format&fit=crop&w=900&q=85', category: 'Jeans and Trousers', rating: 4.5,
    sizes: ['26', '28', '30', '32', '34'], colors: ['Indigo', 'Light Blue', 'Black'],
    description: 'Comfort-stretch high-rise denim with a straight leg and classic five-pocket styling for everyday outfits.',
  ),
  const Product(
    id: 'p13', name: 'Phulkari Punjabi Suit Set', price: 2499, originalPrice: 3199,
    imageUrl: 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?auto=format&fit=crop&w=900&q=85', category: 'Traditional and Ethnic Wear', rating: 4.8,
    sizes: ['S', 'M', 'L', 'XL', 'XXL'], colors: ['Fuchsia', 'Mustard', 'Teal'],
    description: 'A vibrant Punjabi salwar suit with Phulkari-inspired floral detailing, a soft kurta, matching bottoms, and a light dupatta.',
  ),
  const Product(
    id: 'p14', name: 'Gulabi Lehenga Choli', price: 4699, originalPrice: 5999,
    imageUrl: 'https://images.unsplash.com/photo-1617627143750-d86bc21e42bb?auto=format&fit=crop&w=900&q=85', category: 'Traditional and Ethnic Wear', rating: 4.9,
    sizes: ['S', 'M', 'L', 'XL'], colors: ['Rose Pink', 'Maroon', 'Emerald'],
    description: 'A festive three-piece lehenga choli with a flared skirt, coordinating blouse, and dupatta for wedding celebrations.',
  ),
  const Product(
    id: 'p15', name: 'Festive Mirrorwork Sharara', price: 3299,
    imageUrl: 'https://images.unsplash.com/photo-1583391733956-6c78276477e7?auto=format&fit=crop&w=900&q=85', category: 'Traditional and Ethnic Wear', rating: 4.7,
    sizes: ['S', 'M', 'L', 'XL'], colors: ['Lilac', 'Coral', 'Navy'],
    description: 'A graceful sharara suit with a detailed festive kurta, flowy wide-leg sharara trousers, and matching dupatta.',
  ),
  const Product(
    id: 'p16', name: 'Patiala Suit with Dupatta', price: 1899, originalPrice: 2399,
    imageUrl: 'https://images.unsplash.com/photo-1610030469983-98e550d6193c?auto=format&fit=crop&w=900&q=85', category: 'Traditional and Ethnic Wear', rating: 4.6,
    sizes: ['S', 'M', 'L', 'XL', 'XXL'], colors: ['Royal Blue', 'Magenta', 'Green'],
    description: 'A comfortable Punjabi suit pairing a straight kurta with classic pleated Patiala salwar trousers and a coordinating dupatta.',
  ),
];
