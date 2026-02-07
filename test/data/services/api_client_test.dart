import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'package:re_serve/data/services/api_client.dart';

void main() async {
  TestWidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: '.env');
  final jwtToken = dotenv.get('JWT_TOKEN');
  final apiKey = dotenv.get("API_KEY");

  group('ApiClient', () {
    test('GET /api/v1/foods logs response', () async {
      HttpOverrides.global = _PermissiveHttpOverrides();

      final client = ApiClient.instance();
      client.rawDio.options.headers['Authorization'] = 'Bearer $jwtToken';
      client.rawDio.options.headers['apiKey'] = apiKey;

      final response = await client.get<Map<String, dynamic>>('/api/v1/foods');

      debugPrint(
        'GET /api/v1/foods -> status: ${response.statusCode}, data: ${response.data}',
      );

      expect(response.statusCode, 200);
      expect(response.data, isNotNull);
    });
  });
}

class _PermissiveHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    // Use the real HttpClient to allow outbound network calls in tests.
    return super.createHttpClient(context)
      ..badCertificateCallback = (cert, host, port) => true;
  }
}
