import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:chefmind/features/ingredients/ingredient_repository.dart';
import 'package:chefmind/features/ingredients/ingredient_model.dart';
import 'package:chefmind/features/auth/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ingredientsAsync = ref.watch(ingredientsProvider);

    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      appBar: AppBar(
        title: const Text(
          'ChefMind',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF2D6A4F),
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Log out',
            onPressed: () async {
              await ref.read(authServiceProvider).logout();
              if (context.mounted) context.go('/login');
            },
          ),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          FloatingActionButton.extended(
            heroTag: 'recipes',
            onPressed: () => context.push('/recipes'),
            backgroundColor: const Color(0xFF40916C),
            foregroundColor: Colors.white,
            icon: const Icon(Icons.auto_awesome),
            label: const Text('What can I cook?'),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'add',
            onPressed: () => context.push('/add-ingredient'),
            backgroundColor: const Color(0xFF2D6A4F),
            foregroundColor: Colors.white,
            child: const Icon(Icons.add),
          ),
        ],
      ),
      body: ingredientsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading ingredients: $e')),
        data: (ingredients) {
          if (ingredients.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.kitchen, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(
                    'Your pantry is empty',
                    style: TextStyle(fontSize: 18, color: Colors.grey),
                  ),
                  SizedBox(height: 8),
                  Text(
                    'Tap + to add your first ingredient',
                    style: TextStyle(color: Colors.grey),
                  ),
                ],
              ),
            );
          }

          final urgent = ingredients
              .where((i) => i.daysUntilExpiry <= 3)
              .toList();

          return ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 120),
            children: [
              if (urgent.isNotEmpty) ...[
                const Row(
                  children: [
                    Icon(Icons.warning_amber, color: Colors.orange, size: 20),
                    SizedBox(width: 6),
                    Text(
                      'Use It Now',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Color(0xFF1B4332),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                SizedBox(
                  height: 90,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: urgent.length,
                    itemBuilder: (_, i) => _ExpiryCard(ingredient: urgent[i]),
                  ),
                ),
                const SizedBox(height: 20),
              ],

              const Text(
                'All Ingredients',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1B4332),
                ),
              ),
              const SizedBox(height: 10),

              ...ingredients.map((i) => _IngredientTile(ingredient: i)),
            ],
          );
        },
      ),
    );
  }
}

class _ExpiryCard extends StatelessWidget {
  final Ingredient ingredient;
  const _ExpiryCard({required this.ingredient});

  Color get _bgColor {
    if (ingredient.expiryStatus == 'red') return Colors.red.shade100;
    if (ingredient.expiryStatus == 'amber') return Colors.orange.shade100;
    return Colors.green.shade100;
  }

  Color get _borderColor {
    if (ingredient.expiryStatus == 'red') return Colors.red.shade400;
    if (ingredient.expiryStatus == 'amber') return Colors.orange.shade400;
    return Colors.green.shade400;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 110,
      margin: const EdgeInsets.only(right: 10),
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: _bgColor,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: _borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            ingredient.name,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 4),
          Text(
            ingredient.daysUntilExpiry <= 0
                ? 'Expires today!'
                : '${ingredient.daysUntilExpiry}d left',
            style: const TextStyle(fontSize: 11),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

class _IngredientTile extends ConsumerWidget {
  final Ingredient ingredient;
  const _IngredientTile({required this.ingredient});

  Color get _badgeColor {
    if (ingredient.expiryStatus == 'red') return Colors.red;
    if (ingredient.expiryStatus == 'amber') return Colors.orange;
    return Colors.green;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Dismissible(
      key: Key(ingredient.id),
      direction: DismissDirection.endToStart,
      background: Container(
        margin: const EdgeInsets.only(bottom: 8),
        decoration: BoxDecoration(
          color: Colors.red,
          borderRadius: BorderRadius.circular(10),
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        child: const Icon(Icons.delete, color: Colors.white),
      ),
      onDismissed: (_) => ref
          .read(ingredientRepositoryProvider)
          .deleteIngredient(ingredient.id),
      child: Card(
        margin: const EdgeInsets.only(bottom: 8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: const Color(0xFFD8F3DC),
            child: Text(
              ingredient.name[0].toUpperCase(),
              style: const TextStyle(
                color: Color(0xFF1B4332),
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          title: Text(
            ingredient.name,
            style: const TextStyle(fontWeight: FontWeight.w600),
          ),
          subtitle: Text(
            '${ingredient.quantity} ${ingredient.unit} • ${ingredient.category}',
          ),
          trailing: Chip(
            label: Text(
              '${ingredient.daysUntilExpiry}d',
              style: TextStyle(fontSize: 11, color: _badgeColor),
            ),
            backgroundColor: _badgeColor.withOpacity(0.15),
            side: BorderSide(color: _badgeColor),
            padding: EdgeInsets.zero,
          ),
        ),
      ),
    );
  }
}
