import 'package:equatable/equatable.dart';
import 'package:re_serve/data/models/payment_model.dart';
import 'package:re_serve/data/models/transaction_model.dart';

enum TransactionStatus { initial, loading, success, failure }

class TransactionState extends Equatable {
  final TransactionStatus status;
  final List<PaymentModel> paymentMethods;
  final List<TransactionModel> transactions;
  final bool transactionCreated;
  final String? errorMessage;

  const TransactionState({
    this.status = TransactionStatus.initial,
    this.paymentMethods = const [],
    this.transactions = const [],
    this.transactionCreated = false,
    this.errorMessage,
  });

  TransactionState copyWith({
    TransactionStatus? status,
    List<PaymentModel>? paymentMethods,
    List<TransactionModel>? transactions,
    bool? transactionCreated,
    String? errorMessage,
  }) {
    return TransactionState(
      status: status ?? this.status,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      transactions: transactions ?? this.transactions,
      transactionCreated: transactionCreated ?? false,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    paymentMethods,
    transactions,
    transactionCreated,
    errorMessage,
  ];
}
