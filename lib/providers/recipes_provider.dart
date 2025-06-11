import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class RecipesProvider extends ChangeNotifier {
  List<Recipe> _recipes = [];

  List<Recipe> get recipes => _recipes;

  Future<void> getRecipes() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/recipes'),
    );
    _recipes = (response.body as List).map((e) => Recipe.fromJson(e)).toList();
    notifyListeners();
  }
}
