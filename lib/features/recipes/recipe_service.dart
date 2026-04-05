import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ingredients/ingredient_model.dart';
import '../../services/remote_config_service.dart';
import 'recipe_model.dart';

class RecipeService {
  final RemoteConfigService _config;
  RecipeService(this._config);

  // Build the prompt from ingredients + dietary profile
  String _buildPrompt({
    required List<Ingredient> ingredients,
    required String dietaryType,
    required List<String> allergies,
  }) {
    final ingredientList = ingredients
        .map(
          (i) =>
              '${i.name} x${i.quantity}${i.unit} (expires in ${i.daysUntilExpiry} days)',
        )
        .join(', ');

    final allergyText = allergies.isEmpty ? 'none' : allergies.join(', ');

    return '''
You are a professional chef AI.
Return ONLY a valid JSON array. No markdown, no explanation, no extra text.
 
Dietary type: $dietaryType
Allergies to avoid: $allergyText
Available ingredients: $ingredientList
 
Rules:
- Prioritise ingredients expiring soonest
- Strictly exclude any ingredient matching the allergy list
- Return exactly 3 recipes
 
JSON format for each recipe:
{
  'name': string,
  'cook_time_mins': number,
  'difficulty': 'Easy' or 'Medium' or 'Hard',
  'calories': number,
  'ingredients_used': [list of strings],
  'ingredients_missing': [list of strings],
  'steps': [list of step strings]
}
''';
  }

  // Call Gemini and return list of recipes
  Future<List<Recipe>> generateRecipes({
    required List<Ingredient> ingredients,
    required String dietaryType,
    required List<String> allergies,
  }) async {
    final model = GenerativeModel(
      model: 'gemini-1.5-flash',
      apiKey: _config.geminiApiKey,
    );

    final prompt = _buildPrompt(
      ingredients: ingredients,
      dietaryType: dietaryType,
      allergies: allergies,
    );

    final response = await model.generateContent([Content.text(prompt)]);

    // Extract the text from Gemini response
    final text = response.text ?? '';

    // Remove any accidental markdown fences
    final cleaned = text.replaceAll('```json', '').replaceAll('```', '').trim();

    // Parse JSON and convert to Recipe list
    final List<dynamic> jsonList = jsonDecode(cleaned);
    return jsonList
        .map((j) => Recipe.fromJson(j as Map<String, dynamic>))
        .toList();
  }
}

final recipeServiceProvider = Provider<RecipeService>((ref) {
  return RecipeService(ref.read(remoteConfigServiceProvider));
});
