import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_serve/presentation/bloc/rating/rating_bloc.dart';
import 'package:re_serve/presentation/bloc/rating/rating_event.dart';
import 'package:re_serve/presentation/bloc/rating/rating_state.dart';
import 'package:re_serve/presentation/bloc/food/food_bloc.dart';
import 'package:re_serve/presentation/bloc/food/food_event.dart';

class RatingDialog extends StatefulWidget {
  final String foodId;
  final String foodName;

  const RatingDialog({super.key, required this.foodId, required this.foodName});

  @override
  State<RatingDialog> createState() => _RatingDialogState();
}

class _RatingDialogState extends State<RatingDialog> {
  int _selectedRating = 0;
  final _reviewController = TextEditingController();
  String? _reviewError;

  @override
  void dispose() {
    _reviewController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<RatingBloc, RatingState>(
      listener: (context, state) {
        if (state.status == RatingStatus.success) {
          // Refresh food detail to get updated rating
          context.read<FoodBloc>().add(FoodDetailFetchRequested(widget.foodId));
          Navigator.pop(context);
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Rating submitted successfully!')),
          );
        } else if (state.status == RatingStatus.failure) {
          final msg = _beautifyError(
            state.errorMessage ?? 'Failed to submit rating',
          );
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(msg), backgroundColor: Colors.red),
          );
        }
      },
      builder: (context, state) {
        final isSubmitting = state.status == RatingStatus.submitting;

        final screenHeight = MediaQuery.of(context).size.height;

        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              maxHeight: screenHeight * 0.8,
              maxWidth: 420,
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Rate ${widget.foodName}',
                    style: const TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 24),

                  // Star Rating Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(5, (index) {
                      return IconButton(
                        iconSize: 40,
                        padding: const EdgeInsets.all(4),
                        constraints: const BoxConstraints(),
                        icon: Icon(
                          index < _selectedRating
                              ? Icons.star
                              : Icons.star_border,
                          color: const Color(0xFFFF6B6B),
                        ),
                        onPressed: isSubmitting
                            ? null
                            : () {
                                setState(() {
                                  _selectedRating = index + 1;
                                });
                              },
                      );
                    }),
                  ),
                  const SizedBox(height: 8),

                  // Rating Label
                  Text(
                    _selectedRating == 0
                        ? 'Tap a star to rate'
                        : _getRatingLabel(_selectedRating),
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  const SizedBox(height: 24),

                  // Review TextField
                  TextField(
                    controller: _reviewController,
                    enabled: !isSubmitting,
                    maxLines: 3,
                    decoration: InputDecoration(
                      hintText: 'Write your review',
                      errorText: _reviewError,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      contentPadding: const EdgeInsets.all(12),
                    ),
                    onChanged: (_) {
                      if (_reviewError != null) {
                        setState(() => _reviewError = null);
                      }
                    },
                  ),
                  const SizedBox(height: 24),

                  // Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: isSubmitting
                              ? null
                              : () => Navigator.pop(context),
                          style: OutlinedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text('Cancel'),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                          onPressed: _selectedRating == 0 || isSubmitting
                              ? null
                              : () {
                                  final review = _reviewController.text.trim();
                                  if (review.isEmpty) {
                                    setState(() {
                                      _reviewError = 'Review is required';
                                    });
                                    return;
                                  }
                                  context.read<RatingBloc>().add(
                                    RatingSubmitRequested(
                                      foodId: widget.foodId,
                                      rating: _selectedRating,
                                      review: review,
                                    ),
                                  );
                                },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE74C3C),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 12),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : const Text('Submit'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  String _getRatingLabel(int rating) {
    switch (rating) {
      case 1:
        return 'Poor';
      case 2:
        return 'Fair';
      case 3:
        return 'Good';
      case 4:
        return 'Very Good';
      case 5:
        return 'Excellent';
      default:
        return '';
    }
  }

  String _beautifyError(String raw) {
    final lower = raw.toLowerCase();
    if (lower.contains('already') && lower.contains('rated')) {
      return 'You have already rated this food.';
    }
    if (lower.contains('socketexception') || lower.contains('connection')) {
      return 'No internet connection. Please check your network.';
    }
    if (lower.contains('timeout')) {
      return 'Request timed out. Please try again.';
    }
    final cleaned = raw.replaceFirst(RegExp(r'^Exception:\s*'), '');
    return cleaned.isNotEmpty ? cleaned : 'Failed to submit rating.';
  }
}
