import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'features/auth/auth_provider.dart';
import 'features/auth/login_screen.dart';
import 'features/auth/signup_screen.dart';
import 'features/home/home_screen.dart';
import 'features/ingredients/add_ingredient_screen.dart';
import 'features/recipes/recipe_screen.dart';
import 'features/recipes/recipe_detail_screen.dart';
import 'features/recipes/recipe_model.dart';

final appRouter = GoRouter(
  initialLocation: '/login',
  redirect: (context, state) {
    final container = ProviderScope.containerOf(context);
    final authState = container.read(authStateProvider);
    final isLoggedIn = authState.valueOrNull != null;
    final onAuthPage =
        state.matchedLocation == '/login' || state.matchedLocation == '/signup';

    if (!isLoggedIn && !onAuthPage) return '/login';
    if (isLoggedIn && onAuthPage) return '/home';
    return null;
  },
  routes: [
    GoRoute(path: '/login', builder: (_, __) => const LoginScreen()),
    GoRoute(path: '/signup', builder: (_, __) => const SignUpScreen()),
    GoRoute(path: '/home', builder: (_, __) => const HomeScreen()),
    GoRoute(
      path: '/add-ingredient',
      builder: (_, __) => const AddIngredientScreen(),
    ),
    GoRoute(path: '/recipes', builder: (_, __) => const RecipeScreen()),
    GoRoute(
      path: '/recipe-detail',
      builder: (context, state) {
        final recipe = state.extra as Recipe;
        return RecipeDetailScreen(recipe: recipe);
      },
    ),
  ],
);
