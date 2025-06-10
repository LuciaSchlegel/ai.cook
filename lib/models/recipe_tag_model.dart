class RecipeTag {
  final int id;
  final String name;

  RecipeTag({required this.id, required this.name});

  factory RecipeTag.fromJson(Map<String, dynamic> json) {
    return RecipeTag(id: json['id'], name: json['name']);
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }
}
