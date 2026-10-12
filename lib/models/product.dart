class Product {
  final String id;
  final String name;
  final double price;
  final String imageUrl;
  final String description;
  final String audience;
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
    required this.audience,
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
    name: 'Floral Ruffle Day Dress',
    price: 1299,
    originalPrice: 1699,
    imageUrl:
        'https://images.unsplash.com/photo-1496747611176-843222e1e57c?auto=format&fit=crop&w=900&q=85',
    description:
        'A cheerful floral dress with soft ruffles, a comfy cotton feel, and an easy fit for school events and weekend outings.',
    audience: 'Girls',
    category: 'Dresses',
    rating: 4.8,
    sizes: ['5Y', '6Y', '8Y', '10Y', '12Y'],
    colors: ['Rose', 'Ivory', 'Sage'],
  ),
  const Product(
    id: 'p2',
    name: 'Twirl-Ready Party Gown',
    price: 2190,
    originalPrice: 2790,
    imageUrl:
        'https://images.unsplash.com/photo-1539008835657-9e8e9680c956?auto=format&fit=crop&w=900&q=85',
    description:
        'A light, flowy party gown with a pretty flared skirt for birthdays, family celebrations, and dancing.',
    audience: 'Girls',
    category: 'Party Wear',
    rating: 4.7,
    sizes: ['5Y', '6Y', '8Y', '10Y', '12Y'],
    colors: ['Lavender', 'Rose', 'Navy'],
  ),
  const Product(
    id: 'p3',
    name: 'Denim Dungaree Set',
    price: 1499,
    imageUrl:
        'https://images.unsplash.com/photo-1566174053879-31528523f8ae?auto=format&fit=crop&w=900&q=85',
    description:
        'A playful denim dungaree with an easy-to-layer tee, adjustable straps, and roomy pockets for everyday adventures.',
    audience: 'Girls',
    category: 'Tops and Bottoms',
    rating: 4.6,
    sizes: ['5Y', '6Y', '8Y', '10Y', '12Y'],
    colors: ['Indigo', 'Light Blue', 'Pink'],
  ),
  const Product(
    id: 'p4',
    name: 'Rainbow Tiered Cotton Frock',
    price: 999,
    originalPrice: 1299,
    imageUrl:
        'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?auto=format&fit=crop&w=900&q=85',
    description:
        'A breezy tiered cotton frock with a bright print and a comfortable shape for playdates and sunny-day outings.',
    audience: 'Girls',
    category: 'Dresses',
    rating: 4.5,
    sizes: ['5Y', '6Y', '8Y', '10Y', '12Y'],
    colors: ['Blue', 'White', 'Yellow'],
  ),
  const Product(
    id: 'p5',
    name: 'Mini Festive Anarkali Set',
    price: 1899,
    imageUrl:
        'https://images.unsplash.com/photo-1610030469983-98e550d6193c?auto=format&fit=crop&w=900&q=85',
    description:
        'A festive Anarkali set with delicate print, soft lining, and an easy flare for family celebrations and special days.',
    audience: 'Girls',
    category: 'Ethnic Wear',
    rating: 4.8,
    sizes: ['5Y', '6Y', '8Y', '10Y', '12Y'],
    colors: ['Green', 'Pink', 'Mustard'],
  ),
  const Product(
    id: 'p6',
    name: 'Little Explorer Tee and Shorts',
    price: 699,
    originalPrice: 899,
    imageUrl:
        'https://images.unsplash.com/photo-1583391733956-6c78276477e7?auto=format&fit=crop&w=900&q=85',
    description:
        'A soft everyday tee-and-shorts set with a relaxed fit, designed for comfy playtime and easy movement.',
    audience: 'Kids',
    category: 'Tops and Bottoms',
    rating: 4.4,
    sizes: ['2Y', '3Y', '4Y', '5Y', '6Y'],
    colors: ['Blue', 'Teal', 'Yellow'],
  ),
  const Product(
    id: 'p7',
    name: 'Rainbow Birthday Tulle Dress',
    price: 1190,
    imageUrl:
        'https://images.unsplash.com/photo-1598554747436-c9293d6a588f?auto=format&fit=crop&w=900&q=85',
    description:
        'A light party dress with a soft, swishy skirt and cheerful colors for birthdays, photos, and family get-togethers.',
    audience: 'Kids',
    category: 'Party Wear',
    rating: 4.3,
    sizes: ['2Y', '3Y', '4Y', '5Y', '6Y'],
    colors: ['Lilac', 'Coral', 'Pink'],
  ),
  const Product(
    id: 'p8',
    name: 'Cozy Hoodie and Jogger Set',
    price: 1499,
    imageUrl:
        'https://images.unsplash.com/photo-1583496661160-fb5886a0aaaa?auto=format&fit=crop&w=900&q=85',
    description:
        'A cozy matching hoodie and jogger set in a soft-feel fabric, perfect for cooler days, travel, and relaxed weekends.',
    audience: 'Kids',
    category: 'Co-ord Sets',
    rating: 4.5,
    sizes: ['2Y', '3Y', '4Y', '5Y', '6Y'],
    colors: ['Lilac', 'Blue', 'Cream'],
  ),
  const Product(
    id: 'p9',
    name: 'Tiny Tradition Kurta Set',
    price: 1599,
    imageUrl:
        'https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?auto=format&fit=crop&w=900&q=85',
    description:
        'A comfortable printed kurta and pajama set with gentle colors for festivals, family visits, and celebrations.',
    audience: 'Kids',
    category: 'Ethnic Wear',
    rating: 4.7,
    sizes: ['2Y', '3Y', '4Y', '5Y', '6Y'],
    colors: ['Blush', 'Sage', 'Blue'],
  ),
  const Product(
    id: 'p10',
    name: 'Playtime Printed Romper',
    price: 799,
    imageUrl:
        'https://images.unsplash.com/photo-1503944583220-79d8926ad5e2?auto=format&fit=crop&w=900&q=85',
    description:
        'An easy one-piece romper in a playful print with a comfy fit for little ones on the move.',
    audience: 'Kids',
    category: 'Dresses',
    rating: 4.6,
    sizes: ['2Y', '3Y', '4Y', '5Y', '6Y'],
    colors: ['Pink', 'Yellow', 'Blue'],
  ),
  const Product(
    id: 'p11',
    name: 'Midnight Satin Evening Maxi',
    price: 3290,
    imageUrl:
        'https://images.unsplash.com/photo-1566174053879-31528523f8ae?auto=format&fit=crop&w=900&q=85',
    description:
        'A graceful satin maxi with a fluid drape and refined finish for dinners, parties, and evening occasions.',
    audience: 'Women',
    category: 'Party Wear',
    rating: 4.9,
    sizes: ['S', 'M', 'L', 'XL'],
    colors: ['Rose', 'Navy', 'Black'],
  ),
  const Product(
    id: 'p12',
    name: 'Everyday Printed Kurti Set',
    price: 1599,
    originalPrice: 1999,
    imageUrl:
        'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?auto=format&fit=crop&w=900&q=85',
    description:
        'A breathable printed kurti with matching bottoms and side slits, made for workdays and comfortable everyday wear.',
    audience: 'Women',
    category: 'Ethnic Wear',
    rating: 4.5,
    sizes: ['S', 'M', 'L', 'XL', 'XXL'],
    colors: ['Indigo', 'Pink', 'Teal'],
  ),
  const Product(
    id: 'p13',
    name: 'Soft Focus Linen Co-ord',
    price: 2199,
    originalPrice: 2899,
    imageUrl:
        'https://images.unsplash.com/photo-1610030469983-98e550d6193c?auto=format&fit=crop&w=900&q=85',
    description:
        'A relaxed matching shirt and wide-leg trouser set in a soft linen blend, versatile for brunch and travel.',
    audience: 'Women',
    category: 'Co-ord Sets',
    rating: 4.8,
    sizes: ['S', 'M', 'L', 'XL', 'XXL'],
    colors: ['Fuchsia', 'Sage', 'Teal'],
  ),
  const Product(
    id: 'p14',
    name: 'Phulkari Punjabi Suit Set',
    price: 2499,
    originalPrice: 3199,
    imageUrl:
        'https://images.unsplash.com/photo-1617627143750-d86bc21e42bb?auto=format&fit=crop&w=900&q=85',
    description:
        'A vibrant Punjabi suit set with floral detailing, a soft kurta, matching bottoms, and a light dupatta.',
    audience: 'Women',
    category: 'Ethnic Wear',
    rating: 4.9,
    sizes: ['S', 'M', 'L', 'XL', 'XXL'],
    colors: ['Rose Pink', 'Maroon', 'Emerald'],
  ),
  const Product(
    id: 'p15',
    name: 'Gulabi Lehenga Choli',
    price: 4699,
    originalPrice: 5999,
    imageUrl:
        'https://images.unsplash.com/photo-1583391733956-6c78276477e7?auto=format&fit=crop&w=900&q=85',
    description:
        'A festive three-piece lehenga choli with a flared skirt, coordinating blouse, and dupatta for wedding celebrations.',
    audience: 'Women',
    category: 'Ethnic Wear',
    rating: 4.7,
    sizes: ['S', 'M', 'L', 'XL'],
    colors: ['Lilac', 'Coral', 'Navy'],
  ),
  const Product(
    id: 'p16',
    name: 'High-Rise Straight-Leg Jeans',
    price: 1799,
    originalPrice: 2299,
    imageUrl:
        'https://images.unsplash.com/photo-1541099649105-f69ad21f3246?auto=format&fit=crop&w=900&q=85',
    description:
        'Comfort-stretch, high-rise denim with a straight leg and classic five-pocket styling for everyday outfits.',
    audience: 'Women',
    category: 'Tops and Bottoms',
    rating: 4.6,
    sizes: ['26', '28', '30', '32', '34'],
    colors: ['Indigo', 'Light Blue', 'Black'],
  ),
];
