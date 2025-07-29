import 'dart:io';
import 'package:ai_cook_project/providers/user_provider.dart';
import 'package:ai_cook_project/providers/resource_provider.dart';
import 'package:ai_cook_project/providers/recipes_provider.dart';
import 'package:ai_cook_project/providers/search_provider.dart';
import 'package:ai_cook_project/providers/ai_recommendations_provider.dart';
import 'package:ai_cook_project/providers/api_rec_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FBAuthProvider with ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  User? user;

  FBAuthProvider() {
    _auth.authStateChanges().listen((u) {
      user = u;
      notifyListeners();
    });
  }

  bool get isAuth => user != null;

  Future<void> signInWithGoogle() async {
    // Comentar temporalmente para pruebas
    // throw UnimplementedError('Google Sign-In temporalmente deshabilitado');

    try {
      // Inicializar GoogleSignIn si no se ha hecho antes
      await GoogleSignIn.instance.initialize();

      // Autenticar con Google
      final googleUser =
          await GoogleSignIn.instance.authenticate(); // User canceled

      // Obtener tokens de autorización
      final authClient = googleUser.authorizationClient;
      final auth = await authClient.authorizeScopes(['email', 'profile']);

      final credential = GoogleAuthProvider.credential(
        accessToken: auth.accessToken,
        idToken: googleUser.authentication.idToken,
      );

      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signInWithApple() async {
    if (!Platform.isIOS) return;

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [
        AppleIDAuthorizationScopes.email,
        AppleIDAuthorizationScopes.fullName,
      ],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      idToken: appleCredential.identityToken,
      accessToken: appleCredential.authorizationCode,
    );

    try {
      await _auth.signInWithCredential(oauthCredential);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signInWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.signInWithEmailAndPassword(email: email, password: password);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signUpWithEmailAndPassword(String email, String password) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> resetPassword(String email) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signOut(BuildContext context) async {
    await _auth.signOut();

    // Clear all providers with user-specific data
    Provider.of<UserProvider>(context, listen: false).clearUser();
    Provider.of<IngredientsProvider>(context, listen: false).clearAll();
    Provider.of<ResourceProvider>(context, listen: false).clearAll();
    Provider.of<RecipesProvider>(context, listen: false).clearAll();
    Provider.of<SearchProvider>(context, listen: false).clearAll();
    Provider.of<AIRecommendationsProvider>(context, listen: false).clearAll();
    Provider.of<ExtRecipesProvider>(context, listen: false).clearAll();

    await clearUserCache();
  }

  Future<void> clearUserCache() async {
    final prefs = await SharedPreferences.getInstance();

    // Clear all user-specific cache keys
    await prefs.remove('user_ingredients');
    await prefs.remove('global_ingredients');
    await prefs.remove('cached_user');

    // Clear any other potential cache keys (be more comprehensive)
    final keys = prefs.getKeys();
    final userSpecificKeys =
        keys
            .where(
              (key) =>
                  key.contains('user_') ||
                  key.contains('ingredients') ||
                  key.contains('recipes') ||
                  key.contains('recommendations'),
            )
            .toList();

    for (final key in userSpecificKeys) {
      await prefs.remove(key);
    }
  }
}
