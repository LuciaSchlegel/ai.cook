import 'package:ai_cook_project/models/attribute_model.dart';
import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:ai_cook_project/models/event_model.dart';
import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:ai_cook_project/models/subscription_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';

enum UserRole { admin, user }

class User {
  final int id;
  final int uid;
  final String firstName;
  final String lastName;
  final String email;
  final String phone;
  final String? address;
  final String? profileImage;
  final String? bio;
  final UserRole role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final Subscription subscription;
  final List<Attribute> attributes;
  final List<UserIng> userIngredients;
  final List<CustomIngredient> customIngredients;
  final List<Recipe> recipes;
  final List<Event> events;

  User({
    required this.id,
    required this.uid,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.phone,
    this.address,
    this.profileImage,
    this.bio,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    required this.subscription,
    required this.attributes,
    required this.userIngredients,
    required this.customIngredients,
    required this.recipes,
    required this.events,
  });
}
