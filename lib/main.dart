import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:re_serve/core/config/env_config.dart';
import 'package:re_serve/presentation/bloc/auth/auth_bloc.dart';
import 'package:re_serve/presentation/bloc/auth/auth_event.dart';
import 'package:re_serve/presentation/bloc/auth/auth_state.dart';
import 'package:re_serve/presentation/bloc/food/food_bloc.dart';
import 'package:re_serve/presentation/bloc/food/food_event.dart';
import 'package:re_serve/presentation/bloc/cart/cart_bloc.dart';
import 'package:re_serve/presentation/bloc/rating/rating_bloc.dart';
import 'package:re_serve/presentation/bloc/transaction/transaction_bloc.dart';
import 'package:re_serve/data/repositories/auth_repository.dart';
import 'package:re_serve/data/repositories/food_repository.dart';
import 'package:re_serve/data/repositories/cart_repository.dart';
import 'package:re_serve/data/repositories/rating_repository.dart';
import 'package:re_serve/data/repositories/payment_repository.dart';
import 'package:re_serve/data/repositories/transaction_repository.dart';
import 'package:re_serve/presentation/screen/auth/login_screen.dart';
import 'package:re_serve/presentation/screen/auth/register_screen.dart';
import 'package:re_serve/presentation/screen/explore/exploration.dart';
import 'package:re_serve/presentation/screen/onboarding/onboarding_screen.dart';
import 'presentation/theme/app_theme.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EnvConfig.load();
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (_) =>
              AuthBloc(authRepository: AuthRepository())
                ..add(const AuthCheckRequested()),
        ),
        BlocProvider(
          create: (_) =>
              FoodBloc(foodRepository: FoodRepository())
                ..add(const FoodFetchRequested()),
        ),
        BlocProvider(
          create: (_) => CartBloc(cartRepository: CartRepository()),
        ),
        BlocProvider(
          create: (_) => RatingBloc(ratingRepository: RatingRepository()),
        ),
        BlocProvider(
          create: (_) => TransactionBloc(
            transactionRepository: TransactionRepository(),
            paymentRepository: PaymentRepository(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme(),
        darkTheme: AppTheme.darkTheme(),
        themeMode: ThemeMode.system,
        routes: {
          '/onboarding': (_) => const OnboardingScreen(),
          '/login': (_) => const LoginScreen(),
          '/register': (_) => const RegisterScreen(),
          '/explore': (_) => const ExploreScreen(),
        },
        home: BlocBuilder<AuthBloc, AuthState>(
          builder: (context, state) {
            switch (state.status) {
              case AuthStatus.authenticated:
                return const ExploreScreen();
              case AuthStatus.loading:
                return const _SplashScreen();
              case AuthStatus.unauthenticated:
              case AuthStatus.failure:
              case AuthStatus.initial:
                return const OnboardingScreen();
            }
          },
        ),
      ),
    );
  }
}

class _SplashScreen extends StatelessWidget {
  const _SplashScreen();

  @override
  Widget build(BuildContext context) {
    return const Scaffold(body: Center(child: CircularProgressIndicator()));
  }
}
