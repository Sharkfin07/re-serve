import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_serve/data/repositories/rating_repository.dart';
import 'package:re_serve/presentation/bloc/rating/rating_event.dart';
import 'package:re_serve/presentation/bloc/rating/rating_state.dart';

class RatingBloc extends Bloc<RatingEvent, RatingState> {
  RatingBloc({required RatingRepository ratingRepository})
    : _ratingRepository = ratingRepository,
      super(const RatingState()) {
    on<RatingFetchRequested>(_onRatingFetchRequested);
    on<RatingSubmitRequested>(_onRatingSubmitRequested);
  }

  final RatingRepository _ratingRepository;

  Future<void> _onRatingFetchRequested(
    RatingFetchRequested event,
    Emitter<RatingState> emit,
  ) async {
    emit(state.copyWith(status: RatingStatus.loading, errorMessage: null));
    try {
      final ratings = await _ratingRepository.getRatings(event.foodId);
      emit(state.copyWith(status: RatingStatus.success, ratings: ratings));
    } catch (e) {
      emit(
        state.copyWith(
          status: RatingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }

  Future<void> _onRatingSubmitRequested(
    RatingSubmitRequested event,
    Emitter<RatingState> emit,
  ) async {
    emit(state.copyWith(status: RatingStatus.submitting, errorMessage: null));
    try {
      await _ratingRepository.createRating(
        foodId: event.foodId,
        rating: event.rating,
        review: event.review,
      );

      // Refresh ratings after submitting
      final ratings = await _ratingRepository.getRatings(event.foodId);
      emit(state.copyWith(status: RatingStatus.success, ratings: ratings));
    } catch (e) {
      emit(
        state.copyWith(
          status: RatingStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
