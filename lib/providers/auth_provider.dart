import 'dart:io';

import 'package:ai_cook_project/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:provider/provider.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';
import 'package:ai_cook_project/providers/ingredients_provider.dart';
import 'package:ai_cook_project/utils/ingredients_cache.dart';
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
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if (googleUser == null) return; // El usuario canceló el inicio de sesión

    final googleAuth = await googleUser.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    try {
      await _auth.signInWithCredential(credential);
    } on FirebaseAuthException {
      rethrow;
    }
  }

  Future<void> signInWithApple() async {
    if (!Platform.isIOS) return;

    final appleCredential = await SignInWithApple.getAppleIDCredential(
      scopes: [AppleIDAuthorizationScopes.email],
    );

    final oauthCredential = OAuthProvider("apple.com").credential(
      accessToken: appleCredential.authorizationCode,
      idToken: appleCredential.identityToken,
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
    Provider.of<UserProvider>(context, listen: false).clearUser();
    Provider.of<IngredientsProvider>(context, listen: false).clearAll();
    await clearUserCache();
  }

  Future<void> clearUserCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_ingredients');
    await prefs.remove('global_ingredients');
    await prefs.remove('cached_user');
    // Agrega aquí cualquier otra clave relevante
  }
}
