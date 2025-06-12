import 'dart:convert';
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
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/resources/units'),
        headers: {'Content-Type': 'application/json'},
      );
      final List<dynamic> decoded = json.decode(response.body);
      _units = decoded.map((e) => Unit.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching units: $e');
    }
  }

  Future<void> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/resources/categories'),
        headers: {'Content-Type': 'application/json'},
      );
      final List<dynamic> decoded = json.decode(response.body);
      _categories = decoded.map((e) => Category.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching categories: $e');
    }
  }

  Future<void> getTags() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/resources/tags'),
        headers: {'Content-Type': 'application/json'},
      );
      final List<dynamic> decoded = json.decode(response.body);
      _tags = decoded.map((e) => Tag.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching tags: $e');
    }
  }

  Future<void> getRecipeTags() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/resources/recipe_tags'),
        headers: {'Content-Type': 'application/json'},
      );
      final List<dynamic> decoded = json.decode(response.body);
      _recipeTags = decoded.map((e) => RecipeTag.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error fetching recipe tags: $e');
    }
  }
}
