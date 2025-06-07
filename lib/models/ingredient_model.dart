class Ingredient {
  final int id;
  final String name;
  final String? category;
  final List<String>? tags;
  final List<dynamic> recipes;
  Ingredient({
    required this.id,
    required this.name,
    this.category,
    this.tags,
    this.recipes = const [],
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) {
    return Ingredient(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
      recipes: json['recipes'] ?? [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'tags': tags,
      'recipes': recipes,
    };
  }
}
