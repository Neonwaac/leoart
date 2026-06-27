import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Configuración',
      subtitle: 'Ajustes de la aplicación',
      icon: Icons.settings_outlined,
      description:
          'Configura los parámetros generales de la aplicación, incluyendo '
          'Cloudinary, Firebase y preferencias visuales.',
    );
  }
}
