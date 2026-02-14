// TODO: Problem: review string not saved

class RatingModel {
  final String? id;
  final String? foodId;
  final String? userId;
  final int rating;
  final String? review;
  final DateTime? createdAt;

  RatingModel({
    this.id,
    this.foodId,
    this.userId,
    required this.rating,
    this.review,
    this.createdAt,
  });

  factory RatingModel.fromJson(Map<String, dynamic> json) {
    return RatingModel(
      id: json['id'] as String?,
      foodId: json['foodId'] as String?,
      userId: json['userId'] as String?,
      rating: (json['rating'] as num?)?.toInt() ?? 0,
      review: json['review'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  Map<String, dynamic> toJson() => {
    'id': id,
    'foodId': foodId,
    'userId': userId,
    'rating': rating,
    'review': review,
    'createdAt': createdAt?.toIso8601String(),
  };
}
