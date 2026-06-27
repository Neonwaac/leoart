import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class TechniquesScreen extends StatelessWidget {
  const TechniquesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Técnicas',
      subtitle: 'Gestión de técnicas',
      icon: Icons.brush_outlined,
      description:
          'Administra las técnicas artísticas utilizadas en las obras.',
    );
  }
}
