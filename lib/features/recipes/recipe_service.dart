/*import 'dart:convert';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../ingredients/ingredient_model.dart';
import 'recipe_model.dart';

class RecipeService {
  RecipeService(this._config);

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
Return ONLY a valid JSON array. No markdown, no explanation, no extra text outside the JSON.

Dietary type: $dietaryType
Allergies to strictly avoid: $allergyText
Available ingredients: $ingredientList

Rules:
- Prioritise ingredients that expire soonest
- Strictly exclude ingredients matching the allergy list
- Return exactly 3 recipes

Each recipe must follow this exact JSON structure:
{
  "name": "string",
  "cook_time_mins": number,
  "difficulty": "Easy" or "Medium" or "Hard",
  "calories": number,
  "ingredients_used": ["string", "string"],
  "ingredients_missing": ["string"],
  "steps": ["Step 1...", "Step 2..."]
}

Return only the JSON array, nothing else.
''';
  }

  Future<List<Recipe>> generateRecipes({
    required List<Ingredient> ingredients,
    required String dietaryType,
    required List<String> allergies,
  }) async {
    final apiKey = _config.geminiApiKey;
    if (apiKey.isEmpty)
      throw Exception('Gemini API key not found in Remote Config');

    final model = GenerativeModel(model: 'gemini-1.5-flash', apiKey: apiKey);

    final prompt = _buildPrompt(
      ingredients: ingredients,
      dietaryType: dietaryType,
      allergies: allergies,
    );

    final response = await model.generateContent([Content.text(prompt)]);
    final text = response.text ?? '';

    // Strip markdown fences if Gemini adds them
    final cleaned = text.replaceAll('```json', '').replaceAll('```', '').trim();

    final List<dynamic> jsonList = jsonDecode(cleaned);
    return jsonList
        .map((j) => Recipe.fromJson(j as Map<String, dynamic>))
        .toList();
  }
}

final recipeServiceProvider = Provider<RecipeService>((ref) {
  return RecipeService(ref.read(remoteConfigServiceProvider));
});
}*/
