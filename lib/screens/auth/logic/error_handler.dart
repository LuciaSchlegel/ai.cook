import 'package:firebase_auth/firebase_auth.dart';

class FirebaseErrorHandler {
  static String handleError(Object error) {
    // Si es FirebaseAuthException, chequea el code
    if (error is FirebaseAuthException) {
      switch (error.code) {
        case 'invalid-credential':
        case 'wrong-password':
          return 'Invalid email or password.';
        case 'user-not-found':
          return 'No user found for the given email.';
        case 'too-many-requests':
          return 'Too many requests. Please try again later.';
        case 'user-disabled':
          return 'This user has been disabled. Please contact support.';
        case 'email-already-in-use':
          return 'The email address is already in use by another account.';
        case 'weak-password':
          return 'The password provided is too weak. Please choose a stronger password.';
        case 'invalid-email':
          return 'The email address is not valid. Please enter a valid email address.';
        case 'network-request-failed':
          return 'Network error. Please check your internet connection.';
        default:
          return 'An unknown error occurred. Please try again later.';
      }
    }

    // Fallback: busca en el mensaje por si el error no es FirebaseAuthException
    final message = error.toString();
    if (message.contains('invalid-credential') ||
        message.contains('wrong-password')) {
      return 'Invalid email or password.';
    }
    if (message.contains('network-request-failed')) {
      return 'Network error. Please check your internet connection.';
    }

    return 'An unexpected error occurred: $message';
  }
}
