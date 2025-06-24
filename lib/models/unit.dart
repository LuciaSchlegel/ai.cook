class Unit {
  final int id;
  final String name;
  final String abbreviation;
  final String type;

  Unit({
    required this.id,
    required this.name,
    required this.abbreviation,
    required this.type,
  });

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      id: json['id'] as int? ?? -1,
      name: json['name']?.toString() ?? 'unit',
      abbreviation: json['abbreviation']?.toString() ?? 'u',
      type: json['type']?.toString() ?? 'other',
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'abbreviation': abbreviation,
    'type': type,
  };
}
