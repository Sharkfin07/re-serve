import '../models/food_model.dart';
import '../services/food_service.dart';

class FoodRepository {
  FoodRepository({FoodService? service}) : _service = service ?? FoodService();

  final FoodService _service;

  Future<List<FoodModel>> getFoods() => _service.getFoods();

  Future<List<FoodModel>> getLikedFoods() => _service.getLikedFoods();

  Future<FoodModel> getFoodById(String foodId) => _service.getFoodById(foodId);

  Future<FoodModel> createFood({
    required String name,
    required String description,
    required String imageUrl,
    required List<String> ingredients,
    required int price,
    int? priceDiscount,
  }) {
    return _service.createFood(
      name: name,
      description: description,
      imageUrl: imageUrl,
      ingredients: ingredients,
      price: price,
      priceDiscount: priceDiscount,
    );
  }

  Future<FoodModel> updateFood({
    required String foodId,
    required String name,
    required String description,
    required String imageUrl,
    required List<String> ingredients,
    int? price,
    int? priceDiscount,
  }) {
    return _service.updateFood(
      foodId: foodId,
      name: name,
      description: description,
      imageUrl: imageUrl,
      ingredients: ingredients,
      price: price,
      priceDiscount: priceDiscount,
    );
  }

  Future<void> deleteFood(String foodId) => _service.deleteFood(foodId);

  Future<void> likeFood(String foodId) => _service.likeFood(foodId);

  Future<void> unlikeFood(String foodId) => _service.unlikeFood(foodId);
}
