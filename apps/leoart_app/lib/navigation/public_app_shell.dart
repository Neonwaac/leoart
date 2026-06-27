import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

class PublicAppShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const PublicAppShell({super.key, required this.navigationShell});

  static final _shellRoutes = <String>{'/', '/catalog', '/collections', '/artist'};

  static const _navItems = <_NavItem>[
    _NavItem(
      label: 'Inicio',
      icon: Icons.home_outlined,
      activeIcon: Icons.home,
    ),
    _NavItem(
      label: 'Catálogo',
      icon: Icons.grid_view_outlined,
      activeIcon: Icons.grid_view,
    ),
    _NavItem(
      label: 'Colecciones',
      icon: Icons.collections_bookmark_outlined,
      activeIcon: Icons.collections_bookmark,
    ),
    _NavItem(
      label: 'Artista',
      icon: Icons.person_outlined,
      activeIcon: Icons.person,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= AppSpacing.breakpointMedium;
    final matchedLocation = GoRouterState.of(context).matchedLocation;
    final showBottomNav = _shellRoutes.contains(matchedLocation);

    return LayoutBuilder(
      builder: (context, constraints) {
        if (isWide) {
          return _WideLayout(navigationShell: navigationShell, showBottomNav: showBottomNav);
        }
        return _CompactLayout(navigationShell: navigationShell, showBottomNav: showBottomNav);
      },
    );
  }
}

class _CompactLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final bool showBottomNav;

  const _CompactLayout({required this.navigationShell, required this.showBottomNav});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: navigationShell,
      bottomNavigationBar: showBottomNav
          ? NavigationBar(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
              destinations: PublicAppShell._navItems
                  .map(
                    (item) => NavigationDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.activeIcon),
                      label: item.label,
                    ),
                  )
                  .toList(),
            )
          : null,
    );
  }
}

class _WideLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final bool showBottomNav;

  const _WideLayout({required this.navigationShell, required this.showBottomNav});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Row(
        children: [
          if (showBottomNav)
            NavigationRail(
              selectedIndex: navigationShell.currentIndex,
              onDestinationSelected: (index) {
                navigationShell.goBranch(
                  index,
                  initialLocation: index == navigationShell.currentIndex,
                );
              },
              labelType: NavigationRailLabelType.all,
              groupAlignment: 0.0,
              leading: Padding(
                padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
                child: Center(
                  child: Text(
                    'LA',
                    style: theme.textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: theme.colorScheme.primary,
                    ),
                  ),
                ),
              ),
              destinations: PublicAppShell._navItems
                  .map(
                    (item) => NavigationRailDestination(
                      icon: Icon(item.icon),
                      selectedIcon: Icon(item.activeIcon),
                      label: Text(item.label),
                    ),
                  )
                  .toList(),
            ),
          if (showBottomNav) const VerticalDivider(width: 1, thickness: 1),
          Expanded(child: navigationShell),
        ],
      ),
    );
  }
}

class _NavItem {
  final String label;
  final IconData icon;
  final IconData activeIcon;

  const _NavItem({
    required this.label,
    required this.icon,
    required this.activeIcon,
  });
}
