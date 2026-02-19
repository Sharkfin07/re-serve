import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_serve/presentation/bloc/cart/cart_bloc.dart';

import 'package:re_serve/presentation/bloc/food/food_bloc.dart';
import 'package:re_serve/presentation/bloc/food/food_event.dart';
import 'package:re_serve/presentation/bloc/food/food_state.dart';
import 'package:re_serve/presentation/screen/cart/cart_screen.dart';
import 'package:re_serve/presentation/widgets/food/food_card.dart';
import 'package:re_serve/presentation/widgets/global/global_input.dart';
import 'package:re_serve/presentation/screen/food/food_detail_screen.dart';

class ExploreScreen extends StatefulWidget {
  const ExploreScreen({super.key});

  @override
  State<ExploreScreen> createState() => _ExploreScreenState();
}

class _ExploreScreenState extends State<ExploreScreen> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foodBloc = context.read<FoodBloc>();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_outlined),
            onPressed: () {
              // TODO: Navigate to notifications
            },
          ),
          IconButton(
            icon: const Icon(Icons.shopping_bag_outlined),
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
        ],
      ),
      body: BlocBuilder<FoodBloc, FoodState>(
        builder: (context, state) {
          return RefreshIndicator(
            onRefresh: () async {
              foodBloc.add(const FoodFetchRequested());
            },
            child: CustomScrollView(
              slivers: [
                // Search Bar
                SliverPadding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  sliver: SliverToBoxAdapter(
                    child: GlobalInput(
                      controller: _searchController,
                      hintText: 'Search',
                      prefixIcon: const Icon(Icons.search),
                      onChanged: (query) {
                        foodBloc.add(FoodSearchRequested(query));
                      },
                    ),
                  ),
                ),

                // Content
                if (state.status == FoodStatus.loading)
                  const SliverFillRemaining(
                    child: Center(child: CircularProgressIndicator()),
                  )
                else if (state.status == FoodStatus.failure)
                  SliverFillRemaining(
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'Error: ${state.errorMessage ?? "Unknown error"}',
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 16),
                          ElevatedButton(
                            onPressed: () {
                              foodBloc.add(const FoodFetchRequested());
                            },
                            child: const Text('Retry'),
                          ),
                        ],
                      ),
                    ),
                  )
                else if (state.foods.isEmpty)
                  const SliverFillRemaining(
                    child: Center(child: Text('No food items available')),
                  )
                else
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate((context, index) {
                        final food = state.foods[index];
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: FoodCard(
                            food: food,
                            onTap: () {
                              if (!mounted) return;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => BlocProvider.value(
                                    value: foodBloc,
                                    child: FoodDetailScreen(foodId: food.id),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }, childCount: state.foods.length),
                    ),
                  ),
              ],
            ),
          );
        },
      ),
    );
  }
}
