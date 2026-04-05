import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ingredients/ingredient_repository.dart';
import 'recipe_service.dart';
import 'recipe_model.dart';

class RecipeScreen extends ConsumerStatefulWidget {
  const RecipeScreen({super.key});
  @override
  ConsumerState<RecipeScreen> createState() => _RecipeScreenState();
}

class _RecipeScreenState extends ConsumerState<RecipeScreen> {
  List<Recipe>? _recipes;
  bool _loading = false;
  String? _error;

  Future<void> _generate() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      // Get current ingredients from Firestore stream
      final ingredients = ref.read(ingredientsProvider).valueOrNull ?? [];

      // TODO: replace with real values from user profile (Phase 2 extension)
      const dietaryType = 'vegetarian';
      const allergies = <String>['gluten'];

      final recipes = await ref
          .read(recipeServiceProvider)
          .generateRecipes(
            ingredients: ingredients,
            dietaryType: dietaryType,
            allergies: allergies,
          );
      setState(() => _recipes = recipes);
    } catch (e) {
      setState(() => _error = 'Could not generate recipes: $e');
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recipes for You')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ElevatedButton.icon(
              onPressed: _loading ? null : _generate,
              icon: const Icon(Icons.auto_awesome),
              label: const Text('What can I cook?'),
            ),
            const SizedBox(height: 16),
            if (_loading) const CircularProgressIndicator(),
            if (_error != null)
              Text(_error!, style: const TextStyle(color: Colors.red)),
            if (_recipes != null)
              Expanded(
                child: ListView.builder(
                  itemCount: _recipes!.length,
                  itemBuilder: (_, i) => _RecipeCard(recipe: _recipes![i]),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  final Recipe recipe;
  const _RecipeCard({required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        title: Text(
          recipe.name,
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Text(
          '\${recipe.cookTimeMins} min  •  \${recipe.difficulty}  •  \${recipe.calories} kcal',
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          // TODO: navigate to recipe detail screen
        },
      ),
    );
  }
}
