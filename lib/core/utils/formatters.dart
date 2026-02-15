import 'package:intl/intl.dart';

class Formatters {
  static String currency(
    num value, {
    String locale = 'id_ID',
    String symbol = 'Rp',
    int decimalDigits = 0,
  }) {
    final formatter = NumberFormat.currency(
      locale: locale,
      symbol: symbol,
      decimalDigits: decimalDigits,
    );
    return formatter.format(value);
  }

  static String date(
    DateTime value, {
    String locale = 'id_ID',
    String pattern = 'dd MMM yyyy',
  }) {
    final formatter = DateFormat(pattern, locale);
    return formatter.format(value);
  }

  static String dateTime(
    DateTime value, {
    String locale = 'id_ID',
    String pattern = 'dd MMM yyyy HH:mm',
  }) {
    final formatter = DateFormat(pattern, locale);
    return formatter.format(value);
  }

  static String normalizeWhitespace(String input) {
    return input.trim().replaceAll(RegExp(r'\s+'), ' ');
  }

  // Removes non-digit chars (useful for e.g. phone number)
  static String digitsOnly(String input) => input.replaceAll(RegExp(r'\D'), '');

  // keep digits, optionally prefix countryCode if absent.
  static String phone(String input, {String countryCode = '+62'}) {
    final digits = digitsOnly(input);
    if (digits.isEmpty) return '';
    if (digits.startsWith(countryCode.replaceAll('+', ''))) {
      return '+$digits';
    }
    if (digits.startsWith('0')) {
      return countryCode + digits.substring(1);
    }
    return countryCode + digits;
  }
} // lapar euy
