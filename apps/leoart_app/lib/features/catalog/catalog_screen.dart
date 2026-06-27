import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';
import '../../providers/artwork_providers.dart';

class CatalogScreen extends ConsumerWidget {
  final String? collectionId;

  const CatalogScreen({super.key, this.collectionId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artworksAsync = collectionId != null
        ? ref.watch(collectionArtworksProvider(collectionId!))
        : ref.watch(catalogProvider);

    return Column(
      children: [
        const LeoAppBar(),
        Expanded(
          child: artworksAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(strokeWidth: 2.5),
            ),
            error: (err, stack) => ErrorView(
              message: 'Error al cargar catálogo',
              details: err.toString(),
              icon: Icons.cloud_off_rounded,
              onRetry: () {
                if (collectionId != null) {
                  ref.invalidate(collectionArtworksProvider(collectionId!));
                } else {
                  ref.invalidate(catalogProvider);
                }
              },
            ),
            data: (artworks) {
              if (artworks.isEmpty) {
                return const Center(
                  child: EmptyState(
                    title: 'Catálogo vacío',
                    subtitle: 'No hay obras disponibles en este momento.',
                    icon: Icons.image_not_supported_outlined,
                  ),
                );
              }

              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.fromLTRB(
                      AppSpacing.md,
                      AppSpacing.md,
                      AppSpacing.md,
                      AppSpacing.xl,
                    ),
                    sliver: SliverToBoxAdapter(
                      child: ArtworkGrid(
                        artworks: artworks,
                        onArtworkTap: (artwork) =>
                            context.push('/catalog/${artwork.id}'),
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ],
    );
  }
}
