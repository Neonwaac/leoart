import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import 'providers/artwork_providers.dart';

class FeaturedEditorScreen extends ConsumerStatefulWidget {
  const FeaturedEditorScreen({super.key});

  @override
  ConsumerState<FeaturedEditorScreen> createState() => _FeaturedEditorScreenState();
}

class _FeaturedEditorScreenState extends ConsumerState<FeaturedEditorScreen> {
  List<Artwork> _cachedFeatured = [];

  List<Artwork> _getFeatured(List<Artwork> all) {
    return all.where((a) => a.featuredOrder > 0).toList()
      ..sort((a, b) => a.featuredOrder.compareTo(b.featuredOrder));
  }

  List<Artwork> _getNonFeatured(List<Artwork> all) {
    return all.where((a) => a.featuredOrder <= 0).toList();
  }

  void _reorder(int oldIndex, int newIndex) {
    if (newIndex > oldIndex) newIndex--;
    final item = _cachedFeatured.removeAt(oldIndex);
    _cachedFeatured.insert(newIndex, item);

    final updates = _cachedFeatured.asMap().entries.map((e) {
      return e.value.copyWith(featuredOrder: e.key + 1);
    }).toList();

    setState(() => _cachedFeatured = updates);

    for (final artwork in updates) {
      ref.read(updateArtworkProvider(artwork).future);
    }
  }

  Future<void> _addToFeatured(Artwork artwork) async {
    final allAsync = ref.read(adminArtworksProvider);
    allAsync.whenData((all) {
      final maxOrder = _cachedFeatured.isEmpty
          ? 0
          : _cachedFeatured.map((a) => a.featuredOrder).reduce((a, b) => a > b ? a : b);
      final updated = artwork.copyWith(
        featured: true,
        featuredOrder: maxOrder + 1,
      );
      setState(() {
        _cachedFeatured.add(updated);
        _cachedFeatured.sort((a, b) => a.featuredOrder.compareTo(b.featuredOrder));
      });
      ref.read(updateArtworkProvider(updated).future);
    });
  }

  Future<void> _removeFromFeatured(Artwork artwork) async {
    final updated = artwork.copyWith(featured: false, featuredOrder: 0);
    setState(() {
      _cachedFeatured.removeWhere((a) => a.id == artwork.id);
      _cachedFeatured = _cachedFeatured.asMap().entries.map((e) {
        return e.value.copyWith(featuredOrder: e.key + 1);
      }).toList();
    });
    for (final a in _cachedFeatured) {
      ref.read(updateArtworkProvider(a).future);
    }
    await ref.read(updateArtworkProvider(updated).future);
  }

  Future<void> _showAddDialog() async {
    final allAsync = ref.read(adminArtworksProvider);
    allAsync.whenData((all) {
      final nonFeatured = _getNonFeatured(all);
      if (!mounted) return;
      showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: const Text('Añadir a destacados'),
          content: SizedBox(
            width: double.maxFinite,
            child: nonFeatured.isEmpty
                ? const Padding(
                    padding: EdgeInsets.all(16),
                    child: Text('No hay obras sin destacar'),
                  )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: nonFeatured.length,
                    itemBuilder: (_, i) {
                      final a = nonFeatured[i];
                      return ListTile(
                        title: Text(a.title),
                        leading: a.thumbnailUrl != null
                            ? ClipRRect(
                                borderRadius: BorderRadius.circular(4),
                                child: Image.network(
                                  a.thumbnailUrl!,
                                  width: 40,
                                  height: 40,
                                  fit: BoxFit.cover,
                                ),
                              )
                            : null,
                        onTap: () {
                          Navigator.of(ctx).pop();
                          _addToFeatured(a);
                        },
                      );
                    },
                  ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cerrar'),
            ),
          ],
        ),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final artworksAsync = ref.watch(adminArtworksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Editar destacados'),
      ),
      body: artworksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (all) {
          if (_cachedFeatured.isEmpty) {
            _cachedFeatured = _getFeatured(all);
          }
          final featured = _cachedFeatured;
          if (featured.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.stars_outlined, size: 64, color: theme.colorScheme.onSurfaceVariant.withAlpha(80)),
                  const SizedBox(height: AppSpacing.md),
                  Text('Sin destacados', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Arrastra o añade obras para destacarlas',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  FilledButton.icon(
                    icon: const Icon(Icons.add),
                    onPressed: _showAddDialog,
                    label: const Text('Añadir obra'),
                  ),
                ],
              ),
            );
          }
          return ReorderableListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: featured.length + 1,
            onReorderItem: (oldIndex, newIndex) {
              if (oldIndex == _cachedFeatured.length) return;
              _reorder(oldIndex, newIndex);
            },
            proxyDecorator: (child, index, animation) {
              return Material(
                elevation: 4,
                borderRadius: BorderRadius.circular(AppRadius.sm),
                color: Theme.of(context).colorScheme.surface,
                child: child,
              );
            },
            itemBuilder: (context, index) {
              if (index == featured.length) {
                return Padding(
                  key: const ValueKey('addButton'),
                  padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                  child: OutlinedButton.icon(
                    icon: const Icon(Icons.add),
                    onPressed: _showAddDialog,
                    label: const Text('Añadir obra a destacados'),
                  ),
                );
              }
              final artwork = featured[index];
              return Card(
                key: ValueKey(artwork.id),
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  leading: Icon(
                    Icons.drag_handle,
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                  title: Text(
                    '#${artwork.featuredOrder}  ${artwork.title}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  subtitle: artwork.description != null && artwork.description!.isNotEmpty
                      ? Text(
                          artwork.description!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurfaceVariant,
                          ),
                        )
                      : null,
                  trailing: IconButton(
                    icon: Icon(
                      Icons.remove_circle_outline,
                      color: theme.colorScheme.error,
                    ),
                    tooltip: 'Quitar de destacados',
                    onPressed: () => _removeFromFeatured(artwork),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}


