class Attribute {
  final int id;
  final String key;
  final String value;
  final int userId;

  Attribute({
    required this.id,
    required this.key,
    required this.value,
    required this.userId,
  });

  factory Attribute.fromJson(Map<String, dynamic> json) {
    return Attribute(
      id: json['id'] as int,
      key: json['key'] as String, //podria ser un enum
      value: json['value'] as String,
      userId: json['user_id'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {'id': id, 'key': key, 'value': value, 'user_id': userId};
  }
}
