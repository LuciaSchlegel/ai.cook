class CustomIng {
  final int id;
  final String name;
  final String? category;
  final List<String>? tags;
  final int userId;
  final bool isDeleted;
  final bool isApproved;

  CustomIng({
    required this.id,
    required this.name,
    this.category,
    this.tags,
    required this.userId,
    required this.isDeleted,
    required this.isApproved,
  });

  factory CustomIng.fromJson(Map<String, dynamic> json) {
    return CustomIng(
      id: json['id'] as int,
      name: json['name'] as String,
      category: json['category'] as String?,
      tags: (json['tags'] as List<dynamic>?)?.map((e) => e as String).toList(),
      userId: json['user_id'] as int,
      isDeleted: json['is_deleted'] as bool,
      isApproved: json['is_approved'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'category': category,
      'tags': tags,
      'user_id': userId,
      'is_deleted': isDeleted,
      'is_approved': isApproved,
    };
  }
}
