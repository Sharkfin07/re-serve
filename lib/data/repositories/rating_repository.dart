import '../models/rating_model.dart';
import '../services/rating_service.dart';

class RatingRepository {
  RatingRepository({RatingService? service})
    : _service = service ?? RatingService();

  final RatingService _service;

  Future<void> createRating({
    required String foodId,
    required int rating,
    String? review,
  }) {
    return _service.createRating(
      foodId: foodId,
      rating: rating,
      review: review,
    );
  }

  Future<List<RatingModel>> getRatings(String foodId) {
    return _service.getRatings(foodId);
  }
}
