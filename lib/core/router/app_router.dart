import 'package:go_router/go_router.dart';

import '../../features/presentation/pages/add_product_page.dart';
import '../../features/presentation/pages/detail_page.dart';
import '../../features/presentation/pages/favorite_page.dart';
import '../../features/presentation/pages/home_page.dart';
import '../../features/presentation/pages/splash_page.dart';

class AppRouter {
  static final router = GoRouter(
    initialLocation: '/',
    routes: [
      GoRoute(
          path: '/',
          builder: (context, state) => const SplashPage()
      ),
      GoRoute(
          path: '/home',
          builder: (context, state) => const HomePage()
      ),
      GoRoute(
        path: '/detail/:id',
        builder: (context, state) {
          // ambil id dari path parameter
          // seperti Safe Args di Android
          final id = int.parse(state.pathParameters['id']!);
          return DetailPage(productId: id);
        },
      ),
      GoRoute(
        path: '/favorite',
        builder: (context, state) => const FavoritePage(),
      ),
      GoRoute(
        path: '/add-product',
        builder: (context, state) => const AddProductPage(),
      ),
    ],
  );
}
