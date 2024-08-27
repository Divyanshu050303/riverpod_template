import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:instagram_clone/services/hive/hive.dart';
import 'package:instagram_clone/utils/dependency_injection/riverpod/di.dart';

class AppRouteGaurd {
  final HiveBoxServices _hive = locator<HiveBoxServices>();
  checkAuth(BuildContext context, GoRouterState state) {
// todo user info here
    final user = _hive.get(_hive.userBox, 'user');
    if (user != null && user.accessToken != null) {
      return null;
    }
    return '/signin';
  }
}
