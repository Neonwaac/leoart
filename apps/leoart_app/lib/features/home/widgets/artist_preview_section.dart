import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

class ArtistPreviewSection extends StatelessWidget {
  final Artist artist;

  const ArtistPreviewSection({super.key, required this.artist});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= AppSpacing.breakpointMedium;

    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.xl,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'El artista',
            style: theme.textTheme.titleLarge?.copyWith(
              fontWeight: FontWeight.w600,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ArtistPreviewCard(
            artist: artist,
            imageSize: isWide ? 160 : 120,
            heroTag: 'home_artist_${artist.id}',
            onTap: () => context.push('/artist'),
          ),
          const SizedBox(height: AppSpacing.lg),
          SizedBox(
            width: double.infinity,
            child: SecondaryButton(
              label: 'Conocer más',
              onPressed: () => context.push('/artist'),
            ),
          ),
        ],
      ),
    );
  }
}
