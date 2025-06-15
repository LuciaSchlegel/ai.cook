import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/tag_model.dart';

class CustomIngredient {
  final String name;
  final Category? category;
  final List<Tag>? tags;
  final String uid;

  CustomIngredient({
    required this.name,
    this.category,
    this.tags,
    required this.uid,
  });

  factory CustomIngredient.fromJson(Map<String, dynamic> json) {
    return CustomIngredient(
      name: json['name'] as String,
      category:
          json['category'] != null ? Category.fromJson(json['category']) : null,
      tags:
          (json['tags'] as List<dynamic>?)
              ?.map((e) => Tag.fromJson(e))
              .toList(),
      uid: json['user']?['uid'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category?.toJson(),
      'tags': tags?.map((e) => e.toJson()).toList(),
      'user': {'uid': uid},
    };
  }
}
