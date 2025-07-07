class FirebaseErrorHandler {
  static String handleError(Object error) {
    final message = error.toString().toLowerCase();

    if (message.contains('invalid-credential') ||
        message.contains('wrong-password')) {
      return 'Invalid email or password.';
    }
    if (message.contains('user-not-found')) {
      return 'No user found for the given email.';
    }
    if (message.contains('too-many-requests')) {
      return 'Too many requests. Please try again later.';
    }
    if (message.contains('user-disabled')) {
      return 'This user has been disabled. Please contact support.';
    }
    if (message.contains('email-already-in-use')) {
      return 'The email address is already in use by another account.';
    }
    if (message.contains('weak-password')) {
      return 'The password provided is too weak. Please choose a stronger password.';
    }
    if (message.contains('invalid-email')) {
      return 'The email address is not valid. Please enter a valid email address.';
    }
    if (message.contains('network-request-failed')) {
      return 'Network error. Please check your internet connection.';
    }

    // Fallback: muestra el mensaje original si no se reconoce
    return 'An unexpected error occurred: $message';
  }
}
