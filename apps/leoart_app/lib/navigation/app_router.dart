import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../features/features.dart';
import 'app_routes.dart';
import 'public_app_shell.dart';
import 'route_names.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: AppRoutes.home,
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) =>
          PublicAppShell(navigationShell: navigationShell),
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.home,
              name: RouteNames.home,
              builder: (context, state) => const HomeScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.catalog,
              name: RouteNames.catalog,
              builder: (context, state) {
                final collectionId =
                    state.uri.queryParameters['collectionId'];
                return CatalogScreen(collectionId: collectionId);
              },
              routes: [
                GoRoute(
                  path: ':artworkId',
                  name: RouteNames.artworkDetail,
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) {
                    final artworkId = state.pathParameters['artworkId']!;
                    return ArtworkDetailScreen(artworkId: artworkId);
                  },
                ),
              ],
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.collections,
              name: RouteNames.collections,
              builder: (context, state) => const CollectionsScreen(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: AppRoutes.artist,
              name: RouteNames.artist,
              builder: (context, state) => const ArtistScreen(),
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.contact,
      name: RouteNames.contact,
      parentNavigatorKey: _rootNavigatorKey,
      builder: (context, state) => const ContactScreen(),
    ),
  ],
);
