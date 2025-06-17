import 'package:ai_cook_project/models/category_model.dart';
import 'package:ai_cook_project/models/tag_model.dart';

class CustomIngredient {
  final int id;
  final String name;
  final Category? category;
  final List<Tag>? tags;
  final String uid;

  CustomIngredient({
    required this.id,
    required this.name,
    this.category,
    this.tags,
    required this.uid,
  });

  factory CustomIngredient.fromJson(Map<String, dynamic> json) {
    try {
      return CustomIngredient(
        id: json['id'] as int,
        name: json['name']?.toString() ?? '',
        category:
            json['category'] != null
                ? Category.fromJson(json['category'] as Map<String, dynamic>)
                : null,
        tags:
            (json['tags'] as List<dynamic>?)
                ?.map((tag) => Tag.fromJson(tag as Map<String, dynamic>))
                .toList(),
        uid:
            json['uid']?.toString() ??
            json['createdBy']?['uid']?.toString() ??
            '',
      );
    } catch (e) {
      print('Error parsing CustomIngredient: $e');
      print('JSON data: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category?.toJson(),
      'tags': tags?.map((tag) => tag.toJson()).toList(),
      'uid': uid,
    };
  }
}
