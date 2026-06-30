import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../features/login/auth_providers.dart';
import 'app_routes.dart';

class AppRedirects {
  AppRedirects._();

  static String? Function(BuildContext, GoRouterState) adminRedirect(
    Ref ref,
  ) {
    return (context, state) {
      final authState = ref.read(authStateChangesProvider);
      final isAuthenticated = authState.valueOrNull != null;
      final isOnLogin = state.matchedLocation == AppRoutes.login;

      if (!isAuthenticated && !isOnLogin) {
        return AppRoutes.login;
      }
      if (isAuthenticated && isOnLogin) {
        return AppRoutes.dashboard;
      }
      return null;
    };
  }
}
