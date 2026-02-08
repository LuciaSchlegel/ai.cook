import 'package:flutter/foundation.dart';

/// Model for a single converted measurement
class ConvertedMeasurement {
  final String measurement;
  final String unitType;

  ConvertedMeasurement({
    required this.measurement,
    required this.unitType,
  });

  factory ConvertedMeasurement.fromJson(Map<String, dynamic> json) {
    return ConvertedMeasurement(
      measurement: json['measurement'] ?? '',
      unitType: json['unit_type'] ?? '',
    );
  }
}

/// Model for the full conversion result
class ConversionResult {
  final String original;
  final List<ConvertedMeasurement> conversions;
  final String tip;

  ConversionResult({
    required this.original,
    required this.conversions,
    required this.tip,
  });

  factory ConversionResult.fromJson(Map<String, dynamic> json) {
    return ConversionResult(
      original: json['original'] ?? '',
      conversions: (json['conversions'] as List?)
              ?.map((e) => ConvertedMeasurement.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
      tip: json['tip'] ?? '',
    );
  }
}

/// Pure Dart unit converter — no LLM needed for math
class UnitConverterService extends ChangeNotifier {
  ConversionResult? _result;
  bool _isLoading = false;
  String? _error;

  ConversionResult? get result => _result;
  bool get isLoading => _isLoading;
  String? get error => _error;
  bool get hasResult => _result != null;

  // Volume units → milliliters
  static const Map<String, double> _volumeToMl = {
    'tsp': 4.929, 'teaspoon': 4.929,
    'tbsp': 14.787, 'tablespoon': 14.787,
    'fl oz': 29.574,
    'cup': 236.588,
    'pint': 473.176, 'pt': 473.176,
    'quart': 946.353, 'qt': 946.353,
    'gallon': 3785.41, 'gal': 3785.41,
    'ml': 1.0, 'milliliter': 1.0,
    'dl': 100.0, 'deciliter': 100.0,
    'l': 1000.0, 'liter': 1000.0,
  };

  // Weight units → grams
  static const Map<String, double> _weightToGrams = {
    'g': 1.0, 'gram': 1.0, 'grams': 1.0,
    'kg': 1000.0, 'kilogram': 1000.0,
    'oz': 28.3495, 'ounce': 28.3495,
    'lb': 453.592, 'pound': 453.592,
    'mg': 0.001, 'milligram': 0.001,
  };

  // Common ingredient densities (g per ml) for cross-type conversion
  static const Map<String, double> _densities = {
    'water': 1.0, 'milk': 1.03, 'flour': 0.53,
    'sugar': 0.85, 'butter': 0.91, 'oil': 0.92,
    'honey': 1.42, 'salt': 1.22, 'rice': 0.85,
    'cocoa': 0.52, 'cream': 1.01, 'yogurt': 1.03,
  };

  // Display names for output
  static const Map<String, String> _volumeDisplay = {
    'tsp': 'teaspoons', 'tbsp': 'tablespoons', 'cup': 'cups',
    'ml': 'ml', 'l': 'liters', 'fl oz': 'fl oz',
  };

  static const Map<String, String> _weightDisplay = {
    'g': 'grams', 'kg': 'kilograms', 'oz': 'ounces', 'lb': 'pounds',
  };

  Future<void> convert({
    required String amount,
    required String fromUnit,
    String? toUnit,
    String? ingredient,
  }) async {
    if (amount.trim().isEmpty || fromUnit.trim().isEmpty) {
      _error = 'Please enter an amount and unit';
      notifyListeners();
      return;
    }

    _isLoading = true;
    _error = null;
    _result = null;
    notifyListeners();

    try {
      final value = double.tryParse(amount.trim());
      if (value == null || value <= 0) {
        throw FormatException('Invalid amount: $amount');
      }

      final normalized = fromUnit.trim().toLowerCase();
      final conversions = <ConvertedMeasurement>[];
      var tip = '';

      final isVolume = _volumeToMl.containsKey(normalized);
      final isWeight = _weightToGrams.containsKey(normalized);

      if (isVolume) {
        final ml = value * _volumeToMl[normalized]!;

        for (final entry in _volumeDisplay.entries) {
          if (entry.key == normalized) continue;
          final converted = ml / _volumeToMl[entry.key]!;
          if (converted >= 0.01 && converted <= 10000) {
            conversions.add(ConvertedMeasurement(
              measurement: '${_fmt(converted)} ${entry.value}',
              unitType: 'volume',
            ));
          }
        }

        // Cross-type conversion if ingredient density is known
        if (ingredient != null && ingredient.isNotEmpty) {
          final density = _densities[ingredient.toLowerCase()];
          if (density != null) {
            final grams = ml * density;
            conversions.add(ConvertedMeasurement(
              measurement: '${_fmt(grams)} grams',
              unitType: 'weight',
            ));
            tip = 'Weight conversion based on ${ingredient.toLowerCase()} density.';
          }
        }
      } else if (isWeight) {
        final grams = value * _weightToGrams[normalized]!;

        for (final entry in _weightDisplay.entries) {
          if (entry.key == normalized) continue;
          final converted = grams / _weightToGrams[entry.key]!;
          if (converted >= 0.01 && converted <= 10000) {
            conversions.add(ConvertedMeasurement(
              measurement: '${_fmt(converted)} ${entry.value}',
              unitType: 'weight',
            ));
          }
        }
      } else {
        throw FormatException('Unrecognized unit: $fromUnit');
      }

      if (tip.isEmpty) {
        tip = 'Conversions are approximate for cooking purposes.';
      }

      _result = ConversionResult(
        original: '$amount $fromUnit',
        conversions: conversions.take(4).toList(),
        tip: tip,
      );
    } catch (e) {
      _error = 'Conversion failed: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String _fmt(double value) {
    if (value == value.roundToDouble()) return value.round().toString();
    if (value < 0.1) return value.toStringAsFixed(3);
    return value.toStringAsFixed(2);
  }

  void clear() {
    _result = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
