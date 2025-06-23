import 'dart:convert';
import 'package:ai_cook_project/models/user_ing.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class IngredientsRepo {
  static Future<List<UserIng>> fetchUserIngredients({
    required String uid,
    required Function(bool) setLoading,
    required Function(String) setError,
    required Function() clearError,
  }) async {
    try {
      setLoading(true);
      clearError();

      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/user/$uid/ingredients'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception(
          'Failed to fetch user ingredients: ${response.statusCode}',
        );
      }

      final decoded = json.decode(response.body);
      if (decoded is! List) throw Exception('Expected a list of ingredients');

      final List<UserIng> parsed =
          decoded
              .where((e) => e != null)
              .map((e) => UserIng.fromJson(e as Map<String, dynamic>))
              .toList();

      return parsed;
    } catch (e) {
      setError('Failed to fetch user ingredients: $e');
      return []; // o rethrow si preferís manejarlo arriba
    } finally {
      setLoading(false);
    }
  }

  static Future<UserIng?> addUserIngredient({
    required String uid,
    required UserIng userIngredient,
    required Function(bool) setLoading,
    required Function(String) setError,
    required Function() clearError,
  }) async {
    try {
      setLoading(true);
      clearError();

      final response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/user/$uid/ingredients'),
        body: json.encode(userIngredient.toJson()),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 201) {
        throw Exception('Failed to add ingredient: ${response.statusCode}');
      }

      final responseData = json.decode(response.body);
      if (responseData == null) {
        throw Exception('Received null response from server');
      }

      return UserIng.fromJson(responseData);
    } catch (e) {
      setError('Failed to add ingredient: $e');
      return null;
    } finally {
      setLoading(false);
    }
  }

  static Future<UserIng> updateUserIngredient({
    required String uid,
    required UserIng userIng,
  }) async {
    final url = Uri.parse('${dotenv.env['API_URL']}/user/$uid/ingredients');

    final response = await http.put(
      url,
      body: json.encode(userIng.toJson()),
      headers: {'Content-Type': 'application/json'},
    );

    if (response.statusCode != 200 && response.statusCode != 201) {
      throw Exception(
        'Failed to update ingredient: ${response.statusCode} - ${response.body}',
      );
    }

    final responseData = json.decode(response.body);
    if (responseData == null) {
      throw Exception('Received null response from server');
    }

    responseData['user'] ??= {'uid': uid};
    return UserIng.fromJson(responseData);
  }

  static Future<void> deleteUserIngredient({
    required String uid,
    required int ingredientId,
    required Function(bool) setLoading,
    required Function(String) setError,
    required Function() clearError,
  }) async {
    try {
      setLoading(true);
      clearError();

      final response = await http.delete(
        Uri.parse('${dotenv.env['API_URL']}/user/$uid/ingredients'),
        body: json.encode({'id': ingredientId}),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode != 200) {
        throw Exception('Failed to delete ingredient: ${response.statusCode}');
      }
    } catch (e) {
      setError('Failed to delete ingredient: $e');
    } finally {
      setLoading(false);
    }
  }
}
