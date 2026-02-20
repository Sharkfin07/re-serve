import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_serve/data/repositories/cart_repository.dart';
import 'package:re_serve/presentation/bloc/cart/cart_event.dart';
import 'package:re_serve/presentation/bloc/cart/cart_state.dart';

class CartBloc extends Bloc<CartEvent, CartState> {
  CartBloc({required CartRepository cartRepository})
    : _cartRepository = cartRepository,
      super(const CartState()) {
    on<CartFetchRequested>(_onCartFetchRequested);
    on<CartAddRequested>(_onCartAddRequested);
    on<CartUpdateRequested>(_onCartUpdateRequested);
    on<CartRemoveRequested>(_onCartRemoveRequested);
    on<CartClearRequested>(_onCartClearRequested);
  }

  final CartRepository _cartRepository;

  Future<void> _onCartFetchRequested(
    CartFetchRequested event,
    Emitter<CartState> emit,
  ) async {
    emit(state.copyWith(status: CartStatus.loading, errorMessage: null));
    try {
      final cartItems = await _cartRepository.getCarts();
      emit(state.copyWith(status: CartStatus.success, cartItems: cartItems));
    } catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onCartAddRequested(
    CartAddRequested event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartRepository.addToCart(event.foodId);
      // Refresh cart after adding
      final cartItems = await _cartRepository.getCarts();
      emit(state.copyWith(status: CartStatus.success, cartItems: cartItems));
    } catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onCartUpdateRequested(
    CartUpdateRequested event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartRepository.updateCart(
        cartId: event.cartId,
        quantity: event.quantity,
      );
      // Refresh cart after updating
      final cartItems = await _cartRepository.getCarts();
      emit(state.copyWith(status: CartStatus.success, cartItems: cartItems));
    } catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onCartRemoveRequested(
    CartRemoveRequested event,
    Emitter<CartState> emit,
  ) async {
    try {
      await _cartRepository.deleteCart(event.cartId);
      // Refresh cart after removing
      final cartItems = await _cartRepository.getCarts();
      emit(state.copyWith(status: CartStatus.success, cartItems: cartItems));
    } catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onCartClearRequested(
    CartClearRequested event,
    Emitter<CartState> emit,
  ) async {
    try {
      // Delete all cart items
      for (final item in state.cartItems) {
        await _cartRepository.deleteCart(item.id);
      }
      emit(state.copyWith(status: CartStatus.success, cartItems: []));
    } catch (e) {
      emit(
        state.copyWith(status: CartStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
