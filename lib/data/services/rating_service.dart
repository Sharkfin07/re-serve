import 'package:dio/dio.dart';

import '../models/rating_model.dart';
import 'api_client.dart';
import 'auth_service.dart';

class RatingService {
  RatingService({ApiClient? client, AuthService? authService})
    : _client = client ?? ApiClient.instance(),
      _authService = authService ?? AuthService();

  final ApiClient _client;
  final AuthService _authService;

  Future<void> createRating({
    required String foodId,
    required int rating,
    String? review,
  }) async {
    final options = await _authService.authorizedHeaders();
    await _client.post(
      '/api/v1/rate-food/$foodId',
      data: {'rating': rating, if (review != null) 'review': review},
      options: options,
    );
  }

  Future<List<RatingModel>> getRatings(String foodId) async {
    final options = await _authService.authorizedHeaders();
    final response = await _client.get<Map<String, dynamic>>(
      '/api/v1/food-rating/$foodId',
      options: options,
    );
    final data = response.data?['data'];
    if (data == null || data is! List) {
      throw Exception('Rating list tidak ditemukan');
    }
    return data
        .whereType<Map<String, dynamic>>()
        .map(RatingModel.fromJson)
        .toList();
  }
}
