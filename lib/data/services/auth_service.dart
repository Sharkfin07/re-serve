import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'api_client.dart';

class AuthService {
  AuthService({ApiClient? client, FlutterSecureStorage? storage})
    : _client = client ?? ApiClient.instance(),
      _storage = storage ?? const FlutterSecureStorage();

  static const _tokenKey = 'jwt_token';

  final ApiClient _client;
  final FlutterSecureStorage _storage;

  String get _apiKey => dotenv.env['API_KEY'] ?? '';

  Future<String> login({
    required String email,
    required String password,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/api/v1/login',
      data: {'email': email, 'password': password},
      options: Options(headers: {'apiKey': _apiKey}),
    );

    final body = response.data ?? {};
    final token = body['token'] ?? body['data']?['token'];
    if (token == null || token is! String || token.isEmpty) {
      throw Exception('Token tidak ditemukan pada respons login');
    }

    await _storage.write(key: _tokenKey, value: token);
    return token;
  }

  Future<void> logout() async {
    final token = await getToken();
    try {
      if (token != null && token.isNotEmpty) {
        await _client.get(
          '/api/v1/logout',
          options: Options(
            headers: {'apiKey': _apiKey, 'Authorization': 'Bearer $token'},
          ),
        );
      }
    } finally {
      await _storage.delete(key: _tokenKey);
    }
  }

  Future<String?> getToken() => _storage.read(key: _tokenKey);

  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null && token.isNotEmpty;
  }

  /// Helper function to attach a header for requests that need authorization
  Future<Options> authorizedHeaders() async {
    final token = await getToken();
    return Options(
      headers: {
        'apiKey': _apiKey,
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );
  }
}
