import 'package:ai_cook_project/utils/text_utils.dart';

TextUtils textUtils = TextUtils();

class FieldValidator {
  static String? validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return TextUtils.emailCannotBeEmpty;
    }
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+$');
    if (!emailRegex.hasMatch(value)) {
      return TextUtils.invalidEmailFormat;
    }
    return null;
  }

  static String? validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return TextUtils.passwordCannotBeEmpty;
    }
    if (value.length < 6) {
      return TextUtils.passwordMustBeAtLeast6CharactersLong;
    }
    return null;
  }
}
