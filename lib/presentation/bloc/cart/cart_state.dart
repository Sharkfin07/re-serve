import 'package:equatable/equatable.dart';
import 'package:re_serve/data/models/cart_model.dart';

enum CartStatus { initial, loading, success, failure }

class CartState extends Equatable {
  final CartStatus status;
  final List<CartModel> cartItems;
  final String? errorMessage;

  const CartState({
    this.status = CartStatus.initial,
    this.cartItems = const [],
    this.errorMessage,
  });

  // Calculate total original price
  int get totalOriginalPrice {
    return cartItems.fold(0, (sum, item) {
      if (item.food != null) {
        final price = item.food!['price'] as int? ?? 0;
        return sum + (price * item.quantity);
      }
      return sum;
    });
  }

  // Calculate total discounted price
  int get totalPrice {
    return cartItems.fold(0, (sum, item) {
      if (item.food != null) {
        final price =
            item.food!['priceDiscount'] as int? ??
            item.food!['price'] as int? ??
            0;
        return sum + (price * item.quantity);
      }
      return sum;
    });
  }

  // Calculate total savings
  int get totalSavings {
    return totalOriginalPrice - totalPrice;
  }

  CartState copyWith({
    CartStatus? status,
    List<CartModel>? cartItems,
    String? errorMessage,
  }) {
    return CartState(
      status: status ?? this.status,
      cartItems: cartItems ?? this.cartItems,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, cartItems, errorMessage];
}
