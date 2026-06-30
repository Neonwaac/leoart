import 'package:flutter/material.dart';
import 'package:shared/core/design/app_radius.dart';
import 'package:shared/models/artwork.dart';
import 'package:shared/shared/widgets/hero_artwork_image.dart';

class ArtworkTile extends StatelessWidget {
  final Artwork artwork;
  final VoidCallback? onTap;

  const ArtworkTile({
    super.key,
    required this.artwork,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      type: MaterialType.transparency,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        splashColor: theme.colorScheme.onSurface.withAlpha(15),
        hoverColor: theme.colorScheme.onSurface.withAlpha(8),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: AspectRatio(
            aspectRatio: artwork.aspectRatio,
            child: HeroArtworkImage(
              imageUrl: artwork.imageUrl,
              heroTag: 'artwork_${artwork.id}',
              width: double.infinity,
              borderRadius: 0,
              fit: BoxFit.cover,
              blurHash: artwork.blurHash,
            ),
          ),
        ),
      ),
    );
  }
}
