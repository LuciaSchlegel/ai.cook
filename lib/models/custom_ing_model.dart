import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/tag_model.dart';

class CustomIngredient {
  final int id;
  final String name;
  final Category? category;
  final List<Tag>? tags;

  CustomIngredient({
    required this.id,
    required this.name,
    this.category,
    this.tags,
  });

  factory CustomIngredient.fromJson(Map<String, dynamic> json) {
    return CustomIngredient(
      id: json['id'] as int,
      name: json['name'] as String,
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      tags:
          (json['tags'] as List<dynamic>?)
              ?.map((e) => Tag.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category?.toJson(),
      'tags': tags?.map((e) => e.toJson()).toList(),
    };
  }
}
