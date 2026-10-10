import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../widgets/custom_widgets.dart';

class CheckoutScreen extends StatefulWidget {
  final CartItem? buyNowItem;
  const CheckoutScreen({super.key, this.buyNowItem});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _mobile = TextEditingController();
  final _email = TextEditingController();
  final _house = TextEditingController();
  final _locality = TextEditingController();
  final _city = TextEditingController();
  final _state = TextEditingController();
  final _pin = TextEditingController();
  final _instructions = TextEditingController();
  String _paymentMethod = 'Cash on Delivery';
  bool _placingOrder = false;
  bool _submitted = false;

  @override
  void initState() {
    super.initState();
    final cart = context.read<CartProvider>();
    _name.text = cart.userName ?? '';
    if (cart.userEmail?.contains('@') ?? false) _email.text = cart.userEmail!;
  }

  @override
  void dispose() {
    for (final controller in [_name, _mobile, _email, _house, _locality, _city, _state, _pin, _instructions]) {
      controller.dispose();
    }
    super.dispose();
  }

  String? _required(String? value, String label) => (value?.trim().isEmpty ?? true) ? '$label is required' : null;

  String _address() => '${_house.text.trim()}, ${_locality.text.trim()}, ${_city.text.trim()}, ${_state.text.trim()} - ${_pin.text.trim()}';

  Future<void> _placeOrder(List<CartItem> orderedItems, bool buyNow) async {
    if (_placingOrder || _submitted) return;
    if (!_formKey.currentState!.validate()) return;
    setState(() => _placingOrder = true);
    await Future<void>.delayed(const Duration(milliseconds: 600));
    if (!mounted) return;
    final order = context.read<CartProvider>().createOrder(
      orderedItems: orderedItems,
      customerName: _name.text.trim(),
      address: _address(),
      paymentMethod: _paymentMethod,
      deliveryCharge: orderedItems.fold<double>(0, (sum, item) => sum + item.total) >= 2500 ? 0 : 99,
      deliveryInstructions: _instructions.text.trim(),
      clearCart: !buyNow,
    );
    setState(() {
      _submitted = true;
      _placingOrder = false;
    });
    Navigator.pushReplacementNamed(context, '/confirmation', arguments: order);
  }

