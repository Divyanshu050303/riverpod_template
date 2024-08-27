import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/routers/routes.dart';

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class AppRoutes {
  static final GoRouter _router = GoRouter(
    initialLocation: Routes.splash,
    navigatorKey: navigatorKey,
    routes: [
      GoRoute(
        path: Routes.splash,
        builder: (BuildContext context, GoRouterState state) {
          return const Text("Splash");
        },
      )
    ],
  );
  static GoRouter get appRouter => _router;
}
