import 'dart:io';

import 'package:ai_cook_project/providers/user_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
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
  throw UnimplementedError('Google Sign-In temporalmente deshabilitado');
  
  /*
  final googleSignIn = GoogleSignIn();
  final googleUser = await googleSignIn.signIn();
  if (googleUser == null) return; // User canceled
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
  */
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
    Provider.of<UserProvider>(context, listen: false).clearUser();
    Provider.of<IngredientsProvider>(context, listen: false).clearAll();
    await clearUserCache();
  }

  Future<void> clearUserCache() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_ingredients');
    await prefs.remove('global_ingredients');
    await prefs.remove('cached_user');
  }
}