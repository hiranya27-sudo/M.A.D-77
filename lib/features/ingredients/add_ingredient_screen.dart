import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'ingredient_model.dart';
import 'ingredient_repository.dart';

class AddIngredientScreen extends ConsumerStatefulWidget {
  const AddIngredientScreen({super.key});

  @override
  ConsumerState<AddIngredientScreen> createState() =>
      _AddIngredientScreenState();
}

class _AddIngredientScreenState extends ConsumerState<AddIngredientScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _quantityCtrl = TextEditingController();
  String _unit = 'g';
  String _category = 'fridge';
  DateTime _expiry = DateTime.now().add(const Duration(days: 7));
  bool _saving = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _quantityCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: _expiry,
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) setState(() => _expiry = picked);
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final ingredient = Ingredient(
      id: '',
      name: _nameCtrl.text.trim(),
      quantity: double.tryParse(_quantityCtrl.text) ?? 1,
      unit: _unit,
      category: _category,
      expiryDate: _expiry,
    );

    await ref.read(ingredientRepositoryProvider).addIngredient(ingredient);

    /*await ref.scheduleExpiryNotification(
      id: ingredient.name.hashCode.abs(),
      name: ingredient.name,
      expiryDate: ingredient.expiryDate,
    );*/

    if (mounted) context.pop();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      appBar: AppBar(
        title: const Text('Add Ingredient'),
        backgroundColor: const Color(0xFF2D6A4F),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Name
              TextFormField(
                controller: _nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Ingredient Name',
                  prefixIcon: Icon(Icons.kitchen),
                  border: OutlineInputBorder(),
                  filled: true,
                  fillColor: Colors.white,
                ),
                validator: (v) =>
                    v == null || v.isEmpty ? 'Enter ingredient name' : null,
              ),
              const SizedBox(height: 16),

              // Quantity + Unit row
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _quantityCtrl,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Quantity',
                        border: OutlineInputBorder(),
                        filled: true,
                        fillColor: Colors.white,
                      ),
                      validator: (v) =>
                          v == null || v.isEmpty ? 'Enter quantity' : null,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade400),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _unit,
                        items: ['g', 'kg', 'ml', 'L', 'pcs', 'cups']
                            .map(
                              (u) => DropdownMenuItem(value: u, child: Text(u)),
                            )
                            .toList(),
                        onChanged: (v) => setState(() => _unit = v!),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // Category
              const Text(
                'Category',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B4332),
                ),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: ['fridge', 'freezer', 'pantry']
                    .map(
                      (c) => ChoiceChip(
                        label: Text(c),
                        selected: _category == c,
                        selectedColor: const Color(0xFF2D6A4F),
                        labelStyle: TextStyle(
                          color: _category == c ? Colors.white : Colors.black87,
                        ),
                        onSelected: (_) => setState(() => _category = c),
                      ),
                    )
                    .toList(),
              ),
              const SizedBox(height: 20),

              // Expiry date picker
              const Text(
                'Expiry Date',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1B4332),
                ),
              ),
              const SizedBox(height: 8),
              InkWell(
                onTap: _pickDate,
                child: Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(color: Colors.grey.shade400),
                    borderRadius: BorderRadius.circular(4),
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.calendar_today,
                        color: Color(0xFF2D6A4F),
                      ),
                      const SizedBox(width: 12),
                      Text(
                        '${_expiry.day}/${_expiry.month}/${_expiry.year}',
                        style: const TextStyle(fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 32),

              // Save button
              SizedBox(
                width: double.infinity,
                height: 48,
                child: _saving
                    ? const Center(child: CircularProgressIndicator())
                    : ElevatedButton.icon(
                        onPressed: _save,
                        icon: const Icon(Icons.save),
                        label: const Text(
                          'Save Ingredient',
                          style: TextStyle(fontSize: 16),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF2D6A4F),
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
