import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Dashboard',
      subtitle: 'Panel de control',
      icon: Icons.dashboard_outlined,
      description:
          'Resumen del catálogo: obras, colecciones, técnicas y '
          'actividad reciente.',
    );
  }
}
