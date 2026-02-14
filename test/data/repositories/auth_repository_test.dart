import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:re_serve/data/models/user_model.dart';
import 'package:re_serve/data/repositories/auth_repository.dart';
import 'package:re_serve/data/services/api_client.dart';
import 'package:re_serve/data/services/auth_service.dart';

class MockAuthService extends Mock implements AuthService {}

class MockApiClient extends Mock implements ApiClient {}

void main() {
  late MockAuthService authService;
  late MockApiClient apiClient;
  late AuthRepository repository;

  setUp(() {
    authService = MockAuthService();
    apiClient = MockApiClient();
    repository = AuthRepository(authService: authService, apiClient: apiClient);
    registerFallbackValue(Options());
  });

  test('fetchCurrentUser memetakan response ke UserModel yang benar', () async {
    when(
      () => authService.authorizedHeaders(),
    ).thenAnswer((_) async => Options(headers: {}));

    final userJson = {
      'id': '123',
      'name': 'John Doe',
      'email': 'john@example.com',
      'role': 'user',
      'profilePictureUrl': 'http://example.com/avatar.png',
      'phoneNumber': '08123456789',
    };

    when(
      () => apiClient.get<Map<String, dynamic>>(
        '/api/v1/user',
        options: any(named: 'options'),
      ),
    ).thenAnswer(
      (_) async => Response<Map<String, dynamic>>(
        data: {'data': userJson},
        statusCode: 200,
        requestOptions: RequestOptions(path: '/api/v1/user'),
      ),
    );

    final user = await repository.fetchCurrentUser();

    // Log user details
    if (kDebugMode) {
      print(
        'Fetched user => id: ${user.id}, name: ${user.name}, email: ${user.email}, role: ${user.role}, profile: ${user.profilePictureUrl}, phone: ${user.phoneNumber}',
      );
    }

    expect(user, isA<UserModel>());
    expect(user.id, userJson['id']);
    expect(user.name, userJson['name']);
    expect(user.email, userJson['email']);
    expect(user.role, userJson['role']);
    expect(user.profilePictureUrl, userJson['profilePictureUrl']);
    expect(user.phoneNumber, userJson['phoneNumber']);
  });
}
