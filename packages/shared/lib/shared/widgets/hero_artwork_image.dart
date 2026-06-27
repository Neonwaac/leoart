import 'package:flutter/material.dart';
import 'package:shared/core/design/app_radius.dart';

class HeroArtworkImage extends StatelessWidget {
  final String? imageUrl;
  final String heroTag;
  final double? width;
  final double aspectRatio;
  final double borderRadius;
  final BoxFit fit;

  const HeroArtworkImage({
    super.key,
    this.imageUrl,
    required this.heroTag,
    this.width,
    this.aspectRatio = 1.0,
    this.borderRadius = AppRadius.md,
    this.fit = BoxFit.cover,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    final imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: hasImage
          ? Image.network(
              imageUrl!,
              width: width,
              fit: fit,
              errorBuilder: (context, error, stackTrace) =>
                  _Placeholder(theme: theme),
              loadingBuilder: (context, child, loadingProgress) {
                if (loadingProgress == null) return child;
                return _Placeholder(theme: theme);
              },
            )
          : _Placeholder(theme: theme),
    );

    return Hero(
      tag: heroTag,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: imageWidget,
      ),
    );
  }
}

class _Placeholder extends StatelessWidget {
  final ThemeData theme;

  const _Placeholder({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 48,
          color: theme.colorScheme.onSurfaceVariant.withAlpha(60),
        ),
      ),
    );
  }
}
