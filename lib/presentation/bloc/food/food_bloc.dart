import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_serve/data/repositories/food_repository.dart';
import 'package:re_serve/presentation/bloc/food/food_event.dart';
import 'package:re_serve/presentation/bloc/food/food_state.dart';

class FoodBloc extends Bloc<FoodEvent, FoodState> {
  FoodBloc({required FoodRepository foodRepository})
    : _foodRepository = foodRepository,
      super(const FoodState()) {
    on<FoodFetchRequested>(_onFoodFetchRequested);
    on<FoodDetailFetchRequested>(_onFoodDetailFetchRequested);
    on<FoodSearchRequested>(_onFoodSearchRequested);
    on<FoodLikeToggleRequested>(_onFoodLikeToggleRequested);
    on<FoodLikedFetchRequested>(_onFoodLikedFetchRequested);
  }

  final FoodRepository _foodRepository;

  Future<void> _onFoodFetchRequested(
    FoodFetchRequested event,
    Emitter<FoodState> emit,
  ) async {
    emit(state.copyWith(status: FoodStatus.loading, errorMessage: null));
    try {
      final foods = await _foodRepository.getFoods();
      emit(state.copyWith(status: FoodStatus.success, foods: foods));
    } catch (e) {
      emit(
        state.copyWith(status: FoodStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onFoodDetailFetchRequested(
    FoodDetailFetchRequested event,
    Emitter<FoodState> emit,
  ) async {
    emit(state.copyWith(status: FoodStatus.loading, errorMessage: null));
    try {
      final food = await _foodRepository.getFoodById(event.foodId);
      emit(state.copyWith(status: FoodStatus.success, selectedFood: food));
    } catch (e) {
      emit(
        state.copyWith(status: FoodStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onFoodSearchRequested(
    FoodSearchRequested event,
    Emitter<FoodState> emit,
  ) async {
    emit(state.copyWith(status: FoodStatus.loading, errorMessage: null));
    try {
      // Fetch all foods first if not available
      final allFoods = state.foods.isEmpty
          ? await _foodRepository.getFoods()
          : state.foods;

      // Filter foods by query (sadly still client-side search)
      final filteredFoods = event.query.isEmpty
          ? allFoods
          : allFoods
                .where(
                  (food) => food.name.toLowerCase().contains(
                    event.query.toLowerCase(),
                  ),
                )
                .toList();

      emit(state.copyWith(status: FoodStatus.success, foods: filteredFoods));
    } catch (e) {
      emit(
        state.copyWith(status: FoodStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onFoodLikeToggleRequested(
    FoodLikeToggleRequested event,
    Emitter<FoodState> emit,
  ) async {
    try {
      // Call like or unlike based on current status
      if (event.currentLikeStatus) {
        await _foodRepository.unlikeFood(event.foodId);
      } else {
        await _foodRepository.likeFood(event.foodId);
      }

      // Refresh the food detail to get updated like status
      final updatedFood = await _foodRepository.getFoodById(event.foodId);

      // Update the foods list if current food is in the list
      final updatedFoods = state.foods.map((food) {
        if (food.id == event.foodId) {
          return updatedFood;
        }
        return food;
      }).toList();

      emit(
        state.copyWith(
          status: FoodStatus.success,
          selectedFood: updatedFood,
          foods: updatedFoods,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(status: FoodStatus.failure, errorMessage: e.toString()),
      );
    }
  }

  Future<void> _onFoodLikedFetchRequested(
    FoodLikedFetchRequested event,
    Emitter<FoodState> emit,
  ) async {
    emit(state.copyWith(status: FoodStatus.loading, errorMessage: null));
    try {
      final likedFoods = await _foodRepository.getLikedFoods();
      emit(state.copyWith(status: FoodStatus.success, likedFoods: likedFoods));
    } catch (e) {
      emit(
        state.copyWith(status: FoodStatus.failure, errorMessage: e.toString()),
      );
    }
  }
}
