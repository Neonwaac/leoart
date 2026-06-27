import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class ArtworksScreen extends StatelessWidget {
  const ArtworksScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Obras',
      subtitle: 'Gestión de obras',
      icon: Icons.image_outlined,
      description:
          'Administra el catálogo de obras: añade, edita o elimina obras '
          'del catálogo.',
    );
  }
}
