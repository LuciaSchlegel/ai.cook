class UserIng {
  final int id;
  final int userId;
  final int? ingredientId;
  final int? customIngId;
  final int quantity;
  final String? unit;

  UserIng({
    required this.id,
    required this.userId,
    this.ingredientId,
    this.customIngId,
    required this.quantity,
    this.unit,
  });

  factory UserIng.fromJson(Map<String, dynamic> json) {
    return UserIng(
      id: json['id'],
      userId: json['user_id'],
      ingredientId: json['ingredient_id'],
      customIngId: json['custom_ing_id'],
      quantity: json['quantity'],
      unit: json['unit'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'ingredient_id': ingredientId,
      'custom_ing_id': customIngId,
      'quantity': quantity,
      'unit': unit,
    };
  }
}
