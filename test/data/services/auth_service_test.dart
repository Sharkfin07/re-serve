import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

import 'package:re_serve/data/services/api_client.dart';
import 'package:re_serve/data/services/auth_service.dart';

class MockApiClient extends Mock implements ApiClient {}

class MockSecureStorage extends Mock implements FlutterSecureStorage {}

void main() {
  late MockApiClient client;
  late MockSecureStorage storage;
  late AuthService auth;

  setUpAll(() {
    dotenv.loadFromString(envString: 'API_KEY=test-api-key');
    registerFallbackValue(Options());
  });

  setUp(() {
    client = MockApiClient();
    storage = MockSecureStorage();
    auth = AuthService(client: client, storage: storage);
  });

  group('login', () {
    test('store token when login is successful', () async {
      when(
        () => client.post<Map<String, dynamic>>(
          '/api/v1/login',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: {'token': 'jwt-123'},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/v1/login'),
        ),
      );

      when(
        () => storage.write(
          key: any(named: 'key'),
          value: any(named: 'value'),
        ),
      ).thenAnswer((_) async => Future.value());

      final token = await auth.login(email: 'a@b.com', password: 'secret');

      expect(token, 'jwt-123');
      verify(() => storage.write(key: 'jwt_token', value: 'jwt-123')).called(1);
    });

    test('error when no token is in the response', () async {
      when(
        () => client.post<Map<String, dynamic>>(
          '/api/v1/login',
          data: any(named: 'data'),
          options: any(named: 'options'),
        ),
      ).thenAnswer(
        (_) async => Response<Map<String, dynamic>>(
          data: {},
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/v1/login'),
        ),
      );

      expect(
        () => auth.login(email: 'a@b.com', password: 'secret'),
        throwsA(isA<Exception>()),
      );
    });
  });

  group('logout', () {
    test('logout and delete token', () async {
      when(
        () => storage.read(key: any(named: 'key')),
      ).thenAnswer((_) async => 'jwt-123');

      when(
        () => client.get('/api/v1/logout', options: any(named: 'options')),
      ).thenAnswer(
        (_) async => Response(
          statusCode: 200,
          requestOptions: RequestOptions(path: '/api/v1/logout'),
        ),
      );

      when(
        () => storage.delete(key: any(named: 'key')),
      ).thenAnswer((_) async => Future.value());

      await auth.logout();

      verify(
        () => client.get('/api/v1/logout', options: any(named: 'options')),
      ).called(1);
      verify(() => storage.delete(key: 'jwt_token')).called(1);
    });
  });
}
