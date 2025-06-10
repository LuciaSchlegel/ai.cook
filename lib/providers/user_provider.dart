import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ai_cook_project/models/user_model.dart' as user_model;

class UserProvider with ChangeNotifier {
  user_model.User? user;

  Future<void> getUser() async {
    final String? uid = FirebaseAuth.instance.currentUser?.uid;
    final response = await http.get(
      Uri.parse('${dotenv.env['API_URL']}/user/$uid'),
    );
    if (response.statusCode == 200) {
      user = user_model.User.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to load user');
    }
  }

  UserProvider() {
    getUser();
  }
}
