import '../services/cart_service.dart';
import '../models/cart_model.dart';

class CartRepository {
  CartRepository({CartService? service}) : _service = service ?? CartService();

  final CartService _service;

  Future<List<CartModel>> getCarts() => _service.getCarts();

  Future<void> addToCart(String foodId) => _service.addToCart(foodId);

  Future<void> updateCart({required String cartId, required int quantity}) =>
      _service.updateCart(cartId: cartId, quantity: quantity);

  Future<void> deleteCart(String cartId) => _service.deleteCart(cartId);
}
