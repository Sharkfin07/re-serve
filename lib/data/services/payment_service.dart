import '../models/payment_model.dart';
import 'api_client.dart';
import 'auth_service.dart';

class PaymentService {
  PaymentService({ApiClient? client, AuthService? authService})
    : _client = client ?? ApiClient.instance(),
      _authService = authService ?? AuthService();

  final ApiClient _client;
  final AuthService _authService;

  Future<List<PaymentModel>> getPaymentMethods() async {
    final options = await _authService.authorizedHeaders();
    final response = await _client.get<Map<String, dynamic>>(
      '/api/v1/payment-methods',
      options: options,
    );

    final data = response.data?['data'];
    if (data == null || data is! List) {
      throw Exception('Payment methods not found');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(PaymentModel.fromJson)
        .toList();
  }

  Future<List<PaymentModel>> generatePaymentMethods() async {
    final options = await _authService.authorizedHeaders();
    final response = await _client.post<Map<String, dynamic>>(
      '/api/v1/generate-payment-methods',
      options: options,
    );

    final data = response.data?['data'];
    if (data == null || data is! List) {
      throw Exception('Failed to generate payment methods');
    }

    return data
        .whereType<Map<String, dynamic>>()
        .map(PaymentModel.fromJson)
        .toList();
  }
}
