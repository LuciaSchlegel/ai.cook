import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'dart:convert';

class UserInfoResult {
  final bool success;
  final List<String>? validationErrors;
  final String? errorMessage;

  UserInfoResult.success()
    : success = true,
      validationErrors = null,
      errorMessage = null;
  UserInfoResult.validation(this.validationErrors)
    : success = false,
      errorMessage = null;
  UserInfoResult.error(this.errorMessage)
    : success = false,
      validationErrors = null;
}

class UserInfoService {
  final GlobalKey<FormState> formKey;
  final TextEditingController nameController;
  final DateTime? birthDate;
  final String? selectedGender;
  final String? email;
  final String? uid;

  UserInfoService({
    required this.formKey,
    required this.nameController,
    required this.birthDate,
    required this.selectedGender,
    required this.email,
    required this.uid,
  });

  Future<UserInfoResult> submitUserInfo() async {
    final bool isFormValid = formKey.currentState!.validate();
    final List<String> validationErrors = [];

    if (!isFormValid) {
      validationErrors.add('Enter your full name');
    }
    if (birthDate == null) {
      validationErrors.add('Select your date of birth');
    }
    if (selectedGender == null) {
      validationErrors.add('Select your gender');
    }

    if (validationErrors.isNotEmpty) {
      return UserInfoResult.validation(validationErrors);
    }

    if (email == null || email!.isEmpty) {
      validationErrors.add('Email is required');
    }
    if (uid == null || uid!.isEmpty) {
      validationErrors.add('User ID is missing. Please sign in again.');
    }

    try {
      final response = await http.post(
        Uri.parse('${dotenv.env['API_URL']}/user/sign_up'),
        body: {
          'name': nameController.text,
          'birthDate': birthDate!.toIso8601String(),
          'gender': selectedGender!,
          'email': email,
          'uid': uid,
        },
      );

      if (response.statusCode == 201) {
        return UserInfoResult.success();
      } else {
        try {
          final errorBody = json.decode(response.body);
          final msg =
              errorBody['error'] ??
              _getErrorMessageFromStatusCode(response.statusCode);
          return UserInfoResult.error(msg);
        } catch (_) {
          return UserInfoResult.error(
            _getErrorMessageFromStatusCode(response.statusCode),
          );
        }
      }
    } catch (e) {
      return UserInfoResult.error(
        'Unable to connect to the server. Please check your internet connection and try again.',
      );
    }
  }

  String _getErrorMessageFromStatusCode(int statusCode) {
    switch (statusCode) {
      case 400:
        return 'Invalid or incomplete data.';
      case 401:
        return 'Authentication failed.';
      case 409:
        return 'User already exists.';
      case 500:
        return 'Server error.';
      default:
        return 'Unexpected error occurred.';
    }
  }
}
