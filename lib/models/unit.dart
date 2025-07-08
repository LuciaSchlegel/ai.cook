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

  //mapa global de factores de conversión
  static const Map<String, double> _conversionFactors = {
    'gr': 1,
    'kg': 1000,
    'ml': 1,
    'l': 1000,
    'tsp': 5,
    'tbsp': 15,
    'cup': 240,
    'unit': 1, // Por defecto, 1 si no aplica
  };

  /// Convierte una cantidad en la unidad actual a una unidad base (gr o ml)
  double convertToBase(double quantity) {
    final factor = _conversionFactors[abbreviation.toLowerCase()];
    if (factor != null) {
      return quantity * factor;
    }
    throw Exception('No conversion factor found for $abbreviation');
  }

  /// Verifica si dos unidades son compatibles (por ejemplo, ambas de peso o volumen)
  bool isCompatibleWith(Unit other) {
    final weightUnits = ['gr', 'kg'];
    final volumeUnits = ['ml', 'l', 'tsp', 'tbsp', 'cup'];

    if (weightUnits.contains(abbreviation.toLowerCase()) &&
        weightUnits.contains(other.abbreviation.toLowerCase())) {
      return true;
    }
    if (volumeUnits.contains(abbreviation.toLowerCase()) &&
        volumeUnits.contains(other.abbreviation.toLowerCase())) {
      return true;
    }
    // Otras comparaciones si hace falta
    return false;
  }
}
