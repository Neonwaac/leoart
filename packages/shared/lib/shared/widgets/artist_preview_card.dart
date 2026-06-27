import 'package:flutter/material.dart';
import 'package:shared/core/design/app_radius.dart';
import 'package:shared/core/design/app_spacing.dart';
import 'package:shared/models/artist.dart';

class ArtistPreviewCard extends StatelessWidget {
  final Artist artist;
  final VoidCallback? onTap;
  final double imageSize;
  final String? heroTag;

  const ArtistPreviewCard({
    super.key,
    required this.artist,
    this.onTap,
    this.imageSize = 120,
    this.heroTag,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasPhoto = artist.photoUrl != null && artist.photoUrl!.isNotEmpty;

    final photo = Container(
      width: imageSize,
      height: imageSize,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(AppRadius.full),
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surfaceContainerHigh,
            theme.colorScheme.surfaceContainerLow,
          ],
        ),
      ),
      child: hasPhoto
          ? ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.full),
              child: Image.network(
                artist.photoUrl!,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) =>
                    _photoPlaceholder(theme),
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return _photoPlaceholder(theme);
                },
              ),
            )
          : _photoPlaceholder(theme),
    );

    return GestureDetector(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          heroTag != null ? Hero(tag: heroTag!, child: photo) : photo,
          const SizedBox(width: AppSpacing.xl),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artist.name,
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: AppSpacing.sm),
                if (artist.bio != null && artist.bio!.isNotEmpty)
                  Text(
                    artist.bio!,
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                      height: 1.6,
                    ),
                    maxLines: 4,
                    overflow: TextOverflow.ellipsis,
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _photoPlaceholder(ThemeData theme) {
    return Center(
      child: Icon(
        Icons.person_outlined,
        size: imageSize * 0.4,
        color: theme.colorScheme.onSurfaceVariant.withAlpha(60),
      ),
    );
  }
}
