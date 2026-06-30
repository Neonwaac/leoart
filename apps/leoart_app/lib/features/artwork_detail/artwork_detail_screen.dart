import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';
import '../../providers/artist_providers.dart';
import '../../providers/artwork_providers.dart';
import '../../providers/collections_providers.dart';

class ArtworkDetailScreen extends ConsumerWidget {
  final String artworkId;

  const ArtworkDetailScreen({super.key, required this.artworkId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artworkAsync = ref.watch(artworkProvider(artworkId));

    return Scaffold(
      appBar: LeoAppBar(
        trailing: IconButton(
          icon: const Icon(Icons.share_outlined, size: 22),
          onPressed: () {},
          visualDensity: VisualDensity.compact,
        ),
      ),
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
              return _ArtworkDetailBody(
                artwork: artwork,
                isWide: isWide,
              );
            },
          );
        },
      ),
    );
  }
}

class _ArtworkDetailBody extends ConsumerWidget {
  final Artwork artwork;
  final bool isWide;

  const _ArtworkDetailBody({
    required this.artwork,
    required this.isWide,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final techniquesAsync = ref.watch(techniquesProvider);
    final collectionsAsync = ref.watch(collectionsProvider);
    final catalogAsync = ref.watch(catalogProvider);
    final artistAsync =
        ref.watch(artistByIdProvider(artwork.artistId ?? ''));

    final techniqueMap = <String, String>{};
    for (final t in techniquesAsync.valueOrNull ?? []) {
      if (t.id != null && t.name.isNotEmpty) {
        techniqueMap[t.id!] = t.name;
      }
    }

    final collectionMap = <String, String>{};
    for (final c in collectionsAsync.valueOrNull ?? []) {
      if (c.id != null && c.name.isNotEmpty) {
        collectionMap[c.id!] = c.name;
      }
    }

    final related = _relatedArtworks(artwork, catalogAsync.valueOrNull ?? []);

    if (isWide) {
      return _WideContent(
        artwork: artwork,
        artistAsync: artistAsync,
        techniqueMap: techniqueMap,
        collectionMap: collectionMap,
        relatedArtworks: related,
      );
    }

    return _CompactContent(
      artwork: artwork,
      artistAsync: artistAsync,
      techniqueMap: techniqueMap,
      collectionMap: collectionMap,
      relatedArtworks: related,
    );
  }
}

List<Artwork> _relatedArtworks(Artwork current, List<Artwork> catalog) {
  final others = catalog.where((a) => a.id != current.id).toList();

  final sameCollection = others
      .where((a) =>
          a.collectionIds.any((cId) => current.collectionIds.contains(cId)))
      .toList();

  final sameTechnique = others
      .where((a) =>
          !sameCollection.contains(a) &&
          a.techniqueIds.any((tId) => current.techniqueIds.contains(tId)))
      .toList();

  return [...sameCollection, ...sameTechnique].take(4).toList();
}

// ---------------------------------------------------------------------------
// Compact layout
// ---------------------------------------------------------------------------

class _CompactContent extends StatelessWidget {
  final Artwork artwork;
  final AsyncValue<Artist?> artistAsync;
  final Map<String, String> techniqueMap;
  final Map<String, String> collectionMap;
  final List<Artwork> relatedArtworks;

  const _CompactContent({
    required this.artwork,
    required this.artistAsync,
    required this.techniqueMap,
    required this.collectionMap,
    required this.relatedArtworks,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          HeroArtworkImage(
            imageUrl: artwork.imageUrl,
            heroTag: 'artwork_${artwork.id}',
            width: double.infinity,
            aspectRatio: artwork.aspectRatio,
            borderRadius: 0,
            fit: BoxFit.cover,
            blurHash: artwork.blurHash,
          ),
          SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artwork.title,
                  style: theme.textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.w400,
                    letterSpacing: -0.5,
                    height: 1.15,
                  ),
                ),
                SizedBox(height: AppSpacing.sm),
                _TechniqueChips(
                  techniqueIds: artwork.techniqueIds,
                  techniqueMap: techniqueMap,
                ),
                SizedBox(height: AppSpacing.lg),
                _ArtistTile(artistAsync: artistAsync),
                SizedBox(height: AppSpacing.lg),
                _Description(text: artwork.description),
                SizedBox(height: AppSpacing.lg),
                _CollectionChips(
                  collectionIds: artwork.collectionIds,
                  collectionMap: collectionMap,
                ),
                if (relatedArtworks.isNotEmpty) ...[
                  SizedBox(height: AppSpacing.xl),
                  Text(
                    'Obras relacionadas',
                    style: theme.textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: AppSpacing.md),
                  _RelatedGrid(artworks: relatedArtworks),
                ],
                SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Wide layout
// ---------------------------------------------------------------------------

class _WideContent extends StatelessWidget {
  final Artwork artwork;
  final AsyncValue<Artist?> artistAsync;
  final Map<String, String> techniqueMap;
  final Map<String, String> collectionMap;
  final List<Artwork> relatedArtworks;

