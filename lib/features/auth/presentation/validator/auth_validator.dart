class AuthValidator {
  static String? isNameValid(String? text) {
    if (text != null && text.isNotEmpty) {
      return null;
    } else {
      return "User name in not valid";
    }
  }

  static String? isEmailValid(String? text) {
    if (text != null && text.contains("@") && text.contains(".")) {
      return null;
    } else {
      return "Email in not valid";
    }
  }

  static String? isPasswordValid(String? text) {
    if (text != null && text.contains(RegExp(r"[a-z]{3}[0-9]{3}"))) {
      return null;
    } else {
      return "Password in not valid";
    }
  }
}
