import 'package:ai_cook_project/models/recipe_model.dart';

class Event {
  final int id;
  final String uid;
  final String title;
  final DateTime eventDate;
  final List<Recipe> recipes;
  final DateTime createdAt;

  Event({
    required this.id,
    required this.uid,
    required this.title,
    required this.eventDate,
    required this.recipes,
    required this.createdAt,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] as int,
      uid: json['uid'] as String,
      title: json['title'] as String,
      eventDate: DateTime.parse(json['eventDate']),
      recipes:
          (json['recipes'] as List<dynamic>?)
              ?.map((e) => Recipe.fromJson(e))
              .toList() ??
          [],
      createdAt: DateTime.parse(json['createdAt']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'title': title,
      'eventDate': eventDate.toIso8601String(),
      'recipes': recipes.map((e) => e.toJson()).toList(),
      'createdAt': createdAt.toIso8601String(),
    };
  }
}
