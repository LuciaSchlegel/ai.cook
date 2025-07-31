import 'dart:convert';
import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/recipe_tag_model.dart';
import 'package:ai_cook_project/models/tag_model.dart';
import 'package:ai_cook_project/models/unit.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ResourceProvider extends ChangeNotifier {
  bool _initialized = false;
  bool get isInitialized => _initialized;
  List<Unit> _units = [];
  List<Category> _categories = [];
  List<Tag> _tags = [];
  List<RecipeTag> _recipeTags = [];

  List<Unit> get units => _units;
  List<Category> get categories => _categories;
  List<Tag> get tags => _tags;
  List<RecipeTag> get recipeTags => _recipeTags;

  Future<void> initializeResources() async {
    if (_initialized) return;
    await Future.wait([
      getUnits(),
      getCategories(),
      getTags(),
      getRecipeTags(),
    ]);
    _initialized = true;
    notifyListeners();
  }

  Future<void> getUnits() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/resources/units'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to fetch units: HTTP ${response.statusCode}');
      }

      final List<dynamic> decoded = json.decode(response.body);
      _units = decoded.map((e) => Unit.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching units: $e');
    }
  }

  Future<void> getCategories() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/resources/categories'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch categories: HTTP ${response.statusCode}',
        );
      }

      final List<dynamic> decoded = json.decode(response.body);
      _categories = decoded.map((e) => Category.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching categories: $e');
    }
  }

  Future<void> getTags() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/resources/tags'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200) {
        throw Exception('Failed to fetch tags: HTTP ${response.statusCode}');
      }

      final List<dynamic> decoded = json.decode(response.body);
      _tags = decoded.map((e) => Tag.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {}
  }

  Future<void> getRecipeTags() async {
    try {
      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/resources/recipe_tags'),
        headers: {'Content-Type': 'application/json'},
      );
      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch recipe tags: HTTP ${response.statusCode}',
        );
      }

      final List<dynamic> decoded = json.decode(response.body);
      _recipeTags = decoded.map((e) => RecipeTag.fromJson(e)).toList();
      notifyListeners();
    } catch (e) {
      print('Error fetching recipe tags: $e');
    }
  }

  // Utility
  void clearAll() {
    _units = [];
    _categories = [];
    _tags = [];
    _recipeTags = [];
    _initialized = false;
    notifyListeners();
  }
}
