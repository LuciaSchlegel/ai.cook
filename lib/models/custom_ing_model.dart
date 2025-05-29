class CustomIngredient {
  final int id;
  final String name;
  final String? category;
  final List<String>? tags;

  CustomIngredient({
    required this.id,
    required this.name,
    this.category,
    this.tags,
  });

  factory CustomIngredient.fromJson(Map<String, dynamic> json) {
    return CustomIngredient(
      id: json['id'],
      name: json['name'],
      category: json['category'],
      tags: json['tags'] != null ? List<String>.from(json['tags']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name, 'category': category, 'tags': tags};
  }
}
