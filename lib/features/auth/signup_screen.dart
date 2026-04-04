import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'auth_provider.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _loading = false;
  String? _error;

  // Dietary profile selections
  String _dietaryType = 'omnivore';
  final List<String> _allergies = [];

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _signUp() async {
    if (!_formKey.currentState!.validate()) return;
    if (_passwordCtrl.text != _confirmCtrl.text) {
      setState(() => _error = 'Passwords do not match');
      return;
    }
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      await ref
          .read(authServiceProvider)
          .signUp(_emailCtrl.text.trim(), _passwordCtrl.text.trim());
    } catch (e) {
      setState(() => _error = 'Sign up failed. Try a different email.');
    } finally {
      setState(() => _loading = false);
    }
  }

  void _toggleAllergy(String allergy) {
    setState(() {
      if (_allergies.contains(allergy)) {
        _allergies.remove(allergy);
      } else {
        _allergies.add(allergy);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Color(0xFF1B4332)),
          onPressed: () => context.go('/login'),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(28),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Create Account',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1B4332),
                  ),
                ),
                const Text(
                  'Set up your ChefMind profile',
                  style: TextStyle(color: Color(0xFF6B7280)),
                ),
                const SizedBox(height: 28),

                // Email
                TextFormField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Enter your email' : null,
                ),
                const SizedBox(height: 14),

                // Password
                TextFormField(
                  controller: _passwordCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock_outlined),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (v) =>
                      v == null || v.length < 6 ? 'Min 6 characters' : null,
                ),
                const SizedBox(height: 14),

                // Confirm password
                TextFormField(
                  controller: _confirmCtrl,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Confirm Password',
                    prefixIcon: Icon(Icons.lock_outlined),
                    border: OutlineInputBorder(),
                    filled: true,
                    fillColor: Colors.white,
                  ),
                  validator: (v) =>
                      v == null || v.isEmpty ? 'Confirm your password' : null,
                ),
                const SizedBox(height: 24),

                // Dietary type
                const Text(
                  'Dietary Type',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF1B4332),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children:
                      ['omnivore', 'vegetarian', 'vegan', 'ketogenic', 'paleo']
                          .map(
                            (type) => ChoiceChip(
                              label: Text(type),
                              selected: _dietaryType == type,
                              selectedColor: const Color(0xFF2D6A4F),
                              labelStyle: TextStyle(
                                color: _dietaryType == type
                                    ? Colors.white
                                    : Colors.black87,
                              ),
                              onSelected: (_) =>
                                  setState(() => _dietaryType = type),
                            ),
                          )
                          .toList(),
                ),
                const SizedBox(height: 20),

                // Allergies
                const Text(
                  'Allergies (select all that apply)',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Color(0xFF1B4332),
                  ),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: ['gluten', 'dairy', 'nuts', 'eggs', 'shellfish']
                      .map(
                        (a) => FilterChip(
                          label: Text(a),
                          selected: _allergies.contains(a),
                          selectedColor: Colors.red.shade100,
                          checkmarkColor: Colors.red.shade700,
                          onSelected: (_) => _toggleAllergy(a),
                        ),
                      )
                      .toList(),
                ),
                const SizedBox(height: 12),

                // Error message
                if (_error != null)
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),

                const SizedBox(height: 24),

                // Sign up button
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: _loading
                      ? const Center(child: CircularProgressIndicator())
                      : ElevatedButton(
                          onPressed: _signUp,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF2D6A4F),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          child: const Text(
                            'Create Account',
                            style: TextStyle(fontSize: 16),
                          ),
                        ),
                ),
                const SizedBox(height: 12),

                Center(
                  child: TextButton(
                    onPressed: () => context.go('/login'),
                    child: const Text(
                      'Already have an account? Log In',
                      style: TextStyle(color: Color(0xFF2D6A4F)),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
