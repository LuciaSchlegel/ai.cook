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
    'g': 1, // agregado para compatibilidad con backend
    'kg': 1000,
    'ml': 1,
    'l': 1000,
    'tsp': 5,
    'tbsp': 15,
    'cup': 240,
    'unit': 1, // Por defecto, 1 si no aplica
    'u': 1, // agregado para compatibilidad con backend
    'pcs': 1, // opcional, por si acaso
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
    final weightUnits = ['gr', 'g', 'kg'];
    final volumeUnits = ['ml', 'l', 'tsp', 'tbsp', 'cup'];
    final unitUnits = ['u', 'unit', 'pcs'];

    final thisAbbr = abbreviation.toLowerCase();
    final otherAbbr = other.abbreviation.toLowerCase();

    if (weightUnits.contains(thisAbbr) && weightUnits.contains(otherAbbr)) {
      return true;
    }
    if (volumeUnits.contains(thisAbbr) && volumeUnits.contains(otherAbbr)) {
      return true;
    }
    if (unitUnits.contains(thisAbbr) && unitUnits.contains(otherAbbr)) {
      return true;
    }
    // Otras comparaciones si hace falta
    return false;
  }
}
