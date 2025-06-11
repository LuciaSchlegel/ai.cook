class Unit {
  final String name;
  final String abbreviation;
  final String type;

  Unit({required this.name, required this.abbreviation, required this.type});

  factory Unit.fromJson(Map<String, dynamic> json) {
    return Unit(
      name: json['name'],
      abbreviation: json['abbreviation'],
      type: json['type'],
    );
  }

  Map<String, dynamic> toJson() => {
    'name': name,
    'abbreviation': abbreviation,
    'type': type,
  };
}
