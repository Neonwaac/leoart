import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../features/features.dart';
import 'admin_app_shell.dart';
import 'app_routes.dart';
import 'redirects.dart';
import 'route_names.dart';

final _rootNavigatorKey = GlobalKey<NavigatorState>();

final appRouterProvider = Provider<GoRouter>((ref) {
  final authNotifier = ref.watch(authNotifierProvider);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.login,
    refreshListenable: authNotifier,
    redirect: AppRedirects.adminRedirect(ref),
    routes: [
      GoRoute(
        path: AppRoutes.login,
        name: RouteNames.login,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const LoginScreen(),
      ),
      StatefulShellRoute.indexedStack(
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state, navigationShell) =>
            AdminAppShell(navigationShell: navigationShell),
        branches: [
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.dashboard,
                name: RouteNames.dashboard,
                builder: (context, state) => const DashboardScreen(),
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.artworks,
                name: RouteNames.artworks,
                builder: (context, state) => const ArtworksScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    name: RouteNames.artworksNew,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const ArtworkFormScreen(),
                  ),
                  GoRoute(
                    path: ':artworkId/edit',
                    name: RouteNames.artworksEdit,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final artworkId = state.pathParameters['artworkId']!;
                      return ArtworkFormScreen(artworkId: artworkId);
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
                routes: [
                  GoRoute(
                    path: 'new',
                    name: RouteNames.collectionsNew,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const CollectionFormScreen(),
                  ),
                  GoRoute(
                    path: ':collectionId/edit',
                    name: RouteNames.collectionsEdit,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final collectionId = state.pathParameters['collectionId']!;
                      return CollectionFormScreen(collectionId: collectionId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.techniques,
                name: RouteNames.techniques,
                builder: (context, state) => const TechniquesScreen(),
                routes: [
                  GoRoute(
                    path: 'new',
                    name: RouteNames.techniquesNew,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) => const TechniqueFormScreen(),
                  ),
                  GoRoute(
                    path: ':techniqueId/edit',
                    name: RouteNames.techniquesEdit,
                    parentNavigatorKey: _rootNavigatorKey,
                    builder: (context, state) {
                      final techniqueId = state.pathParameters['techniqueId']!;
                      return TechniqueFormScreen(techniqueId: techniqueId);
                    },
                  ),
                ],
              ),
            ],
          ),
          StatefulShellBranch(
            routes: [
              GoRoute(
                path: AppRoutes.settings,
                name: RouteNames.settings,
                builder: (context, state) => const SettingsScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: AppRoutes.artworksFeatured,
        name: RouteNames.artworksFeatured,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const FeaturedEditorScreen(),
      ),
      GoRoute(
        path: AppRoutes.collectionsOrder,
        name: RouteNames.collectionsOrder,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const CollectionsOrderScreen(),
      ),
      GoRoute(
        path: AppRoutes.profile,
        name: RouteNames.profile,
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ProfileScreen(),
      ),
    ],
  );
});
