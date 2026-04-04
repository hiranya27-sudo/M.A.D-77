import 'package:flutter/material.dart';
import 'recipe_model.dart';

class RecipeDetailScreen extends StatelessWidget {
  final Recipe recipe;
  const RecipeDetailScreen({super.key, required this.recipe});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0FDF4),
      appBar: AppBar(
        title: Text(recipe.name),
        backgroundColor: const Color(0xFF2D6A4F),
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Meta strip
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                _MetaBox(
                  icon: Icons.timer,
                  label: 'Cook Time',
                  value: '${recipe.cookTimeMins} min',
                ),
                _MetaBox(
                  icon: Icons.signal_cellular_alt,
                  label: 'Difficulty',
                  value: recipe.difficulty,
                ),
                _MetaBox(
                  icon: Icons.local_fire_department,
                  label: 'Calories',
                  value: '${recipe.calories} kcal',
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Ingredients — Have
            const Text(
              'Ingredients You Have',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1B4332),
              ),
            ),
            const SizedBox(height: 8),
            ...recipe.ingredientsUsed.map(
              (i) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 3),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.green,
                      size: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(i, style: const TextStyle(fontSize: 14)),
                  ],
                ),
              ),
            ),

            // Ingredients — Missing
            if (recipe.ingredientsMissing.isNotEmpty) ...[
              const SizedBox(height: 16),
              const Text(
                'Ingredients You Need',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  color: Color(0xFF1B4332),
                ),
              ),
              const SizedBox(height: 8),
              ...recipe.ingredientsMissing.map(
                (i) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 3),
                  child: Row(
                    children: [
                      Icon(Icons.cancel, color: Colors.red.shade400, size: 18),
                      const SizedBox(width: 8),
                      Text(i, style: const TextStyle(fontSize: 14)),
                    ],
                  ),
                ),
              ),
            ],

            const SizedBox(height: 24),

            // Steps
            const Text(
              'Instructions',
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
                color: Color(0xFF1B4332),
              ),
            ),
            const SizedBox(height: 8),
            ...recipe.steps.asMap().entries.map(
              (entry) => Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CircleAvatar(
                      radius: 13,
                      backgroundColor: const Color(0xFF2D6A4F),
                      child: Text(
                        '${entry.key + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        entry.value,
                        style: const TextStyle(fontSize: 14, height: 1.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

class _MetaBox extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  const _MetaBox({
    required this.icon,
    required this.label,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        children: [
          Icon(icon, color: const Color(0xFF2D6A4F), size: 22),
          const SizedBox(height: 4),
          Text(
            value,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
          ),
          Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey)),
        ],
      ),
    );
  }
}
