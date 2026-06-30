import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';
import 'providers/collection_providers.dart';

class CollectionsOrderScreen extends ConsumerStatefulWidget {
  const CollectionsOrderScreen({super.key});

  @override
  ConsumerState<CollectionsOrderScreen> createState() => _CollectionsOrderScreenState();
}

class _CollectionsOrderScreenState extends ConsumerState<CollectionsOrderScreen> {
  List<Collection> _cachedCollections = [];
  bool _hasChanges = false;
  bool _isSaving = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final collectionsAsync = ref.watch(adminCollectionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Ordenar colecciones'),
        actions: [
          if (_hasChanges)
            TextButton(
              onPressed: _isSaving ? null : _save,
              child: _isSaving
                  ? const SizedBox(
                      width: 20, height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Text('Guardar'),
            ),
        ],
      ),
      body: collectionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
        error: (err, _) => Center(child: Text('Error: $err')),
        data: (all) {
          if (_cachedCollections.isEmpty) {
            final sorted = List<Collection>.from(all)
              ..sort((a, b) => a.displayOrder.compareTo(b.displayOrder));
            _cachedCollections = sorted;
          }

          if (_cachedCollections.isEmpty) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.collections_bookmark_outlined,
                      size: 64, color: theme.colorScheme.onSurfaceVariant.withAlpha(80)),
                  const SizedBox(height: AppSpacing.md),
                  Text('Sin colecciones', style: theme.textTheme.titleMedium),
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Arrastra para reordenar las colecciones',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return ReorderableListView.builder(
            padding: const EdgeInsets.all(AppSpacing.md),
            itemCount: _cachedCollections.length,
            onReorderItem: (oldIndex, newIndex) {
              if (newIndex > oldIndex) newIndex--;
              final item = _cachedCollections.removeAt(oldIndex);
              _cachedCollections.insert(newIndex, item);
              setState(() {
                _cachedCollections = _cachedCollections.asMap().entries.map((e) {
                  return e.value.copyWith(displayOrder: e.key + 1);
                }).toList();
                _hasChanges = true;
              });
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
              final collection = _cachedCollections[index];
              return Card(
                key: ValueKey(collection.id),
                margin: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: ListTile(
                  leading: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.drag_handle, color: theme.colorScheme.onSurfaceVariant),
                      const SizedBox(width: AppSpacing.xs),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(AppRadius.xs),
                        child: SizedBox(
                          width: 40,
                          height: 40,
                          child: collection.coverImageUrl != null
                              ? Image.network(collection.coverImageUrl!, fit: BoxFit.cover,
                                  errorBuilder: (_, _, _) => _placeholder(theme))
                              : _placeholder(theme),
                        ),
                      ),
                    ],
                  ),
                  title: Text(
                    collection.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
                  ),
                  subtitle: Text(
                    '#${collection.displayOrder}',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  Widget _placeholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHigh,
      child: Icon(Icons.collections_bookmark_outlined, size: 20,
          color: theme.colorScheme.onSurfaceVariant.withAlpha(80)),
    );
  }

  Future<void> _save() async {
    setState(() => _isSaving = true);

    try {
      for (final collection in _cachedCollections) {
        await ref.read(updateCollectionProvider(collection).future);
      }

      setState(() => _hasChanges = false);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Orden guardado')),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error al guardar: $e')),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }
}
