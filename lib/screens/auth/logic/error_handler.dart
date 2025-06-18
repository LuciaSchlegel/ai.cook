import 'package:firebase_auth/firebase_auth.dart';

class FirebaseErrorHandler {
  static String handleError(Object error) {
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-credential':
          return 'Invalid email or password.';
        case 'too-many-requests':
          return 'Too many requests. Please try again later.';
        case 'user-not-found':
          return 'No user found for the given email.';
        case 'operation-not-allowed':
          return 'Email/password sign-in is not enabled. Please contact support.';
        case 'user-disabled':
          return 'This user has been disabled. Please contact support.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        case 'email-already-in-use':
          return 'The email address is already in use by another account.';
        case 'weak-password':
          return 'The password provided is too weak. Please choose a stronger password.';
        case 'invalid-email':
          return 'The email address is not valid. Please enter a valid email address.';
        default:
          return 'An unknown error occurred. Please try again later.';
      }
    } else {
      return 'An unexpected error occurred: ${error.toString()}';
    }
  }
}
