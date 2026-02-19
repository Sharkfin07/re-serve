import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_serve/presentation/bloc/food/food_bloc.dart';
import 'package:re_serve/presentation/bloc/food/food_event.dart';
import 'package:re_serve/presentation/bloc/food/food_state.dart';
import 'package:re_serve/data/models/food_model.dart';

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
                      ? Image.network(
                          food.imageUrl!,
                          height: 280,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
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
                                    Icons.notifications_outlined,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    // TODO: Navigate to notifications
                                  },
                                ),
                              ),
                              const SizedBox(width: 8),
                              CircleAvatar(
                                backgroundColor: Colors.white,
                                child: IconButton(
                                  icon: const Icon(
                                    Icons.shopping_bag_outlined,
                                    color: Colors.black,
                                  ),
                                  onPressed: () {
                                    // TODO: Navigate to cart
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
                              index < food.rating
                                  ? Icons.star
                                  : Icons.star_border,
                              color: const Color(0xFFFF6B6B),
                              size: 24,
                            );
                          }),
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
                      const SizedBox(height: 100), // Space for buttons
                    ],
                  ),
                ),
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
                      // TODO: Add to cart
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Added to cart!')),
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
                    // TODO: Toggle favorite
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          food.isLike
                              ? 'Unliked ${food.name}'
                              : 'Liked ${food.name}',
                        ),
                      ),
                    );
                  },
                  backgroundColor: const Color(0xFFFF6B6B),
                  child: const Icon(Icons.favorite, color: Colors.white),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
