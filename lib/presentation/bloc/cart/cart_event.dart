import 'package:equatable/equatable.dart';

sealed class CartEvent extends Equatable {
  const CartEvent();

  @override
  List<Object?> get props => [];
}

class CartFetchRequested extends CartEvent {
  const CartFetchRequested();
}

class CartAddRequested extends CartEvent {
  final String foodId;

  const CartAddRequested(this.foodId);

  @override
  List<Object?> get props => [foodId];
}

class CartUpdateRequested extends CartEvent {
  final String cartId;
  final int quantity;

  const CartUpdateRequested({required this.cartId, required this.quantity});

  @override
  List<Object?> get props => [cartId, quantity];
}

class CartRemoveRequested extends CartEvent {
  final String cartId;

  const CartRemoveRequested(this.cartId);

  @override
  List<Object?> get props => [cartId];
}

class CartClearRequested extends CartEvent {
  const CartClearRequested();
}
