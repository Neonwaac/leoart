import 'package:flutter/material.dart';
import 'package:shared/core/design/app_spacing.dart';
import 'package:shared/models/collection.dart';
import 'package:shared/shared/widgets/collection_hero_image.dart';
import 'package:shared/shared/widgets/collection_info.dart';

enum CollectionCardVariant { featured, standard }

class CollectionCard extends StatelessWidget {
  final Collection collection;
  final CollectionCardVariant variant;
  final VoidCallback? onTap;
  final int? artworkCount;

  const CollectionCard({
    super.key,
    required this.collection,
    this.variant = CollectionCardVariant.standard,
    this.onTap,
    this.artworkCount,
  });

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      CollectionCardVariant.featured => _FeaturedCard(
          collection: collection,
          onTap: onTap,
          artworkCount: artworkCount,
        ),
      CollectionCardVariant.standard => _StandardCard(
          collection: collection,
          onTap: onTap,
          artworkCount: artworkCount,
        ),
    };
  }
}

class _FeaturedCard extends StatelessWidget {
  final Collection collection;
  final VoidCallback? onTap;
  final int? artworkCount;

  const _FeaturedCard({
    required this.collection,
    this.onTap,
    this.artworkCount,
  });

  @override
  Widget build(BuildContext context) {
    final heroTag = 'home_collection_${collection.id}';

    final image = CollectionHeroImage(
      imageUrl: collection.coverImageUrl,
      heroTag: heroTag,
      aspectRatio: 16 / 9,
    );

    final info = CollectionInfo(
      name: collection.name,
      description: collection.description,
      artworkCount: artworkCount,
      compact: true,
    );

    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 400;

        if (isWide) {
          return GestureDetector(
            onTap: onTap,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: constraints.maxWidth * 0.55,
                  child: image,
                ),
                const SizedBox(width: AppSpacing.xl),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                    child: info,
                  ),
                ),
              ],
            ),
          );
        }

        return GestureDetector(
          onTap: onTap,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              image,
              const SizedBox(height: AppSpacing.md),
              info,
            ],
          ),
        );
      },
    );
  }
}

class _StandardCard extends StatelessWidget {
  final Collection collection;
  final VoidCallback? onTap;
  final int? artworkCount;

  const _StandardCard({
    required this.collection,
    this.onTap,
    this.artworkCount,
  });

  @override
  Widget build(BuildContext context) {
    final heroTag = 'collections_collection_${collection.id}';

    return GestureDetector(
      onTap: onTap,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          CollectionHeroImage(
            imageUrl: collection.coverImageUrl,
            heroTag: heroTag,
            aspectRatio: 16 / 9,
          ),
          const SizedBox(height: AppSpacing.xl),
          CollectionInfo(
            name: collection.name,
            description: collection.description,
            artworkCount: artworkCount,
          ),
        ],
      ),
    );
  }
}
