import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AppRedirects {
  AppRedirects._();

  static String? Function(BuildContext, GoRouterState) adminRedirect(
    WidgetRef ref,
  ) {
    return (context, state) {
      return null;
    };
  }
}
