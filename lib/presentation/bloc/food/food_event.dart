import 'package:equatable/equatable.dart';

sealed class FoodEvent extends Equatable {
  const FoodEvent();

  @override
  List<Object?> get props => [];
}

class FoodFetchRequested extends FoodEvent {
  const FoodFetchRequested();
}

class FoodDetailFetchRequested extends FoodEvent {
  final String foodId;

  const FoodDetailFetchRequested(this.foodId);

  @override
  List<Object?> get props => [foodId];
}

class FoodSearchRequested extends FoodEvent {
  final String query;

  const FoodSearchRequested(this.query);

  @override
  List<Object?> get props => [query];
}

class FoodLikeToggleRequested extends FoodEvent {
  final String foodId;
  final bool currentLikeStatus;

  const FoodLikeToggleRequested({
    required this.foodId,
    required this.currentLikeStatus,
  });

  @override
  List<Object?> get props => [foodId, currentLikeStatus];
}
