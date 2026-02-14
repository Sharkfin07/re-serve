import '../models/transaction_model.dart';
import 'api_client.dart';
import 'auth_service.dart';

class TransactionService {
  TransactionService({ApiClient? client, AuthService? authService})
    : _client = client ?? ApiClient.instance(),
      _authService = authService ?? AuthService();

  final ApiClient _client;
  final AuthService _authService;

  Future<TransactionModel> getTransactionById(String transactionId) async {
    final options = await _authService.authorizedHeaders();
    final response = await _client.get<Map<String, dynamic>>(
      '/api/v1/transaction/$transactionId',
      options: options,
    );
    final data = response.data?['data'];
    if (data == null || data is! Map<String, dynamic>) {
      throw Exception('Transaction not found');
    }
    return TransactionModel.fromJson(data);
  }

  Future<List<TransactionModel>> getMyTransactions() async {
    final options = await _authService.authorizedHeaders();
    final response = await _client.get<Map<String, dynamic>>(
      '/api/v1/my-transactions',
      options: options,
    );
    final data = response.data?['data'];
    if (data == null || data is! List) {
      throw Exception('Transaction list not found');
    }
    return data
        .whereType<Map<String, dynamic>>()
        .map(TransactionModel.fromJson)
        .toList();
  }

  Future<List<TransactionModel>> getAllTransactions() async {
    final options = await _authService.authorizedHeaders();
    final response = await _client.get<Map<String, dynamic>>(
      '/api/v1/all-transactions',
      options: options,
    );
    final data = response.data?['data'];
    if (data == null || data is! List) {
      throw Exception('Transaction list not found');
    }
    return data
        .whereType<Map<String, dynamic>>()
        .map(TransactionModel.fromJson)
        .toList();
  }

  Future<TransactionModel> createTransaction({
    required List<String> cartIds,
    required String paymentMethodId,
  }) async {
    final options = await _authService.authorizedHeaders();
    final response = await _client.post<Map<String, dynamic>>(
      '/api/v1/create-transaction',
      data: {'cartIds': cartIds, 'paymentMethodId': paymentMethodId},
      options: options,
    );
    final data = response.data?['data'];
    if (data == null || data is! Map<String, dynamic>) {
      throw Exception('Failed to create transaction');
    }
    return TransactionModel.fromJson(data);
  }

  Future<void> cancelTransaction(String transactionId) async {
    final options = await _authService.authorizedHeaders();
    await _client.post(
      '/api/v1/cancel-transaction/$transactionId',
      options: options,
    );
  }

  Future<TransactionModel> updateProofPayment({
    required String transactionId,
    required String proofPaymentUrl,
  }) async {
    final options = await _authService.authorizedHeaders();
    final response = await _client.post<Map<String, dynamic>>(
      '/api/v1/update-transaction-proof-payment/$transactionId',
      data: {'proofPaymentUrl': proofPaymentUrl},
      options: options,
    );
    final data = response.data?['data'];
    if (data == null || data is! Map<String, dynamic>) {
      throw Exception('Failed to update transaction');
    }
    return TransactionModel.fromJson(data);
  }

  Future<TransactionModel> updateTransactionStatus({
    required String transactionId,
    required String status,
  }) async {
    final options = await _authService.authorizedHeaders();
    final response = await _client.post<Map<String, dynamic>>(
      '/api/v1/update-transaction-status/$transactionId',
      data: {'status': status},
      options: options,
    );
    final data = response.data?['data'];
    if (data == null || data is! Map<String, dynamic>) {
      throw Exception('Failed to update transaction status');
    }
    return TransactionModel.fromJson(data);
  }
}
