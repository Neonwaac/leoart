import 'package:flutter/material.dart';

class ArtworkDescription extends StatelessWidget {
  final String? text;

  const ArtworkDescription({super.key, this.text});

  @override
  Widget build(BuildContext context) {
    if (text == null || text!.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Semantics(
      label: 'Descripción de la obra',
      child: Text(
        text!,
        style: theme.textTheme.bodyLarge?.copyWith(
          height: 1.75,
          letterSpacing: 0.2,
        ),
      ),
    );
  }
}
