import 'package:flutter/material.dart';
import 'package:shared/core/design/app_radius.dart';
import 'package:shared/core/design/app_spacing.dart';
import 'package:shared/models/artwork.dart';
import 'package:shared/shared/widgets/artwork_metadata.dart';
import 'package:shared/shared/widgets/hero_artwork_image.dart';

class FeaturedArtworkCard extends StatelessWidget {
  final Artwork artwork;
  final String? techniqueName;
  final VoidCallback? onTap;
  final double height;

  const FeaturedArtworkCard({
    super.key,
    required this.artwork,
    this.techniqueName,
    this.onTap,
    this.height = 420,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: height,
            width: double.infinity,
            child: Stack(
              children: [
                HeroArtworkImage(
                  imageUrl: artwork.imageUrl,
                  heroTag: 'artwork_${artwork.id}',
                  width: double.infinity,
                  borderRadius: AppRadius.md,
                  aspectRatio: artwork.aspectRatio,
                  fit: BoxFit.cover,
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxs),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artwork.title,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.3,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: AppSpacing.xs),
                ArtworkMetadata(technique: techniqueName),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
