import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/recipe_tag_model.dart';
import 'package:ai_cook_project/models/tag_model.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ResourceProvider extends ChangeNotifier {
  List<Unit> _units = [];
  List<Category> _categories = [];
  List<Tag> _tags = [];
  List<RecipeTag> _recipeTags = [];

  List<Unit> get units => _units;
  List<Category> get categories => _categories;
  List<Tag> get tags => _tags;
  List<RecipeTag> get recipeTags => _recipeTags;
  Future<void> getUnits() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/resources/units'),
    );
    _units = (response.body as List).map((e) => Unit.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> getCategories() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/resources/categories'),
    );
    _categories =
        (response.body as List).map((e) => Category.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> getTags() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/resources/tags'),
    );
    _tags = (response.body as List).map((e) => Tag.fromJson(e)).toList();
    notifyListeners();
  }

  Future<void> getRecipeTags() async {
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/resources/recipe_tags'),
    );
    _recipeTags =
        (response.body as List).map((e) => RecipeTag.fromJson(e)).toList();
    notifyListeners();
  }
}
