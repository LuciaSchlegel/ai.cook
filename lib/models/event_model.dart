import 'package:ai_cook_project/models/recipe_model.dart';

class Event {
  final int id;
  final int userId;
  final String title;
  final DateTime eventDate;
  final List<Recipe> recipes;
  final DateTime createdAt;

  Event({
    required this.id,
    required this.userId,
    required this.title,
    required this.eventDate,
    required this.recipes,
    required this.createdAt,
  });
}
