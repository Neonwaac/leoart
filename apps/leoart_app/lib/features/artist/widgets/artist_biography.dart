import 'package:flutter/material.dart';

class ArtistBiography extends StatelessWidget {
  final String text;
  final double maxWidth;

  const ArtistBiography({
    super.key,
    required this.text,
    this.maxWidth = 680,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Center(
      child: SizedBox(
        width: maxWidth,
        child: Text(
          text,
          style: theme.textTheme.bodyLarge?.copyWith(
            height: 1.8,
            color: theme.colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
