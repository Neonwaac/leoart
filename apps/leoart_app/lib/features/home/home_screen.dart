import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';
import '../../providers/artist_providers.dart';
import '../../providers/artwork_providers.dart';
import '../../providers/collections_providers.dart';
import '../../providers/settings_providers.dart';
import 'widgets/artist_preview_section.dart';
import 'widgets/collections_section.dart';
import 'widgets/explore_catalog_section.dart';
import 'widgets/featured_artwork_section.dart';
import 'widgets/home_header.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsAppProvider);
    final artistAsync = ref.watch(artistProvider);
    final collectionsAsync = ref.watch(collectionsProvider);
    final featuredArtworksAsync = ref.watch(featuredArtworksProvider);
    final techniquesAsync = ref.watch(techniquesProvider);

    final settingsLoading = settingsAsync.isLoading;
    final settingsError = settingsAsync.hasError;
    final settings = settingsAsync.valueOrNull;
    final artistLoading = artistAsync.isLoading;
    final artistError = artistAsync.hasError;
    final artist = artistAsync.valueOrNull;

    final techniqueMap = <String?, String>{};
    for (final t in techniquesAsync.valueOrNull ?? []) {
      if (t.id != null) techniqueMap[t.id] = t.name;
    }

    final body = Builder(
      builder: (context) {
        if (settingsLoading || artistLoading) {
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                HomeHeader(
                  artistName: 'Cargando...',
                  presentation: 'Cargando...',
                ),
                const SizedBox(height: AppSpacing.md),
                const SizedBox(
                  height: 360,
                  child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2.5)),
                ),
                const SizedBox(height: AppSpacing.xl),
                const SizedBox(
                  height: 200,
                  child: Center(
                      child: CircularProgressIndicator(strokeWidth: 2.5)),
                ),
              ],
            ),
          );
        }

        if (settingsError) {
          return ErrorView(
            message: 'Error al cargar configuración',
            details: settingsAsync.error.toString(),
            icon: Icons.cloud_off_rounded,
            onRetry: () => ref.invalidate(settingsAppProvider),
          );
        }

        if (settings == null) {
          return ErrorView(
            message: 'Settings document not found',
            details:
                'No se encontró el documento "app" en la colección "settings". '
                'Verifica que exista en Firebase Console.',
            icon: Icons.find_replace_rounded,
          );
        }

        if (artistError) {
          return ErrorView(
            message: 'Error al cargar artista',
            details: artistAsync.error.toString(),
            icon: Icons.cloud_off_rounded,
            onRetry: () => ref.invalidate(artistProvider),
          );
        }

        if (artist == null) {
          return ErrorView(
            message: 'Artist document not found',
            details:
                'No se encontró el documento "artist" en la colección "artists". '
                'Verifica que exista en Firebase Console.',
            icon: Icons.find_replace_rounded,
          );
        }

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              HomeHeader(
                artistName: settings.appName,
                presentation: settings.appDescription ?? '',
              ),
              const SizedBox(height: AppSpacing.md),
              FadeAnimation(
                child: featuredArtworksAsync.when(
              loading: () => const SizedBox(
                height: 360,
                child:
                    Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
              ),
              error: (err, _) => SizedBox(
                height: 360,
                child: ErrorView(
                  message: 'Error al cargar obra destacada',
                  details: err.toString(),
                  icon: Icons.cloud_off_rounded,
                  onRetry: () => ref.invalidate(featuredArtworksProvider),
                ),
              ),
              data: (artworks) {
                if (artworks.isEmpty) return const SizedBox.shrink();
                final artwork = artworks.first;
                final techniqueNames = artwork.techniqueIds
                    .map((id) => techniqueMap[id] ?? '')
                    .where((n) => n.isNotEmpty)
                    .join(', ');
                return FeaturedArtworkSection(
                  artwork: artwork,
                  techniqueName: techniqueNames.isNotEmpty ? techniqueNames : null,
                );
              },
            ),
          ),
          const SizedBox(height: AppSpacing.xl),
          FadeAnimation(
            child: collectionsAsync.when(
              loading: () => const SizedBox(
                height: 340,
                child:
                    Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
              ),
              error: (err, _) => SizedBox(
                height: 340,
                child: ErrorView(
                  message: 'Error al cargar colecciones',
                  details: err.toString(),
                  icon: Icons.cloud_off_rounded,
                  onRetry: () => ref.invalidate(collectionsProvider),
                ),
              ),
              data: (collections) => CollectionsSection(
                collections: collections,
                onViewAll: () => context.push('/collections'),
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.md),
          FadeAnimation(
            child: const ExploreCatalogSection(),
          ),
          FadeAnimation(
            child: ArtistPreviewSection(artist: artist),
          ),
        ],
      ),
    );
    },
    );
    return Column(
      children: [
        const LeoAppBar(),
        Expanded(child: body),
      ],
    );
  }
}
