class Validators {
  static bool isNonEmpty(String? value) =>
      value != null && value.trim().isNotEmpty;

  static bool hasMinLength(String? value, int min) =>
      value != null && value.trim().length >= min;

  static bool hasMaxLength(String? value, int max) =>
      value != null && value.trim().length <= max;

  static bool isEmail(String? value) {
    if (!isNonEmpty(value)) return false;
    final emailRegex = RegExp(r"^[\w.+\-]+@([\w\-]+\.)+[\w\-]{2,}$");
    return emailRegex.hasMatch(value!.trim());
  }

  static bool isPasswordStrong(String? value, {int minLength = 8}) {
    if (!hasMinLength(value, minLength)) return false;
    final v = value!;
    final hasUpper = v.contains(RegExp(r'[A-Z]'));
    final hasLower = v.contains(RegExp(r'[a-z]'));
    final hasDigit = v.contains(RegExp(r'[0-9]'));
    final hasSymbol = v.contains(
      RegExp(r'[!@#\$%^&*(),.?":{}|<>\-_=+\\/\[\];]'),
    );
    return hasUpper && hasLower && hasDigit && hasSymbol;
  }

  static bool isPhoneNumeric(String? value, {int min = 8, int max = 15}) {
    if (!isNonEmpty(value)) return false;
    final digits = value!.replaceAll(RegExp(r'\D'), '');
    return digits.length >= min && digits.length <= max;
  }

  static bool isPositiveInt(int? value) => value != null && value > 0;

  static bool isNonNegativeInt(int? value) => value != null && value >= 0;

  static bool isUrl(String? value) {
    if (!isNonEmpty(value)) return false;
    final uri = Uri.tryParse(value!.trim());
    return uri != null &&
        (uri.isScheme('http') || uri.isScheme('https')) &&
        uri.host.isNotEmpty;
  }
}
