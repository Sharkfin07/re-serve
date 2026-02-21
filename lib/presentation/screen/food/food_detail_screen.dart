import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:re_serve/presentation/bloc/food/food_bloc.dart';
import 'package:re_serve/presentation/bloc/food/food_event.dart';
import 'package:re_serve/presentation/bloc/food/food_state.dart';
import 'package:re_serve/presentation/bloc/cart/cart_bloc.dart';
import 'package:re_serve/presentation/bloc/cart/cart_event.dart';
import 'package:re_serve/presentation/bloc/rating/rating_bloc.dart';
import 'package:re_serve/presentation/bloc/rating/rating_event.dart';
import 'package:re_serve/presentation/bloc/rating/rating_state.dart';
import 'package:re_serve/presentation/screen/cart/cart_screen.dart';
import 'package:re_serve/presentation/widgets/rating/rating_dialog.dart';
import 'package:re_serve/data/models/food_model.dart';
import 'package:re_serve/data/models/rating_model.dart';
import 'package:re_serve/core/utils/formatters.dart';

class FoodDetailScreen extends StatefulWidget {
  final String foodId;

  const FoodDetailScreen({super.key, required this.foodId});

  @override
  State<FoodDetailScreen> createState() => _FoodDetailScreenState();
}

class _FoodDetailScreenState extends State<FoodDetailScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FoodBloc>().add(FoodDetailFetchRequested(widget.foodId));
    context.read<RatingBloc>().add(RatingFetchRequested(widget.foodId));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: BlocBuilder<FoodBloc, FoodState>(
        builder: (context, state) {
          if (state.status == FoodStatus.loading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.status == FoodStatus.failure) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.errorMessage ?? "Unknown error"}'),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<FoodBloc>().add(
                        FoodDetailFetchRequested(widget.foodId),
                      );
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final food = state.selectedFood;
          if (food == null) {
            return const Center(child: Text('Food not found'));
          }

          return _buildDetailContent(context, food);
        },
      ),
    );
  }

  Widget _buildDetailContent(BuildContext context, FoodModel food) {
    final theme = Theme.of(context);
    final hasDiscount = food.priceDiscount != null;

    return Stack(
      children: [
        CustomScrollView(
          slivers: [
            // Food Image Header
            SliverToBoxAdapter(
              child: Stack(
                children: [
                  // Food Image
                  food.imageUrl != null
                      ? CachedNetworkImage(
                          imageUrl: food.imageUrl!,
                          height: 280,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          placeholder: (context, url) {
                            return Container(
                              height: 280,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: const Icon(Icons.restaurant, size: 64),
                            );
                          },
                          errorWidget: (context, url, error) {
                            return Container(
                              height: 280,
                              width: double.infinity,
                              color: Colors.grey[300],
                              child: const Icon(Icons.restaurant, size: 64),
                            );
                          },
                        )
                      : Container(
                          height: 280,
                          width: double.infinity,
                          color: Colors.grey[300],
                          child: const Icon(Icons.restaurant, size: 64),
                        ),

                  // Top Bar with Back Button
                  Positioned(
                    top: MediaQuery.of(context).padding.top,
                    left: 0,
                    right: 0,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.white,
                            child: IconButton(
                              icon: const Icon(
                                Icons.arrow_back,
                                color: Colors.black,
                              ),
                              onPressed: () => Navigator.pop(context),
                            ),
                          ),
                          Row(
                            children: [
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.shopping_bag_outlined,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    final cartBloc = context.read<CartBloc>();
                                    if (!mounted) return;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (_) => BlocProvider.value(
                                          value: cartBloc,
                                          child: const CartScreen(),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Food Details
            SliverToBoxAdapter(
              child: Container(
                decoration: BoxDecoration(color: theme.colorScheme.surface),
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Food Name & Like Button
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Expanded(
                            child: Text(
                              food.name,
                              style: TextStyle(
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),
                          Column(
                            children: [
                              Icon(
                                food.isLike
                                    ? Icons.favorite
                                    : Icons.favorite_border,
                                color: const Color(0xFFFF6B6B),
                                size: 28,
                              ),
                              Text(
                                food.totalLikes.toString(),
                                style: theme.textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),

                      // Price
                      Row(
                        children: [
                          if (hasDiscount) ...[
                            Text(
                              'Rp${food.price.toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                              style: theme.textTheme.titleMedium?.copyWith(
                                decoration: TextDecoration.lineThrough,
                                color: Colors.grey,
                              ),
                            ),
                            const SizedBox(width: 12),
                          ],
                          Text(
                            'Rp${(food.priceDiscount ?? food.price).toString().replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              color: const Color(0xFFFF6B6B),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),

                      // Rating
                      Row(
                        children: [
                          ...List.generate(5, (index) {
                            return Icon(
                              index < food.rating.round()
                                  ? Icons.star
                                  : Icons.star_border,
                              color: const Color(0xFFFF6B6B),
                              size: 24,
                            );
                          }),
                          const SizedBox(width: 8),
                          Text(
                            food.rating.toStringAsFixed(1),
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Description
                      Text(
                        food.description,
                        style: theme.textTheme.bodyMedium?.copyWith(
                          height: 1.6,
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ),
                      const SizedBox(height: 24),
                      Divider(color: Colors.black12),
                    ],
                  ),
                ),
              ),
            ),

            // Reviews Section
            SliverToBoxAdapter(
              child: BlocBuilder<RatingBloc, RatingState>(
                builder: (context, ratingState) {
                  return Container(
                    color: theme.colorScheme.surface,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            const Icon(Icons.reviews_outlined, size: 22),
                            const SizedBox(width: 8),
                            Text(
                              'Reviews',
                              style: theme.textTheme.titleLarge?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            if (ratingState.status == RatingStatus.success)
                              Padding(
                                padding: const EdgeInsets.only(left: 8),
                                child: Text(
                                  '(${ratingState.ratings.length})',
                                  style: theme.textTheme.titleMedium?.copyWith(
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                              ),
                          ],
                        ),
                        const SizedBox(height: 16),
                        // Rate this food button
                        OutlinedButton.icon(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (_) => MultiBlocProvider(
                                providers: [
                                  BlocProvider.value(
                                    value: context.read<RatingBloc>(),
                                  ),
                                  BlocProvider.value(
                                    value: context.read<FoodBloc>(),
                                  ),
                                ],
                                child: RatingDialog(
                                  foodId: food.id,
                                  foodName: food.name,
                                ),
                              ),
                            );
                          },
                          icon: const Icon(Icons.star_outline),
                          label: const Text('Rate this food'),
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFE74C3C),
                            side: const BorderSide(color: Color(0xFFE74C3C)),
                            padding: const EdgeInsets.symmetric(
                              vertical: 12,
                              horizontal: 24,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                        ),
                        const SizedBox(height: 16),
                        if (ratingState.status == RatingStatus.loading)
                          const Padding(
                            padding: EdgeInsets.symmetric(vertical: 24),
                            child: Center(child: CircularProgressIndicator()),
                          )
                        else if (ratingState.ratings.isEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 24),
                            child: Center(
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.rate_review_outlined,
                                    size: 48,
                                    color: theme.colorScheme.onSurface
                                        .withValues(alpha: 0.3),
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    'No reviews yet. Be the first!',
                                    style: theme.textTheme.bodyMedium?.copyWith(
                                      color: theme.colorScheme.onSurface
                                          .withValues(alpha: 0.5),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          )
                        else
                          ...ratingState.ratings.map(
                            (r) => _buildReviewCard(theme, r),
                          ),
                        const SizedBox(height: 100), // Space for bottom buttons
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),

        // Bottom Buttons
        Positioned(
          bottom: 0,
          left: 0,
          right: 0,
          child: Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, -5),
                ),
              ],
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      context.read<CartBloc>().add(CartAddRequested(food.id));
                      ScaffoldMessenger.of(context).clearSnackBars();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('${food.name} added to cart!'),
                          duration: const Duration(seconds: 2),
                          behavior: SnackBarBehavior.floating,
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2D3142),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Icon(Icons.shopping_cart_outlined),
                        const SizedBox(width: 8),
                        Text(
                          'Add to Cart',
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                FloatingActionButton(
                  onPressed: () {
                    context.read<FoodBloc>().add(
                      FoodLikeToggleRequested(
                        foodId: food.id,
                        currentLikeStatus: food.isLike,
                      ),
                    );
                  },
                  backgroundColor: const Color(0xFFFF6B6B),
                  child: Icon(
                    food.isLike ? Icons.favorite : Icons.favorite_border,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildReviewCard(ThemeData theme, RatingModel r) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color.fromARGB(8, 0, 0, 0),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 18,
                backgroundColor: const Color(
                  0xFFFF6B6B,
                ).withValues(alpha: 0.15),
                child: const Icon(
                  Icons.person,
                  size: 20,
                  color: Color(0xFFFF6B6B),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'User',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    if (r.createdAt != null)
                      Text(
                        Formatters.dateTime(r.createdAt!),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
              Row(
                mainAxisSize: MainAxisSize.min,
                children: List.generate(5, (index) {
                  return Icon(
                    index < r.rating ? Icons.star : Icons.star_border,
                    color: const Color(0xFFFF6B6B),
                    size: 18,
                  );
                }),
              ),
            ],
          ),
          if (r.review != null && r.review!.isNotEmpty) ...[
            const SizedBox(height: 10),
            Text(
              r.review!,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.8),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
