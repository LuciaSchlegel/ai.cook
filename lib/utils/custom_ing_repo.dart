import 'dart:convert';
import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class CustomIngredientRepo {
  static Future<CustomIngredient> createCustomIngredient({
    required CustomIngredient customIngredient,
    String? uid,
  }) async {
    final url = Uri.parse('${dotenv.env['API_URL']}/ingredients/custom');

    final response = await http.post(
      url,
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'name': customIngredient.name,
        'category': customIngredient.category?.toJson(),
        'isVegan': customIngredient.isVegan,
        'isVegetarian': customIngredient.isVegetarian,
        'isGlutenFree': customIngredient.isGlutenFree,
        'isLactoseFree': customIngredient.isLactoseFree,
        'uid': uid,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(
        'Failed to create custom ingredient: '
        '${response.statusCode} - ${response.body}',
      );
    }

    final data = json.decode(response.body);
    if (data == null) {
      throw Exception('Invalid response from server');
    }

    return CustomIngredient.fromJson(data);
  }
}
