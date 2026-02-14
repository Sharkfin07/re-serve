import '../models/cart_model.dart';
import 'api_client.dart';
import 'auth_service.dart';

class CartService {
  CartService({ApiClient? client, AuthService? authService})
    : _client = client ?? ApiClient.instance(),
      _authService = authService ?? AuthService();

  final ApiClient _client;
  final AuthService _authService;

  Future<List<CartModel>> getCarts() async {
    final options = await _authService.authorizedHeaders();
    final response = await _client.get<Map<String, dynamic>>(
      '/api/v1/carts',
      options: options,
    );
    final data = response.data?['data'];
    if (data == null || data is! List) {
      throw Exception('Cart not found');
    }
    return data
        .whereType<Map<String, dynamic>>()
        .map(CartModel.fromJson)
        .toList();
  }

  Future<void> addToCart(String foodId) async {
    final options = await _authService.authorizedHeaders();
    await _client.post(
      '/api/v1/add-cart',
      data: {'foodId': foodId},
      options: options,
    );
  }

  Future<void> updateCart({
    required String cartId,
    required int quantity,
  }) async {
    final options = await _authService.authorizedHeaders();
    await _client.post(
      '/api/v1/update-cart/$cartId',
      data: {'quantity': quantity},
      options: options,
    );
  }

  Future<void> deleteCart(String cartId) async {
    final options = await _authService.authorizedHeaders();
    await _client.delete('/api/v1/delete-cart/$cartId', options: options);
  }
}
