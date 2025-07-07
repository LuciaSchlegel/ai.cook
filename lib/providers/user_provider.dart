import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ai_cook_project/models/user_model.dart' as user_model;

class UserProvider with ChangeNotifier {
  user_model.User? _user;
  String? _error;
  bool _isLoading = false;
  bool _hasFetched = false;

  user_model.User? get user => _user;
  String? get error => _error;
  bool get isLoading => _isLoading;

  static const _userKey = 'cached_user';

  Future<void> getUser() async {
    if (_hasFetched) return;
    _hasFetched = true;

    _setLoading(true);
    _clearError();

    final prefs = await SharedPreferences.getInstance();
    if (prefs.containsKey(_userKey)) {
      try {
        final cachedJson = prefs.getString(_userKey);
        if (cachedJson != null) {
          final decoded = json.decode(cachedJson);
          _user = user_model.User.fromJson(decoded);
          notifyListeners();
        }
      } catch (e) {}
    }
    try {
      final String? uid = FirebaseAuth.instance.currentUser?.uid;
      if (uid == null) {
        _setError('No user logged in.');
        return;
      }

      final response = await http.get(
        Uri.parse('${dotenv.env['API_URL']}/user/$uid'),
        headers: {'Content-Type': 'application/json'},
      );

      if (response.statusCode == 200) {
        final decoded = json.decode(response.body);
        _user = user_model.User.fromJson(decoded);
        await prefs.setString(_userKey, json.encode(decoded));

        notifyListeners();
      } else {
        _setError('Failed to load user. Status: ${response.statusCode}');
      }
    } catch (e) {
      _setError('Error fetching user: $e');
    } finally {
      _setLoading(false);
    }
  }

  void clearUser() async {
    _user = null;
    _error = null;
    _hasFetched = false;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userKey);
  }

  void _setLoading(bool value) {
    if (_isLoading != value) {
      _isLoading = value;
      notifyListeners();
    }
  }

  void _setError(String error) {
    _error = error;
    notifyListeners();
  }

  void _clearError() {
    _error = null;
  }
}