  @override
  Widget build(BuildContext context) {
    final cart = context.watch<CartProvider>();
    final buyNow = widget.buyNowItem != null;
    final items = buyNow ? [widget.buyNowItem!] : cart.items.values.toList();
    final subtotal = items.fold<double>(0, (sum, item) => sum + item.total);
    final delivery = subtotal >= 2500 ? 0.0 : 99.0;

    return Scaffold(
      appBar: AppBar(title: const Text('Checkout')),
      body: items.isEmpty
          ? Center(child: Column(mainAxisSize: MainAxisSize.min, children: [const Text('Your bag is empty.'), const SizedBox(height: 12), FilledButton(onPressed: () => Navigator.pop(context), child: const Text('Back to bag'))]))
          : Center(child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 920),
              child: Form(key: _formKey, child: ListView(padding: const EdgeInsets.all(20), children: [
                const Text('Delivery details', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 12),
                _field(_name, 'Full name', Icons.person_outline, validator: (value) => _required(value, 'Full name'), capitalization: TextCapitalization.words),
                _field(_mobile, 'Mobile number', Icons.phone_outlined, keyboard: TextInputType.phone, validator: (value) {
                  final digits = value?.replaceAll(RegExp(r'\D'), '') ?? '';
                  return RegExp(r'^[6-9]\d{9}$').hasMatch(digits) ? null : 'Enter a valid 10-digit Indian mobile number';
                }),
                _field(_email, 'Email address', Icons.email_outlined, keyboard: TextInputType.emailAddress, validator: (value) => RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(value?.trim() ?? '') ? null : 'Enter a valid email address'),
                _field(_house, 'House number and street', Icons.home_outlined, validator: (value) => _required(value, 'House and street'), capitalization: TextCapitalization.words),
                _field(_locality, 'Area or locality', Icons.location_on_outlined, validator: (value) => _required(value, 'Area or locality'), capitalization: TextCapitalization.words),
                Row(children: [
                  Expanded(child: _field(_city, 'City', Icons.location_city, validator: (value) => _required(value, 'City'), capitalization: TextCapitalization.words)),
                  const SizedBox(width: 10),
                  Expanded(child: _field(_state, 'State', Icons.map_outlined, validator: (value) => _required(value, 'State'), capitalization: TextCapitalization.words)),
                ]),
                _field(_pin, 'PIN code', Icons.markunread_mailbox_outlined, keyboard: TextInputType.number, validator: (value) => RegExp(r'^[1-9][0-9]{5}$').hasMatch(value?.trim() ?? '') ? null : 'Enter a valid 6-digit Indian PIN code'),
                _field(_instructions, 'Delivery instructions (optional)', Icons.edit_note_outlined, maxLines: 2),
                const SizedBox(height: 8),
                const Text('Order summary', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
                const SizedBox(height: 8),
                Card(child: Column(children: [
                  for (final item in items) ListTile(
                    leading: SizedBox(width: 44, child: ProductImage(product: item.product)),
                    title: Text(item.product.name, maxLines: 1, overflow: TextOverflow.ellipsis),
                    subtitle: Text('Size ${item.size} · ${item.color} · Qty ${item.quantity}\n${item.product.formattedPrice} each'),
                    isThreeLine: true,
                    trailing: Text('₹${item.total.toStringAsFixed(0)}'),
                  ),
                  const Divider(),
                  _summaryLine('Subtotal', '₹${subtotal.toStringAsFixed(0)}'),
                  _summaryLine('Delivery', delivery == 0 ? 'Free' : '₹${delivery.toStringAsFixed(0)}'),
                  _summaryLine('Discount', '₹0'),
                  _summaryLine('Payable', '₹${(subtotal + delivery).toStringAsFixed(0)}', bold: true),
                ])),
                const SizedBox(height: 14),
                const Text('Payment method', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w800)),
                RadioGroup<String>(
                  groupValue: _paymentMethod,
                  onChanged: (value) => setState(() => _paymentMethod = value!),
                  child: const Column(children: [
                    RadioListTile<String>(value: 'Cash on Delivery', title: Text('Cash on Delivery'), secondary: Icon(Icons.payments_outlined)),
                    RadioListTile<String>(value: 'Simulated online payment', title: Text('Simulated online payment'), secondary: Icon(Icons.phone_android)),
                  ]),
                ),
                const Padding(padding: EdgeInsets.symmetric(horizontal: 16), child: Text('Demo only. No payment is processed; never enter banking passwords, card PINs, or OTPs.', style: TextStyle(color: Colors.black54, fontSize: 12))),
                const SizedBox(height: 14),
                FilledButton.icon(
                  onPressed: _placingOrder || _submitted ? null : () => _placeOrder(items, buyNow),
                  icon: _placingOrder ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.check_circle_outline),
                  label: Text(_placingOrder ? 'Placing demo order...' : 'Place demo order · ₹${(subtotal + delivery).toStringAsFixed(0)}'),
                  style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50)),
                ),
              ])),
            )),
    );
  }

  Widget _field(TextEditingController controller, String label, IconData icon, {String? Function(String?)? validator, TextInputType keyboard = TextInputType.text, TextCapitalization capitalization = TextCapitalization.none, int maxLines = 1}) => Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: TextFormField(controller: controller, keyboardType: keyboard, textCapitalization: capitalization, maxLines: maxLines, validator: validator, decoration: InputDecoration(labelText: label, prefixIcon: Icon(icon))),
      );

  Widget _summaryLine(String label, String value, {bool bold = false}) => Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 7),
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [Text(label, style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.normal)), Text(value, style: TextStyle(fontWeight: bold ? FontWeight.w800 : FontWeight.w600))]),
      );
}