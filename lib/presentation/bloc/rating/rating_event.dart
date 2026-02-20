import 'package:equatable/equatable.dart';

sealed class RatingEvent extends Equatable {
  const RatingEvent();

  @override
  List<Object?> get props => [];
}

class RatingFetchRequested extends RatingEvent {
  final String foodId;

  const RatingFetchRequested(this.foodId);

  @override
  List<Object?> get props => [foodId];
}

class RatingSubmitRequested extends RatingEvent {
  final String foodId;
  final int rating;
  final String? review;

  const RatingSubmitRequested({
    required this.foodId,
    required this.rating,
    this.review,
  });

  @override
  List<Object?> get props => [foodId, rating, review];
}
