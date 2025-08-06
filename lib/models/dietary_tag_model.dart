class DietaryTag {
  final int id;
  final String name;

  DietaryTag({required this.id, required this.name});
  factory DietaryTag.fromJson(Map<String, dynamic> json) {
    return DietaryTag(
      id: json['id'] as int,
      name: json['name']?.toString() ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'name': name};
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is DietaryTag && other.id == id && other.name == name;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode;
}
