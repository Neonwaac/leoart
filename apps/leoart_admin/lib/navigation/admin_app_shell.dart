import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

class AdminAppShell extends ConsumerWidget {
  final StatefulNavigationShell navigationShell;

  const AdminAppShell({super.key, required this.navigationShell});

  static const _navItems = <_NavItem>[
    _NavItem(
      label: 'Dashboard',
      icon: Icons.dashboard_outlined,
      activeIcon: Icons.dashboard,
    ),
    _NavItem(
      label: 'Obras',
      icon: Icons.image_outlined,
      activeIcon: Icons.image,
    ),
    _NavItem(
      label: 'Colecciones',
      icon: Icons.collections_bookmark_outlined,
      activeIcon: Icons.collections_bookmark,
    ),
    _NavItem(
      label: 'Técnicas',
      icon: Icons.brush_outlined,
      activeIcon: Icons.brush,
    ),
    _NavItem(
      label: 'Ajustes',
      icon: Icons.settings_outlined,
      activeIcon: Icons.settings,
    ),
  ];

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= AppSpacing.breakpointMedium;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (isWide) {
          return _WideLayout(navigationShell: navigationShell, ref: ref);
        }
        return _CompactLayout(navigationShell: navigationShell, ref: ref);
      },
    );
  }
}

class _CompactLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final WidgetRef ref;

  const _CompactLayout({required this.navigationShell, required this.ref});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void signOut() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro de cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      );
      if (confirmed == true) {
        final authService = ref.read(authServiceProvider);
        await authService.signOut();
      }
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('LeoArt Admin'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_outlined),
            tooltip: 'Perfil',
            onPressed: () => context.go('/profile'),
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(
              decoration: BoxDecoration(
                color: theme.colorScheme.primaryContainer,
              ),
              child: Text('LeoArt Admin', style: theme.textTheme.titleLarge),
            ),
            ...List.generate(AdminAppShell._navItems.length, (index) {
              final item = AdminAppShell._navItems[index];
              final selected = navigationShell.currentIndex == index;
              return ListTile(
                leading: Icon(selected ? item.activeIcon : item.icon),
                title: Text(item.label),
                selected: selected,
                onTap: () {
                  navigationShell.goBranch(
                    index,
                    initialLocation: index == navigationShell.currentIndex,
                  );
                  Scaffold.of(context).closeDrawer();
                },
              );
            }),
            const Divider(),
            ListTile(
              leading: const Icon(Icons.logout),
              title: const Text('Cerrar sesión'),
              onTap: signOut,
            ),
          ],
        ),
      ),
      body: navigationShell,
    );
  }
}

class _WideLayout extends StatelessWidget {
  final StatefulNavigationShell navigationShell;
  final WidgetRef ref;

  const _WideLayout({required this.navigationShell, required this.ref});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    void signOut() async {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Cerrar sesión'),
          content: const Text('¿Estás seguro de cerrar sesión?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(false),
              child: const Text('Cancelar'),
            ),
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(true),
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Cerrar sesión'),
            ),
          ],
        ),
      );
      if (confirmed == true) {
        final authService = ref.read(authServiceProvider);
        await authService.signOut();
      }
    }

    return Scaffold(
      body: Row(
        children: [
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
            trailing: Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.md),
              child: Column(
                children: [
                  IconButton(
                    icon: const Icon(Icons.person_outlined),
                    tooltip: 'Perfil',
                    onPressed: () => context.go('/profile'),
                  ),
                  IconButton(
                    icon: const Icon(Icons.logout),
                    tooltip: 'Cerrar sesión',
                    onPressed: signOut,
                  ),
                ],
              ),
            ),
            destinations: AdminAppShell._navItems
                .map(
                  (item) => NavigationRailDestination(
                    icon: Icon(item.icon),
                    selectedIcon: Icon(item.activeIcon),
                    label: Text(item.label),
                  ),
                )
                .toList(),
          ),
          const VerticalDivider(width: 1, thickness: 1),
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