  const _WideContent({
    required this.artwork,
    required this.artistAsync,
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
                    top: MediaQuery.of(context).padding.top + AppSpacing.md,
                  ),
                  child: HeroArtworkImage(
                    imageUrl: artwork.imageUrl,
                    heroTag: 'artwork_${artwork.id}',
                    width: double.infinity,
                    aspectRatio: artwork.aspectRatio,
                    borderRadius: 0,
                    fit: BoxFit.cover,
                    blurHash: artwork.blurHash,
                  ),
                ),
              ),
              SizedBox(width: columnGap),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.only(
                    top:
                        MediaQuery.of(context).padding.top + AppSpacing.md,
                    bottom: AppSpacing.xl,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        artwork.title,
                        style: theme.textTheme.headlineMedium?.copyWith(
                          fontWeight: FontWeight.w400,
                          letterSpacing: -0.5,
                          height: 1.15,
                        ),
                      ),
                      SizedBox(height: AppSpacing.sm),
                      _TechniqueChips(
                        techniqueIds: artwork.techniqueIds,
                        techniqueMap: techniqueMap,
                      ),
                      SizedBox(height: AppSpacing.lg),
                      _ArtistTile(artistAsync: artistAsync),
                      SizedBox(height: AppSpacing.lg),
                      _Description(text: artwork.description),
                      SizedBox(height: AppSpacing.lg),
                      _CollectionChips(
                        collectionIds: artwork.collectionIds,
                        collectionMap: collectionMap,
                      ),
                      if (relatedArtworks.isNotEmpty) ...[
                        SizedBox(height: AppSpacing.xl),
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

// ---------------------------------------------------------------------------
// Sub-widgets
// ---------------------------------------------------------------------------

class _TechniqueChips extends StatelessWidget {
  final List<String> techniqueIds;
  final Map<String, String> techniqueMap;

  const _TechniqueChips({
    required this.techniqueIds,
    required this.techniqueMap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final names = techniqueIds
        .map((id) => techniqueMap[id])
        .where((n) => n != null && n.isNotEmpty)
        .toList();

    if (names.isEmpty) return const SizedBox.shrink();

    return Wrap(
      spacing: AppSpacing.xs,
      runSpacing: AppSpacing.xs,
      children: names
          .map((n) => Chip(
                avatar:
                    const Icon(Icons.brush_outlined, size: 14),
                label: Text(n!,
                    style: theme.textTheme.labelSmall),
                visualDensity: VisualDensity.compact,
                materialTapTargetSize:
                    MaterialTapTargetSize.shrinkWrap,
                side: BorderSide.none,
                backgroundColor:
                    theme.colorScheme.surfaceContainerHigh,
              ))
          .toList(),
    );
  }
}

class _CollectionChips extends StatelessWidget {
  final List<String> collectionIds;
  final Map<String, String> collectionMap;

  const _CollectionChips({
    required this.collectionIds,
    required this.collectionMap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final entries = collectionIds
        .map((id) => MapEntry(id, collectionMap[id]))
        .where((e) => e.value != null && e.value!.isNotEmpty)
        .toList();

    if (entries.isEmpty) return const SizedBox.shrink();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
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
          children: entries
              .map((e) => ActionChip(
                    avatar: const Icon(
                        Icons.collections_bookmark_outlined,
                        size: 14),
                    label: Text(e.value!,
                        style: theme.textTheme.labelSmall),
                    visualDensity: VisualDensity.compact,
                    materialTapTargetSize:
                        MaterialTapTargetSize.shrinkWrap,
                    side: BorderSide.none,
                    backgroundColor:
                        theme.colorScheme.surfaceContainerHigh,
                    onPressed: () => context
                        .go('/catalog?collectionId=${e.key}'),
                  ))
              .toList(),
        ),
      ],
    );
  }
}

class _ArtistTile extends StatelessWidget {
  final AsyncValue<Artist?> artistAsync;

  const _ArtistTile({required this.artistAsync});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return artistAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (_, _) => const SizedBox.shrink(),
      data: (artist) {
        if (artist == null) return const SizedBox.shrink();

        return Row(
          children: [
            CircleAvatar(
              radius: 22,
              backgroundImage: artist.photoUrl != null
                  ? NetworkImage(artist.photoUrl!)
                  : null,
              child: artist.photoUrl == null
                  ? Icon(Icons.person,
                      size: 22,
                      color: theme.colorScheme.onSurfaceVariant)
                  : null,
            ),
            SizedBox(width: AppSpacing.sm),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  artist.name,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                if (artist.profession != null &&
                    artist.profession!.isNotEmpty)
                  Text(
                    artist.profession!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class _Description extends StatelessWidget {
  final String? text;

  const _Description({this.text});

  @override
  Widget build(BuildContext context) {
    if (text == null || text!.isEmpty) return const SizedBox.shrink();

    final theme = Theme.of(context);
    return Text(
      text!,
      style: theme.textTheme.bodyMedium?.copyWith(
        color: theme.colorScheme.onSurfaceVariant,
        height: 1.6,
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
        children.add(const SizedBox(width: AppSpacing.md));
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
          padding: EdgeInsets.only(bottom: AppSpacing.md),
          child: Row(children: children),
        ),
      );
    }
    return Column(children: rows);
  }
}
