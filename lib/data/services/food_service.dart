import '../models/food_model.dart';
import 'api_client.dart';
import 'auth_service.dart';

class FoodService {
  FoodService({ApiClient? client, AuthService? authService})
    : _client = client ?? ApiClient.instance(),
      _authService = authService ?? AuthService();

  final ApiClient _client;
  final AuthService _authService;

  Future<List<FoodModel>> getFoods() async {
    final options = await _authService.authorizedHeaders();
    final response = await _client.get<Map<String, dynamic>>(
      '/api/v1/foods',
      options: options,
    );
    final data = response.data?['data'];
    if (data == null || data is! List) {
      throw Exception('Food list not found');
    }
    return data
        .whereType<Map<String, dynamic>>()
        .map(FoodModel.fromJson)
        .toList();
  }

  Future<List<FoodModel>> getLikedFoods() async {
    final options = await _authService.authorizedHeaders();
    final response = await _client.get<Map<String, dynamic>>(
      '/api/v1/like-foods',
      options: options,
    );
    final data = response.data?['data'];
    if (data == null || data is! List) {
      throw Exception('Liked food list not found');
    }
    return data
        .whereType<Map<String, dynamic>>()
        .map(FoodModel.fromJson)
        .toList();
  }

  Future<FoodModel> getFoodById(String foodId) async {
    final options = await _authService.authorizedHeaders();
    final response = await _client.get<Map<String, dynamic>>(
      '/api/v1/foods/$foodId',
      options: options,
    );
    final data = response.data?['data'];
    if (data == null || data is! Map<String, dynamic>) {
      throw Exception('Food not found');
    }
    return FoodModel.fromJson(data);
  }

  Future<FoodModel> createFood({
    required String name,
    required String description,
    required String imageUrl,
    required List<String> ingredients,
    required int price,
    int? priceDiscount,
  }) async {
    final options = await _authService.authorizedHeaders();
    final response = await _client.post<Map<String, dynamic>>(
      '/api/v1/create-food',
      data: {
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'ingredients': ingredients,
        'price': price,
        'priceDiscount': priceDiscount,
      },
      options: options,
    );
    final data = response.data?['data'];
    if (data == null || data is! Map<String, dynamic>) {
      throw Exception('Failed creating food');
    }
    return FoodModel.fromJson(data);
  }

  Future<FoodModel> updateFood({
    required String foodId,
    required String name,
    required String description,
    required String imageUrl,
    required List<String> ingredients,
    int? price,
    int? priceDiscount,
  }) async {
    final options = await _authService.authorizedHeaders();
    final response = await _client.post<Map<String, dynamic>>(
      '/api/v1/update-food/$foodId',
      data: {
        'name': name,
        'description': description,
        'imageUrl': imageUrl,
        'ingredients': ingredients,
        'price': price,
        'priceDiscount': priceDiscount,
      },
      options: options,
    );
    final data = response.data?['data'];
    if (data == null || data is! Map<String, dynamic>) {
      throw Exception('Failed to update food');
    }
    return FoodModel.fromJson(data);
  }

  Future<void> deleteFood(String foodId) async {
    final options = await _authService.authorizedHeaders();
    await _client.delete('/api/v1/delete-food/$foodId', options: options);
  }

  Future<void> likeFood(String foodId) async {
    final options = await _authService.authorizedHeaders();
    await _client.post(
      '/api/v1/like',
      data: {'foodId': foodId},
      options: options,
    );
  }

  Future<void> unlikeFood(String foodId) async {
    final options = await _authService.authorizedHeaders();
    await _client.post(
      '/api/v1/unlike',
      data: {'foodId': foodId},
      options: options,
    );
  }
}
