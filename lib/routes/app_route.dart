import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tb_kelompok1_b/screens/main_author_screen.dart';
import 'package:tb_kelompok1_b/screens/main_screen.dart';
import '../screens/login_screen.dart';
import '../screens/register_screen.dart';
import '../screens/splash_screen.dart';
import '../screens/login_author_screen.dart';
import 'package:tb_kelompok1_b/screens/news_detail_screen.dart';
import 'route_names.dart';
import '../controller/auth_author_controller.dart';

class AppRouter {
  AppRouter._();

  static final AppRouter _instance = AppRouter._();

  static AppRouter get instance => _instance;

  factory AppRouter() {
    _instance.goRouter = goRouterSetup();

    return _instance;
  }

  GoRouter? goRouter;

  static GoRouter goRouterSetup() {
    return GoRouter(
      routes: [
        GoRoute(
          path: '/',
          name: RouteNames.splash,
          pageBuilder:
              (context, state) =>
                  MaterialPage(key: state.pageKey, child: SplashScreen()),
        ),
        GoRoute(
          path: '/login',
          name: RouteNames.login,
          pageBuilder:
              (context, state) =>
                  MaterialPage(key: state.pageKey, child: LoginScreen()),
        ),
        GoRoute(
          path: '/register',
          name: RouteNames.register,
          pageBuilder:
              (context, state) =>
                  MaterialPage(key: state.pageKey, child: RegisterScreen()),
        ),
        GoRoute(
          path: '/main',
          name: RouteNames.main,
          pageBuilder:
              (context, state) =>
                  MaterialPage(key: state.pageKey, child: MainScreen()),
        ),
        GoRoute(
          path: '/news/:id',
          name: 'newsDetail',
          pageBuilder: (context, state) {
            final id = state.pathParameters['id']!;
            return MaterialPage(
              key: state.pageKey,
              child: NewsDetailScreen(newsId: id),
            );
          },
        ),
        GoRoute(
          path: '/author',
          name: RouteNames.author,
          redirect: (context, state) {
            final isLoggedIn =
                AuthAuthorController.instance?.isLoggedIn ?? false;
            final isLoggingIn = state.fullPath == '/author/login';

            if (!isLoggedIn && !isLoggingIn) return '/author/login';
            if (isLoggedIn && isLoggingIn) return '/author/home';

            return null;
          },
          routes: [
            GoRoute(
              path: 'login', // ✅ path RELATIF, tanpa /
              name: RouteNames.loginAuthor,
              pageBuilder:
                  (context, state) => MaterialPage(
                    key: state.pageKey,
                    child: LoginAuthorScreen(),
                  ),
            ),
            GoRoute(
              path: 'home',
              name: RouteNames.mainAuthor,
              pageBuilder:
                  (context, state) => MaterialPage(
                    key: state.pageKey,
                    child: MainAuthorScreen(),
                  ),
            ),
          ],
        ),
      ],
    );
  }
}
