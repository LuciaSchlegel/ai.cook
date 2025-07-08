// test/ext_recipes_provider_test.dart
import 'package:ai_cook_project/providers/api_rec_provider.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/mockito.dart';
import 'dart:convert';

// Generar el mock
@GenerateMocks([http.Client])
import 'ext_rec_prov_test.mocks.dart'; // Si no existe, genera con build_runner

void main() {
  group('ExtRecipesProvider', () {
    late ExtRecipesProvider provider;
    late MockClient mockClient;

    setUp(() {
      mockClient = MockClient();
      provider = ExtRecipesProvider(client: mockClient);
    });

    test('fetches recipes successfully and updates state', () async {
      final fakeJson = jsonEncode({
        "results": [
          {
            "id": 1,
            "title": "Fake Recipe",
            "image": "https://example.com/image.jpg",
            "readyInMinutes": 10,
            "servings": 2,
            "cuisines": ["Italian"],
            "dishTypes": ["main course"],
            "diets": ["vegetarian"],
            "extendedIngredients": [
              {
                "id": 100,
                "name": "Tomato",
                "original": "1 tomato",
                "amount": 1.0,
                "unit": "piece",
              },
            ],
          },
        ],
      });
      when(mockClient.get(any, headers: captureAnyNamed('headers'))).thenAnswer(
        (invocation) async {
          return http.Response(fakeJson, 200);
        },
      );

      await provider.getRecipes();

      expect(provider.extRecipes.length, greaterThan(0));
      expect(provider.extRecipes.first.title, equals("Fake Recipe"));
      expect(provider.error, isNull);
    });
  });
}
