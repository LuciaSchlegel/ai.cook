import 'package:ai_cook_project/models/attribute_model.dart';
import 'package:ai_cook_project/models/custom_ing_model.dart';
import 'package:ai_cook_project/models/event_model.dart';
import 'package:ai_cook_project/models/recipe_model.dart';
import 'package:ai_cook_project/models/subscription_model.dart';
import 'package:ai_cook_project/models/user_ing.dart';

enum UserRole { admin, user }

class User {
  final int id;
  final String uid;
  final String name;
  final String email;
  final String? phone;
  final String gender;
  final DateTime? birthDate;
  final UserRole role;
  final Subscription? subscription;
  final List<Attribute>? attributes;
  final List<UserIng>? userIngredients;
  final List<CustomIngredient>? customIngredients;
  final List<Recipe>? recipes;
  final List<Event>? events;

  User({
    required this.id,
    required this.uid,
    required this.name,
    required this.email,
    this.phone,
    required this.gender,
    this.birthDate,
    required this.role,
    this.subscription,
    this.attributes,
    this.userIngredients,
    this.customIngredients,
    this.recipes,
    this.events,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      gender: json['gender'],
      birthDate:
          json['birthDate'] != null
              ? DateTime.tryParse(json['birthDate'])
              : null,
      role: UserRole.values.byName(json['role']),
      subscription:
          json['subscription'] != null
              ? Subscription.fromJson(json['subscription'])
              : null,
      attributes:
          (json['attributes'] as List<dynamic>?)
              ?.map((e) => Attribute.fromJson(e))
              .toList() ??
          [],
      userIngredients:
          (json['userIngredients'] as List<dynamic>?)
              ?.map((e) => UserIng.fromJson(e))
              .toList() ??
          [],
      customIngredients:
          (json['customIngredients'] as List<dynamic>?)
              ?.map((e) => CustomIngredient.fromJson(e))
              .toList() ??
          [],
      recipes:
          (json['recipes'] as List<dynamic>?)
              ?.map((e) => Recipe.fromJson(e))
              .toList() ??
          [],
      events:
          (json['events'] as List<dynamic>?)
              ?.map((e) => Event.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'uid': uid,
      'name': name,
      'email': email,
      'phone': phone,
      'gender': gender,
      'birthDate': birthDate?.toIso8601String(),
      'role': role.name,
      'subscription': subscription?.toJson(),
      'attributes': attributes?.map((e) => e.toJson()).toList(),
      'userIngredients': userIngredients?.map((e) => e.toJson()).toList(),
      'customIngredients': customIngredients?.map((e) => e.toJson()).toList(),
      'recipes': recipes?.map((e) => e.toJson()).toList(),
      'events': events?.map((e) => e.toJson()).toList(),
    };
  }
}
