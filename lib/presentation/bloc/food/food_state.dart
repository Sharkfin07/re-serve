import 'package:equatable/equatable.dart';
import 'package:re_serve/data/models/food_model.dart';

enum FoodStatus { initial, loading, success, failure }

class FoodState extends Equatable {
  final FoodStatus status;
  final List<FoodModel> foods;
  final List<FoodModel> likedFoods;
  final FoodModel? selectedFood;
  final String? errorMessage;

  const FoodState({
    this.status = FoodStatus.initial,
    this.foods = const [],
    this.likedFoods = const [],
    this.selectedFood,
    this.errorMessage,
  });

  FoodState copyWith({
    FoodStatus? status,
    List<FoodModel>? foods,
    List<FoodModel>? likedFoods,
    FoodModel? selectedFood,
    String? errorMessage,
  }) {
    return FoodState(
      status: status ?? this.status,
      foods: foods ?? this.foods,
      likedFoods: likedFoods ?? this.likedFoods,
      selectedFood: selectedFood ?? this.selectedFood,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, foods, likedFoods, selectedFood, errorMessage];
}
