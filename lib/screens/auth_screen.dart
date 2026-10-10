import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/cart_provider.dart';
import '../theme/app_theme.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _name = TextEditingController();
  final _identity = TextEditingController();
  final _password = TextEditingController();
  bool _registering = false;
  bool _obscurePassword = true;
  bool _loading = false;

  @override
  void dispose() {
    _name.dispose();
    _identity.dispose();
    _password.dispose();
    super.dispose();
  }

  String? _identityValidator(String? value) {
    final input = value?.trim() ?? '';
    final isEmail = RegExp(r'^[^\s@]+@[^\s@]+\.[^\s@]+$').hasMatch(input);
    var mobile = input.replaceAll(RegExp(r'\D'), '');
    if (mobile.length == 12 && mobile.startsWith('91')) mobile = mobile.substring(2);
    if (!isEmail && !RegExp(r'^[6-9]\d{9}$').hasMatch(mobile)) {
      return 'Enter a valid email or 10-digit Indian mobile number';
    }
    return null;
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future<void>.delayed(const Duration(milliseconds: 500));
    if (!mounted) return;
    final identity = _identity.text.trim();
    final name = _registering
        ? _name.text.trim()
        : (identity.contains('@') ? identity.split('@').first : 'Fashion Lover');
    context.read<CartProvider>().login(name: name, email: identity);
    Navigator.pushNamedAndRemoveUntil(context, '/', (route) => false);
  }

  void _forgotPassword() {
    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Password help'),
        content: const Text('Password reset is not connected in this demo. Use any password with at least 6 characters.'),
        actions: [TextButton(onPressed: () => Navigator.pop(context), child: const Text('Got it'))],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final wide = MediaQuery.sizeOf(context).width > 760;
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Card(
              elevation: 3,
              child: Padding(
                padding: EdgeInsets.all(wide ? 36 : 24),
                child: Form(
                  key: _formKey,
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
                    const CircleAvatar(radius: 34, backgroundColor: AppTheme.lavender, child: Icon(Icons.shopping_bag_outlined, size: 34, color: AppTheme.primary)),
                    const SizedBox(height: 14),
                    const Text('Shopping Mart', textAlign: TextAlign.center, style: TextStyle(fontSize: 28, fontWeight: FontWeight.w800)),
                    const SizedBox(height: 5),
                    Text(_registering ? 'Create your account' : 'Good style starts here', textAlign: TextAlign.center, style: const TextStyle(color: Colors.black54)),
                    const SizedBox(height: 24),
                    if (_registering) ...[
                      TextFormField(controller: _name, textCapitalization: TextCapitalization.words, decoration: const InputDecoration(labelText: 'Full name', prefixIcon: Icon(Icons.person_outline)), validator: (value) => (value?.trim().length ?? 0) < 2 ? 'Enter your name' : null),
                      const SizedBox(height: 14),
                    ],
                    TextFormField(controller: _identity, keyboardType: TextInputType.emailAddress, decoration: const InputDecoration(labelText: 'Email or mobile number', prefixIcon: Icon(Icons.alternate_email)), validator: _identityValidator),
                    const SizedBox(height: 14),
                    TextFormField(
                      controller: _password,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password', prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(tooltip: _obscurePassword ? 'Show password' : 'Hide password', onPressed: () => setState(() => _obscurePassword = !_obscurePassword), icon: Icon(_obscurePassword ? Icons.visibility_outlined : Icons.visibility_off_outlined)),
                      ),
                      validator: (value) => (value?.length ?? 0) < 6 ? 'Use at least 6 characters' : null,
                    ),
                    if (!_registering) Align(alignment: Alignment.centerRight, child: TextButton(onPressed: _forgotPassword, child: const Text('Forgot password?'))),
                    const SizedBox(height: 12),
                    FilledButton.icon(onPressed: _loading ? null : _submit, icon: _loading ? const SizedBox.square(dimension: 18, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white)) : const Icon(Icons.arrow_forward), label: Text(_loading ? 'Please wait...' : _registering ? 'Create account' : 'Login'), style: FilledButton.styleFrom(minimumSize: const Size.fromHeight(50))),
                    TextButton(onPressed: _loading ? null : () => setState(() => _registering = !_registering), child: Text(_registering ? 'Already registered? Login' : 'New here? Create an account')),
                    const SizedBox(height: 6),
                    const Text('DEMO AUTHENTICATION · No account or backend is contacted.', textAlign: TextAlign.center, style: TextStyle(fontSize: 11, color: Colors.black54)),
                  ]),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}