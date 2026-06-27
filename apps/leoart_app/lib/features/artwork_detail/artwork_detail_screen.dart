import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';
import '../../providers/artwork_providers.dart';
import '../../providers/collections_providers.dart';

class ArtworkDetailScreen extends ConsumerWidget {
  final String artworkId;

  const ArtworkDetailScreen({super.key, required this.artworkId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artworkAsync = ref.watch(artworkProvider(artworkId));
    final techniquesAsync = ref.watch(techniquesProvider);
    final collectionsAsync = ref.watch(collectionsProvider);
    final catalogAsync = ref.watch(catalogProvider);

    final techniqueMap = <String?, String>{};
    for (final t in techniquesAsync.valueOrNull ?? []) {
      if (t.id != null) techniqueMap[t.id] = t.name;
    }

    final collectionMap = <String?, String>{};
    for (final c in collectionsAsync.valueOrNull ?? []) {
      if (c.id != null) collectionMap[c.id] = c.name;
    }

    final relatedArtworks = (catalogAsync.valueOrNull ?? [])
        .where((a) => a.id != artworkId)
        .take(4)
        .toList();

    return Scaffold(
      appBar: LeoAppBar(showBack: true),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final isWide = constraints.maxWidth >= AppSpacing.breakpointMedium;
          return artworkAsync.when(
            loading: () => const LoadingIndicator(message: 'Cargando obra...'),
            error: (err, stack) => ErrorView(
              message: 'Error al cargar obra',
              details: err.toString(),
              icon: Icons.cloud_off_rounded,
              onRetry: () => ref.invalidate(artworkProvider(artworkId)),
            ),
            data: (artwork) {
              if (artwork == null) {
                return const Center(
                  child: EmptyState(
                    title: 'Obra no encontrada',
                    subtitle: 'La obra que buscas no está disponible.',
                    icon: Icons.image_not_supported_outlined,
                  ),
                );
              }

              if (isWide) {
                return _WideContent(
                  artwork: artwork,
                  techniqueMap: techniqueMap,
                  collectionMap: collectionMap,
                  relatedArtworks: relatedArtworks,
                );
              }

              return _CompactContent(
                artwork: artwork,
                techniqueMap: techniqueMap,
                collectionMap: collectionMap,
                relatedArtworks: relatedArtworks,
              );
            },
          );
        },
      ),
    );
  }
}

class _CompactContent extends StatelessWidget {
  final Artwork artwork;
  final Map<String?, String> techniqueMap;
  final Map<String?, String> collectionMap;
  final List<Artwork> relatedArtworks;

  const _CompactContent({
    required this.artwork,
    required this.techniqueMap,
    required this.collectionMap,
    required this.relatedArtworks,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final techniqueNames = artwork.techniqueIds
        .map((id) => techniqueMap[id] ?? '')
        .where((n) => n.isNotEmpty)
        .toList();
    final collectionNames = artwork.collectionIds
        .map((id) => collectionMap[id] ?? '')
        .where((n) => n.isNotEmpty)
        .toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          DetailHeroImage(
            imageUrl: artwork.imageUrl,
            heroTag: 'artwork_${artwork.id}',
            aspectRatio: artwork.aspectRatio,
          ),
          SizedBox(height: AppSpacing.sm),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artwork.title,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.5,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: AppSpacing.xs),
                if (techniqueNames.isNotEmpty)
                  Padding(
                    padding: EdgeInsets.only(bottom: AppSpacing.xl),
                    child: Wrap(
                      spacing: AppSpacing.xs,
                      runSpacing: AppSpacing.xs,
                      children: techniqueNames
                          .map((n) => Chip(
                                avatar: const Icon(Icons.brush_outlined,
                                    size: 14),
                                label: Text(n,
                                    style: theme.textTheme.labelSmall),
                                visualDensity: VisualDensity.compact,
                                materialTapTargetSize:
                                    MaterialTapTargetSize.shrinkWrap,
                                side: BorderSide.none,
                                backgroundColor:
                                    theme.colorScheme.surfaceContainerHigh,
                              ))
                          .toList(),
                    ),
                  ),
                SizedBox(height: AppSpacing.xl),
                ArtworkDescription(text: artwork.description),
                if (collectionNames.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.xl),
                  Text(
                    'Colecciones',
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.5,
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  SizedBox(height: AppSpacing.sm),
                  Wrap(
                    spacing: AppSpacing.xs,
                    runSpacing: AppSpacing.xs,
                    children: collectionNames
                        .map((n) => Chip(
                              avatar: const Icon(
                                  Icons.collections_bookmark_outlined,
                                  size: 14),
                              label: Text(n,
                                  style: theme.textTheme.labelSmall),
                              visualDensity: VisualDensity.compact,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              side: BorderSide.none,
                              backgroundColor:
                                  theme.colorScheme.surfaceContainerHigh,
                            ))
                        .toList(),
                  ),
                  SizedBox(height: AppSpacing.xl),
                ],
                if (relatedArtworks.isNotEmpty) ...[
                  Text(
                    'Obras relacionadas',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  _RelatedGrid(artworks: relatedArtworks),
                ],
              ],
            ),
          ),
          SizedBox(height: AppSpacing.xxl),
        ],
      ),
    );
  }
}

