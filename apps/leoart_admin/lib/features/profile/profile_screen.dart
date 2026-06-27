import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Perfil',
      subtitle: 'Información del administrador',
      icon: Icons.person_outlined,
      description:
          'Gestiona tu perfil de administrador y las credenciales '
          'de acceso.',
    );
  }
}
