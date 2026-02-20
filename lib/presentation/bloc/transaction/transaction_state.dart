import 'package:equatable/equatable.dart';
import 'package:re_serve/data/models/payment_model.dart';
import 'package:re_serve/data/models/transaction_model.dart';

enum TransactionStatus { initial, loading, success, failure }

class TransactionState extends Equatable {
  final TransactionStatus status;
  final List<PaymentModel> paymentMethods;
  final List<TransactionModel> transactions;
  final TransactionModel? lastCreatedTransaction;
  final String? errorMessage;

  const TransactionState({
    this.status = TransactionStatus.initial,
    this.paymentMethods = const [],
    this.transactions = const [],
    this.lastCreatedTransaction,
    this.errorMessage,
  });

  TransactionState copyWith({
    TransactionStatus? status,
    List<PaymentModel>? paymentMethods,
    List<TransactionModel>? transactions,
    TransactionModel? lastCreatedTransaction,
    String? errorMessage,
  }) {
    return TransactionState(
      status: status ?? this.status,
      paymentMethods: paymentMethods ?? this.paymentMethods,
      transactions: transactions ?? this.transactions,
      lastCreatedTransaction:
          lastCreatedTransaction ?? this.lastCreatedTransaction,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
    status,
    paymentMethods,
    transactions,
    lastCreatedTransaction,
    errorMessage,
  ];
}
