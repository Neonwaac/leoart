import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const PlaceholderScreen(
      title: 'Iniciar Sesión',
      subtitle: 'Panel de Administración',
      icon: Icons.lock_outlined,
      description:
          'Accede con tu cuenta de administrador para gestionar las obras, '
          'colecciones y técnicas del catálogo.',
    );
  }
}
