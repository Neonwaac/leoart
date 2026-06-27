import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class CollectionsScreen extends StatelessWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Colecciones',
      subtitle: 'Gestión de colecciones',
      icon: Icons.collections_bookmark_outlined,
      description:
          'Administra las colecciones: organiza las obras en series '
          'temáticas y define su orden de visualización.',
    );
  }
}
