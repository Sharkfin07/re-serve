import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_serve/presentation/bloc/food/food_bloc.dart';
import 'package:re_serve/presentation/bloc/food/food_event.dart';
import 'package:re_serve/presentation/bloc/food/food_state.dart';
import 'package:re_serve/presentation/screen/food/food_detail_screen.dart';
import 'package:re_serve/presentation/widgets/food/food_card.dart';

class LikedFoodsScreen extends StatefulWidget {
  const LikedFoodsScreen({super.key});

  @override
  State<LikedFoodsScreen> createState() => _LikedFoodsScreenState();
}

class _LikedFoodsScreenState extends State<LikedFoodsScreen> {
  @override
  void initState() {
    super.initState();
    context.read<FoodBloc>().add(const FoodLikedFetchRequested());
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final foodBloc = context.read<FoodBloc>();

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Liked Foods',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.onSurface,
          ),
        ),
        centerTitle: true,
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
          onPressed: () => Navigator.pop(context),
        ),
      ),
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
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.errorMessage ?? 'An error occurred',
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      foodBloc.add(const FoodLikedFetchRequested());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.likedFoods.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_outline,
                    size: 80,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No liked foods yet',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Like some foods to see them here',
                    style: TextStyle(
                      color:
                          theme.colorScheme.onSurface.withValues(alpha: 0.5),
                    ),
                  ),
                ],
              ),
            );
          }

          return RefreshIndicator(
            onRefresh: () async {
              foodBloc.add(const FoodLikedFetchRequested());
            },
            child: ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: state.likedFoods.length,
              itemBuilder: (context, index) {
                final food = state.likedFoods[index];
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
              },
            ),
          );
        },
      ),
    );
  }
}
