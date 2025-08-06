import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/dietary_tag_model.dart';

class CustomIngredient {
  final int id;
  final String name;
  final Category? category;
  final bool isVegan;
  final bool isVegetarian;
  final bool isGlutenFree;
  final bool isLactoseFree;

  final String uid;

  CustomIngredient({
    required this.id,
    required this.name,
    this.category,
    required this.isVegan,
    required this.isVegetarian,
    required this.isGlutenFree,
    required this.isLactoseFree,
    required this.uid,
  });

  factory CustomIngredient.fromJson(Map<String, dynamic> json) {
    try {
      final rawUid = json['uid'] ?? json['createdBy']?['uid'] ?? '';
      return CustomIngredient(
        id: json['id'] as int,
        name: json['name']?.toString() ?? '',
        category:
            json['category'] != null
                ? Category.fromJson(json['category'] as Map<String, dynamic>)
                : null,
        isVegan: _parseBool(json['isVegan'] ?? json['is_vegan']),
        isVegetarian: _parseBool(json['isVegetarian'] ?? json['is_vegetarian']),
        isGlutenFree: _parseBool(
          json['isGlutenFree'] ?? json['is_gluten_free'],
        ),
        isLactoseFree: _parseBool(
          json['isLactoseFree'] ?? json['is_lactose_free'],
        ),
        uid: rawUid?.toString() ?? '',
      );
    } catch (e) {
      rethrow;
    }
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category?.toJson(),
      'isVegan': isVegan,
      'isVegetarian': isVegetarian,
      'isGlutenFree': isGlutenFree,
      'isLactoseFree': isLactoseFree,
      'uid': uid,
    };
  }

  CustomIngredient copyWith({
    int? id,
    String? name,
    Category? category,
    bool? isVegan,
    bool? isVegetarian,
    bool? isGlutenFree,
    bool? isLactoseFree,
    String? uid,
  }) {
    return CustomIngredient(
      id: id ?? this.id,
      name: name ?? this.name,
      category: category ?? this.category,
      isVegan: isVegan ?? this.isVegan,
      isVegetarian: isVegetarian ?? this.isVegetarian,
      isGlutenFree: isGlutenFree ?? this.isGlutenFree,
      isLactoseFree: isLactoseFree ?? this.isLactoseFree,
      uid: uid ?? this.uid,
    );
  }

  /// Helper method to parse boolean values from JSON
  static bool _parseBool(dynamic value) {
    if (value == null) return false;
    if (value is bool) return value;
    if (value is String) {
      return value.toLowerCase() == 'true' || value == '1';
    }
    if (value is int) return value == 1;
    return false;
  }

  List<DietaryTag> get dietaryTags {
    final tags = <DietaryTag>[];
    if (isVegan) tags.add(DietaryTag(id: 1, name: 'Vegan'));
    if (isVegetarian) tags.add(DietaryTag(id: 2, name: 'Vegetarian'));
    if (isGlutenFree) tags.add(DietaryTag(id: 3, name: 'Gluten-Free'));
    if (isLactoseFree) tags.add(DietaryTag(id: 4, name: 'Lactose-Free'));
    return tags;
  }

  static CustomIngredient fromTags({
    required int id,
    required String name,
    Category? category,
    required List<DietaryTag> tags,
    required String uid,
  }) {
    final tagNames = tags.map((t) => t.name.toLowerCase()).toSet();
    return CustomIngredient(
      id: id,
      name: name,
      category: category,
      isVegan: tagNames.contains('vegan'),
      isVegetarian: tagNames.contains('vegetarian'),
      isGlutenFree: tagNames.contains('gluten-free'),
      isLactoseFree: tagNames.contains('lactose-free'),
      uid: uid,
    );
  }
}
