import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
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

  // TODO: replace with values from user profile saved in Firestore
  static const String _dietaryType = 'omnivore';
  static const List<String> _allergies = [];

  Future<void> _generate() async {
    setState(() {
      _loading = true;
      _error = null;
    });
    try {
      final ingredients = ref.read(ingredientsProvider).valueOrNull ?? [];

      if (ingredients.isEmpty) {
        setState(() {
          _error = 'Add some ingredients first before generating recipes.';
          _loading = false;
        });
        return;
      }

      /*final recipes = await ref
          .read(recipeServiceProvider)
          .generateRecipes(
            ingredients: ingredients,
            dietaryType: _dietaryType,
            allergies: _allergies,
          );*/

      @override
Widget build(BuildContext context) {
  return Scaffold(
    appBar: AppBar(title: const Text('Recipes')),
    body: const Center(
      child: Text('Recipe feature coming soon 🚧'),
    ),
  );
}
      setState(() => _recipes = recipes);
    } catch (e) {
      setState(
        () => _error = 'Could not generate recipes. Please try again.\n$e',
      );
    } finally {
      setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      appBar: AppBar(
        title: const Text('Recipes for You'),
        backgroundColor: const Color(0xFF2D6A4F),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Generate button
            SizedBox(
              width: double.infinity,
              height: 52,
              child: ElevatedButton.icon(
                onPressed: _loading ? null : _generate,
                icon: const Icon(Icons.auto_awesome),
                label: const Text(
                  'What can I cook?',
                  style: TextStyle(fontSize: 16),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF40916C),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Loading state
            if (_loading)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CircularProgressIndicator(color: Color(0xFF2D6A4F)),
                      SizedBox(height: 16),
                      Text(
                        'Asking Gemini AI...',
                        style: TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),

            // Error state
            if (_error != null && !_loading)
              Expanded(
                child: Center(
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.red.shade200),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.error_outline,
                          color: Colors.red,
                          size: 36,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          _error!,
                          textAlign: TextAlign.center,
                          style: const TextStyle(color: Colors.red),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: _generate,
                          child: const Text('Try Again'),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

            // Empty state
            if (_recipes == null && !_loading && _error == null)
              const Expanded(
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.restaurant, size: 64, color: Colors.grey),
                      SizedBox(height: 16),
                      Text(
                        'Tap the button above\nto get recipe suggestions',
                        textAlign: TextAlign.center,
                        style: TextStyle(color: Colors.grey, fontSize: 15),
                      ),
                    ],
                  ),
                ),
              ),

            // Recipe cards
            if (_recipes != null && !_loading)
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

  Color get _difficultyColor {
    if (recipe.difficulty == 'Easy') return Colors.green;
    if (recipe.difficulty == 'Medium') return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => context.push('/recipe-detail', extra: recipe),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Recipe name
              Text(
                recipe.name,
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1B4332),
                ),
              ),
              const SizedBox(height: 8),

              // Meta row
              Row(
                children: [
                  const Icon(Icons.timer, size: 14, color: Colors.grey),
                  const SizedBox(width: 4),
                  Text(
                    '${recipe.cookTimeMins} min',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const SizedBox(width: 12),
                  const Icon(
                    Icons.local_fire_department,
                    size: 14,
                    color: Colors.grey,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '${recipe.calories} kcal',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                  const Spacer(),
                  Chip(
                    label: Text(
                      recipe.difficulty,
                      style: TextStyle(fontSize: 11, color: _difficultyColor),
                    ),
                    backgroundColor: _difficultyColor.withOpacity(0.1),
                    side: BorderSide(color: _difficultyColor),
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
              const SizedBox(height: 8),

              // Ingredients preview
              Text(
                'Uses: ${recipe.ingredientsUsed.join(', ')}',
                style: const TextStyle(fontSize: 12, color: Color(0xFF40916C)),
                overflow: TextOverflow.ellipsis,
              ),
              if (recipe.ingredientsMissing.isNotEmpty)
                Text(
                  'Missing: ${recipe.ingredientsMissing.join(', ')}',
                  style: TextStyle(fontSize: 12, color: Colors.red.shade400),
                  overflow: TextOverflow.ellipsis,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
