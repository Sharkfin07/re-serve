import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_serve/data/repositories/payment_repository.dart';
import 'package:re_serve/data/repositories/transaction_repository.dart';
import 'package:re_serve/presentation/bloc/transaction/transaction_event.dart';
import 'package:re_serve/presentation/bloc/transaction/transaction_state.dart';

class TransactionBloc extends Bloc<TransactionEvent, TransactionState> {
  TransactionBloc({
    required TransactionRepository transactionRepository,
    required PaymentRepository paymentRepository,
  }) : _transactionRepository = transactionRepository,
       _paymentRepository = paymentRepository,
       super(const TransactionState()) {
    on<PaymentMethodsFetchRequested>(_onPaymentMethodsFetch);
    on<TransactionCreateRequested>(_onTransactionCreate);
    on<TransactionsFetchRequested>(_onTransactionsFetch);
    on<TransactionCancelRequested>(_onTransactionCancel);
  }

  final TransactionRepository _transactionRepository;
  final PaymentRepository _paymentRepository;

  Future<void> _onPaymentMethodsFetch(
    PaymentMethodsFetchRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading, errorMessage: null));
    try {
      final methods = await _paymentRepository.getPaymentMethods();
      emit(
        state.copyWith(
          status: TransactionStatus.success,
          paymentMethods: methods,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onTransactionCreate(
    TransactionCreateRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading, errorMessage: null));
    try {
      await _transactionRepository.createTransaction(
        cartIds: event.cartIds,
        paymentMethodId: event.paymentMethodId,
      );
      emit(
        state.copyWith(
          status: TransactionStatus.success,
          transactionCreated: true,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onTransactionsFetch(
    TransactionsFetchRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading, errorMessage: null));
    try {
      final transactions = await _transactionRepository.getMyTransactions();
      emit(
        state.copyWith(
          status: TransactionStatus.success,
          transactions: transactions,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onTransactionCancel(
    TransactionCancelRequested event,
    Emitter<TransactionState> emit,
  ) async {
    emit(state.copyWith(status: TransactionStatus.loading, errorMessage: null));
    try {
      await _transactionRepository.cancelTransaction(event.transactionId);
      final transactions = await _transactionRepository.getMyTransactions();
      emit(
        state.copyWith(
          status: TransactionStatus.success,
          transactions: transactions,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          status: TransactionStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
