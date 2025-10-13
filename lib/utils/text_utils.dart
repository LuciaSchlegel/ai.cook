/// Utility functions for text manipulation
class TextUtils {
  /// Capitalizes the first letter of a string
  /// Example: "hello world" -> "Hello world"
  static String capitalizeFirstLetter(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1);
  }

  /// Capitalizes the first letter of each word
  /// Example: "hello world" -> "Hello World"
  static String capitalizeWords(String text) {
    if (text.isEmpty) return text;
    return text.split(' ').map((word) => capitalizeFirstLetter(word)).join(' ');
  }

  /// Converts text to title case (capitalizes first letter, rest lowercase)
  /// Example: "HELLO WORLD" -> "Hello world"
  static String toTitleCase(String text) {
    if (text.isEmpty) return text;
    return capitalizeFirstLetter(text.toLowerCase());
  }

  static String emailCannotBeEmpty = 'Email cannot be empty';
  static String invalidEmailFormat = 'Invalid email format';
  static String passwordCannotBeEmpty = 'Password cannot be empty';
  static String passwordMustBeAtLeast6CharactersLong =
      'Password must be at least 6 characters long';
}
