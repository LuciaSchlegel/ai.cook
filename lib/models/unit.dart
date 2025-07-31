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
    // Weight units (base: grams)
    'gr': 1,
    'g': 1, // agregado para compatibilidad con backend
    'gram': 1,
    'grams': 1,
    'kg': 1000,
    'kilogram': 1000,
    'kilograms': 1000,

    // Volume units (base: milliliters)
    'ml': 1,
    'milliliter': 1,
    'milliliters': 1,
    'l': 1000,
    'liter': 1000,
    'liters': 1000,
    'tsp': 5,
    'teaspoon': 5,
    'tbsp': 15,
    'tablespoon': 15,
    'cup': 240,
    'cups': 240,

    // Count units (base: pieces)
    'unit': 1,
    'u': 1, // agregado para compatibilidad con backend
    'pcs': 1,
    'piece': 1,
    'pieces': 1,
    'pc': 1,
    'each': 1,
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
    // First try to use the type field if both units have meaningful types
    if (_areTypesCompatible(type, other.type)) {
      return true;
    }

    // Fallback to abbreviation-based compatibility for legacy support
    final weightUnits = ['gr', 'g', 'kg'];
    final volumeUnits = ['ml', 'l', 'tsp', 'tbsp', 'cup'];
    final unitUnits = ['u', 'unit', 'pcs', 'piece', 'pieces'];

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

    return false;
  }

  /// Helper method to check type-based compatibility
  bool _areTypesCompatible(String type1, String type2) {
    if (type1.isEmpty ||
        type2.isEmpty ||
        type1 == 'other' ||
        type2 == 'other') {
      return false;
    }

    final type1Lower = type1.toLowerCase();
    final type2Lower = type2.toLowerCase();

    // Weight types
    if (type1Lower == 'weight' && type2Lower == 'weight') return true;

    // Volume types
    if (type1Lower == 'volume' && type2Lower == 'volume') return true;

    // Count/Quantitative types (server uses 'quantitative', client might use 'count')
    final countTypes = ['count', 'quantitative', 'quantity', 'unit'];
    if (countTypes.contains(type1Lower) && countTypes.contains(type2Lower)) {
      return true;
    }

    return false;
  }
}
