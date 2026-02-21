import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_serve/core/utils/is_dark.dart';
import 'package:re_serve/presentation/bloc/cart/cart_bloc.dart';

import 'package:re_serve/presentation/bloc/food/food_bloc.dart';
import 'package:re_serve/presentation/bloc/food/food_event.dart';
import 'package:re_serve/presentation/bloc/food/food_state.dart';
import 'package:re_serve/presentation/screen/account/account_screen.dart';
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
    final headerColor = isDark(context)
        ? Color.fromARGB(255, 37, 48, 62)
        : Color.fromARGB(255, 226, 235, 248);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: headerColor,
        elevation: 0,
        scrolledUnderElevation: 0,
        actions: [
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
          IconButton(
            icon: const Icon(Icons.person_outline),
            onPressed: () {
              if (!mounted) return;
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AccountScreen()),
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
                // Search Bar (sticky)
                SliverPersistentHeader(
                  pinned: true,
                  delegate: _StickySearchBarDelegate(
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(40),
                          bottomRight: Radius.circular(40),
                        ),
                        color: headerColor,
                      ),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
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

class _StickySearchBarDelegate extends SliverPersistentHeaderDelegate {
  _StickySearchBarDelegate({required this.child});

  final Widget child;

  @override
  double get minExtent => 72;

  @override
  double get maxExtent => 72;

  @override
  Widget build(
    BuildContext context,
    double shrinkOffset,
    bool overlapsContent,
  ) {
    return child;
  }

  @override
  bool shouldRebuild(covariant _StickySearchBarDelegate oldDelegate) =>
      oldDelegate.child != child;
}
