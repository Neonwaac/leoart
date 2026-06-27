import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

class FeaturedArtworkSection extends StatelessWidget {
  final Artwork artwork;
  final String? techniqueName;

  const FeaturedArtworkSection({
    super.key,
    required this.artwork,
    this.techniqueName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isWide =
        MediaQuery.sizeOf(context).width > AppSpacing.breakpointMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Obra destacada',
                  style: theme.textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: AppSpacing.xxs),
                Text(
                  'Selección del mes',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          FeaturedArtworkCard(
            artwork: artwork,
            techniqueName: techniqueName,
            height: isWide ? 560 : 360,
            onTap: () {
              if (artwork.id != null) {
                context.push('/catalog/${artwork.id}');
              }
            },
          ),
        ],
      ),
    );
  }
}