class _WideContent extends StatelessWidget {
  final Artwork artwork;
  final Map<String?, String> techniqueMap;
  final Map<String?, String> collectionMap;
  final List<Artwork> relatedArtworks;

  const _WideContent({
    required this.artwork,
    required this.techniqueMap,
    required this.collectionMap,
    required this.relatedArtworks,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final width = MediaQuery.sizeOf(context).width;
    final horizontalPadding = (width * 0.08).clamp(AppSpacing.xxl, 80.0);
    final columnGap = (width * 0.06).clamp(AppSpacing.xl, 64.0);

    final techniqueNames = artwork.techniqueIds
        .map((id) => techniqueMap[id] ?? '')
        .where((n) => n.isNotEmpty)
        .toList();
    final collectionNames = artwork.collectionIds
        .map((id) => collectionMap[id] ?? '')
        .where((n) => n.isNotEmpty)
        .toList();

    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: horizontalPadding),
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                      top: MediaQuery.of(context).padding.top +
                          AppSpacing.md),
                  child: DetailHeroImage(
                    imageUrl: artwork.imageUrl,
                    heroTag: 'artwork_${artwork.id}',
                    aspectRatio: artwork.aspectRatio,
                  ),
                ),
              ),
              SizedBox(width: columnGap),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top: MediaQuery.of(context).padding.top + AppSpacing.md,
                    bottom: AppSpacing.xl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        artwork.title,
                        style: theme.textTheme.displaySmall?.copyWith(
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.5,
                          height: 1.15,
                        ),
                      ),
                      SizedBox(height: AppSpacing.xs),
                      if (techniqueNames.isNotEmpty)
                        Padding(
                          padding: EdgeInsets.only(bottom: AppSpacing.xl),
                          child: Wrap(
                            spacing: AppSpacing.xs,
                            runSpacing: AppSpacing.xs,
                            children: techniqueNames
                                .map((n) => Chip(
                                      avatar: const Icon(Icons.brush_outlined,
                                          size: 14),
                                      label: Text(n,
                                          style: theme.textTheme.labelSmall),
                                      visualDensity: VisualDensity.compact,
                                      materialTapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      side: BorderSide.none,
                                      backgroundColor:
                                          theme.colorScheme.surfaceContainerHigh,
                                    ))
                                .toList(),
                          ),
                        ),
                      SizedBox(height: AppSpacing.xl),
                      ArtworkDescription(text: artwork.description),
                      if (collectionNames.isNotEmpty) ...[
                        SizedBox(height: AppSpacing.xl),
                        Text(
                          'Colecciones',
                          style: theme.textTheme.titleSmall?.copyWith(
                            fontWeight: FontWeight.w600,
                            letterSpacing: 0.5,
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        ),
                        SizedBox(height: AppSpacing.sm),
                        Wrap(
                          spacing: AppSpacing.xs,
                          runSpacing: AppSpacing.xs,
                          children: collectionNames
                              .map((n) => Chip(
                                    avatar: const Icon(
                                        Icons.collections_bookmark_outlined,
                                        size: 14),
                                    label: Text(n,
                                        style: theme.textTheme.labelSmall),
                                    visualDensity: VisualDensity.compact,
                                    materialTapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                    side: BorderSide.none,
                                    backgroundColor: theme
                                        .colorScheme.surfaceContainerHigh,
                                  ))
                              .toList(),
                        ),
                        SizedBox(height: AppSpacing.xl),
                      ],
                      if (relatedArtworks.isNotEmpty) ...[
                        Text(
                          'Obras relacionadas',
                          style: theme.textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: AppSpacing.md),
                        _RelatedGrid(artworks: relatedArtworks),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RelatedGrid extends StatelessWidget {
  final List<Artwork> artworks;

  const _RelatedGrid({required this.artworks});

  @override
  Widget build(BuildContext context) {
    final rows = <Widget>[];
    for (int i = 0; i < artworks.length; i += 2) {
      final children = <Widget>[
        Expanded(
          child: ArtworkTile(
            artwork: artworks[i],
            onTap: () =>
                context.push('/catalog/${artworks[i].id}'),
          ),
        ),
      ];
      if (i + 1 < artworks.length) {
        children.add(const SizedBox(width: 16));
        children.add(
          Expanded(
            child: ArtworkTile(
              artwork: artworks[i + 1],
              onTap: () =>
                  context.push('/catalog/${artworks[i + 1].id}'),
            ),
          ),
        );
      }
      rows.add(
        Padding(
          padding: EdgeInsets.only(bottom: 16),
          child: Row(children: children),
        ),
      );
    }
    return Column(children: rows);
  }
}
