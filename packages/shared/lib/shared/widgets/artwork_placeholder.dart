import 'package:flutter/material.dart';
import 'package:shared/core/design/app_radius.dart';

class ArtworkPlaceholder extends StatelessWidget {
  final double aspectRatio;

  const ArtworkPlaceholder({super.key, this.aspectRatio = 1.0});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppRadius.md),
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.surfaceContainerHigh,
                theme.colorScheme.surfaceContainerLow,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
