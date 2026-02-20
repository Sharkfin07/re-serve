import 'package:equatable/equatable.dart';
import 'package:re_serve/data/models/rating_model.dart';

enum RatingStatus { initial, loading, success, failure, submitting }

class RatingState extends Equatable {
  final RatingStatus status;
  final List<RatingModel> ratings;
  final String? errorMessage;

  const RatingState({
    this.status = RatingStatus.initial,
    this.ratings = const [],
    this.errorMessage,
  });

  RatingState copyWith({
    RatingStatus? status,
    List<RatingModel>? ratings,
    String? errorMessage,
  }) {
    return RatingState(
      status: status ?? this.status,
      ratings: ratings ?? this.ratings,
      errorMessage: errorMessage ?? this.errorMessage,
    );
  }

  @override
  List<Object?> get props => [status, ratings, errorMessage];
}
