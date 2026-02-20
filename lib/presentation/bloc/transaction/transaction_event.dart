import 'package:equatable/equatable.dart';

sealed class TransactionEvent extends Equatable {
  const TransactionEvent();

  @override
  List<Object?> get props => [];
}

class PaymentMethodsFetchRequested extends TransactionEvent {
  const PaymentMethodsFetchRequested();
}

class TransactionCreateRequested extends TransactionEvent {
  const TransactionCreateRequested({
    required this.cartIds,
    required this.paymentMethodId,
  });

  final List<String> cartIds;
  final String paymentMethodId;

  @override
  List<Object?> get props => [cartIds, paymentMethodId];
}

class TransactionsFetchRequested extends TransactionEvent {
  const TransactionsFetchRequested();
}

class TransactionCancelRequested extends TransactionEvent {
  const TransactionCancelRequested(this.transactionId);

  final String transactionId;

  @override
  List<Object?> get props => [transactionId];
}
