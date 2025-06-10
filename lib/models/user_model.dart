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
  final String? address;
  final String? profileImage;
  final String? bio;
  final UserRole role;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isDeleted;
  final Subscription? subscription;
  final List<Attribute> attributes;
  final List<UserIng> userIngredients;
  final List<CustomIngredient> customIngredients;
  final List<Recipe> recipes;
  final List<Event> events;

  User({
    required this.id,
    required this.uid,
    required this.name,
    required this.email,
    this.phone,
    this.address,
    this.profileImage,
    this.bio,
    required this.role,
    required this.createdAt,
    required this.updatedAt,
    required this.isDeleted,
    this.subscription,
    required this.attributes,
    required this.userIngredients,
    required this.customIngredients,
    required this.recipes,
    required this.events,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      uid: json['uid'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'],
      address: json['address'],
      profileImage: json['profileImage'],
      bio: json['bio'],
      role: UserRole.values.byName(json['role']),
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      isDeleted: json['isDeleted'] ?? false,
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
      'address': address,
      'profileImage': profileImage,
      'bio': bio,
      'role': role.name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      'isDeleted': isDeleted,
      'subscription': subscription?.toJson(),
      'attributes': attributes.map((e) => e.toJson()).toList(),
      'userIngredients': userIngredients.map((e) => e.toJson()).toList(),
      'customIngredients': customIngredients.map((e) => e.toJson()).toList(),
      'recipes': recipes.map((e) => e.toJson()).toList(),
      'events': events.map((e) => e.toJson()).toList(),
    };
  }
}
