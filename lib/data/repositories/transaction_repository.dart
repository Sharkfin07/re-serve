import '../models/transaction_model.dart';
import '../services/transaction_service.dart';

class TransactionRepository {
  TransactionRepository({TransactionService? service})
    : _service = service ?? TransactionService();

  final TransactionService _service;

  Future<TransactionModel> getTransactionById(String id) =>
      _service.getTransactionById(id);

  Future<List<TransactionModel>> getMyTransactions() =>
      _service.getMyTransactions();

  Future<List<TransactionModel>> getAllTransactions() =>
      _service.getAllTransactions();

  Future<TransactionModel> createTransaction({
    required List<String> cartIds,
    required String paymentMethodId,
  }) => _service.createTransaction(
    cartIds: cartIds,
    paymentMethodId: paymentMethodId,
  );

  Future<void> cancelTransaction(String transactionId) =>
      _service.cancelTransaction(transactionId);

  Future<TransactionModel> updateProofPayment({
    required String transactionId,
    required String proofPaymentUrl,
  }) => _service.updateProofPayment(
    transactionId: transactionId,
    proofPaymentUrl: proofPaymentUrl,
  );

  Future<TransactionModel> updateTransactionStatus({
    required String transactionId,
    required String status,
  }) => _service.updateTransactionStatus(
    transactionId: transactionId,
    status: status,
  );
}
