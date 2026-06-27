import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class ArtistHeader extends StatelessWidget {
  final Artist artist;
  final String quote;
  final String? profession;

  const ArtistHeader({
    super.key,
    required this.artist,
    required this.quote,
    this.profession,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= AppSpacing.breakpointMedium;
    final hasPhoto =
        artist.photoUrl != null && artist.photoUrl!.isNotEmpty;

    final photo = Hero(
      tag: 'artist_photo_${artist.id}',
      child: AspectRatio(
        aspectRatio: 0.75,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: hasPhoto
              ? Image.network(
                  artist.photoUrl!,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      _PhotoPlaceholder(theme: theme),
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) return child;
                    return _PhotoPlaceholder(theme: theme);
                  },
                )
              : _PhotoPlaceholder(theme: theme),
        ),
      ),
    );

    final textContent = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          artist.name,
          style: theme.textTheme.displaySmall?.copyWith(
            fontWeight: FontWeight.w300,
            letterSpacing: -1.0,
            height: 1.1,
          ),
        ),
        if (profession != null) ...[
          const SizedBox(height: AppSpacing.sm),
          Text(
            profession!,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
        ],
        const SizedBox(height: AppSpacing.xl),
        Text(
          quote,
          style: theme.textTheme.bodyLarge?.copyWith(
            fontStyle: FontStyle.italic,
            color: theme.colorScheme.onSurface.withAlpha(180),
            height: 1.6,
          ),
        ),
      ],
    );

    if (isWide) {
      return Padding(
        padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: width * 0.35,
              child: photo,
            ),
            const SizedBox(width: AppSpacing.xl),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: AppSpacing.sm),
                child: textContent,
              ),
            ),
          ],
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        photo,
        const SizedBox(height: AppSpacing.xl),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
          child: textContent,
        ),
      ],
    );
  }
}

class _PhotoPlaceholder extends StatelessWidget {
  final ThemeData theme;

  const _PhotoPlaceholder({required this.theme});

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
          Icons.person_outlined,
          size: 64,
          color: theme.colorScheme.onSurfaceVariant.withAlpha(60),
        ),
      ),
    );
  }
}
