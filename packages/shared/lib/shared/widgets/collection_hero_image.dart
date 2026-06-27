import 'package:flutter/material.dart';
import 'package:shared/core/design/app_radius.dart';

class CollectionHeroImage extends StatelessWidget {
  final String? imageUrl;
  final String? heroTag;
  final double aspectRatio;
  final double borderRadius;

  const CollectionHeroImage({
    super.key,
    this.imageUrl,
    this.heroTag,
    this.aspectRatio = 16 / 9,
    this.borderRadius = AppRadius.md,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    Widget image = AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: hasImage
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _Placeholder(theme: theme),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _Placeholder(theme: theme);
                },
              )
            : _Placeholder(theme: theme),
      ),
    );

    if (heroTag != null) {
      image = Hero(tag: heroTag!, child: image);
    }

    return image;
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
          Icons.collections_outlined,
          size: 48,
          color: theme.colorScheme.onSurfaceVariant.withAlpha(60),
        ),
      ),
    );
  }
}
