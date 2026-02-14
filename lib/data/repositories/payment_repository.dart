import '../models/payment_model.dart';
import '../services/payment_service.dart';

class PaymentRepository {
  PaymentRepository({PaymentService? service})
    : _service = service ?? PaymentService();

  final PaymentService _service;

  Future<List<PaymentModel>> getPaymentMethods() =>
      _service.getPaymentMethods();

  Future<List<PaymentModel>> generatePaymentMethods() =>
      _service.generatePaymentMethods();
}
