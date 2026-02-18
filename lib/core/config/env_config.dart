import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static Future<void> load() => dotenv.load(fileName: '.env');

  static String get apiKey =>
      dotenv.env['API_KEY'] ?? (throw Exception('API_KEY missing'));
  static String get baseUrl =>
      dotenv.env['BASE_URL'] ?? (throw Exception('BASE_URL missing'));
}
