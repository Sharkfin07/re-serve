import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../models/user_model.dart';

import 'api_client.dart';

class AuthService {
  AuthService({ApiClient? client, FlutterSecureStorage? storage})
    : _client = client ?? ApiClient.instance(),
      _storage = storage ?? const FlutterSecureStorage();

  static const _tokenKey = 'jwt_token';

  final ApiClient _client;
  final FlutterSecureStorage _storage;

  String get _apiKey => dotenv.env['API_KEY'] ?? '';

  Future<Map<String, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String passwordRepeat,
    required String role,
    String? profilePictureUrl,
    String? phoneNumber,
  }) async {
    final response = await _client.post<Map<String, dynamic>>(
      '/api/v1/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'passwordRepeat': passwordRepeat,
        'role': role,
        'profilePictureUrl': profilePictureUrl,
        'phoneNumber': phoneNumber,
      },
      options: Options(headers: {'apiKey': _apiKey}),
    );

    return response.data ?? <String, dynamic>{};
  }

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
      throw Exception('Token not found at login response');
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

  /// Helper function to attach headers (apiKey + Authorization if present)
  Future<Options> authorizedHeaders() async {
    final token = await getToken();
    return Options(
      headers: {
        'apiKey': _apiKey,
        if (token != null && token.isNotEmpty) 'Authorization': 'Bearer $token',
      },
    );
  }

  Future<UserModel> getCurrentUser() async {
    final options = await authorizedHeaders();
    final response = await _client.get<Map<String, dynamic>>(
      '/api/v1/user',
      options: options,
    );

    final data = response.data?['data'];
    if (data == null || data is! Map<String, dynamic>) {
      throw Exception('User data not found');
    }
    return UserModel.fromJson(data);
  }

  Future<List<UserModel>> getAllUsers() async {
    final options = await authorizedHeaders();
    final response = await _client.get<Map<String, dynamic>>(
      '/api/v1/all-user',
      options: options,
    );

    final data = response.data?['data'];
    if (data == null || data is! List) {
      throw Exception('User list not found');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(UserModel.fromJson)
        .toList();
  }

  Future<UserModel> updateProfile({
    required String name,
    required String email,
    String? profilePictureUrl,
    String? phoneNumber,
  }) async {
    final options = await authorizedHeaders();
    final response = await _client.post<Map<String, dynamic>>(
      '/api/v1/update-profile',
      data: {
        'name': name,
        'email': email,
        'profilePictureUrl': profilePictureUrl,
        'phoneNumber': phoneNumber,
      },
      options: options,
    );

    final data = response.data?['data'];
    if (data == null || data is! Map<String, dynamic>) {
      throw Exception('User data not found');
    }
    return UserModel.fromJson(data);
  }

  Future<UserModel> updateUserRole({
    required String userId,
    required String role,
  }) async {
    final options = await authorizedHeaders();
    final response = await _client.post<Map<String, dynamic>>(
      '/api/v1/update-user-role/$userId',
      data: {'role': role},
      options: options,
    );

    final data = response.data?['data'];
    if (data == null || data is! Map<String, dynamic>) {
      throw Exception('User data not found');
    }
    return UserModel.fromJson(data);
  }
}
