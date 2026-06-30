import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';
import 'providers/collection_providers.dart';

class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionsAsync = ref.watch(adminCollectionsProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Colecciones'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.swap_vert, size: 20),
            label: const Text('Orden'),
            onPressed: () => context.push('/collections/order'),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Nueva colección',
            onPressed: () => context.push('/collections/new'),
          ),
        ],
      ),
      body: collectionsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
        error: (err, _) => ErrorView(
          message: 'Error al cargar colecciones',
          details: err.toString(),
          icon: Icons.cloud_off_rounded,
        ),
        data: (collections) {
          if (collections.isEmpty) {
            return const Center(
              child: EmptyState(
                title: 'Sin colecciones',
                subtitle: 'No hay colecciones en el catálogo.',
                icon: Icons.collections_bookmark_outlined,
              ),
            );
          }
          return _CollectionsTable(collections: collections);
        },
      ),
    );
  }
}

class _CollectionsTable extends ConsumerWidget {
  final List<Collection> collections;

  const _CollectionsTable({required this.collections});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: collections.length,
      itemBuilder: (context, index) {
        final collection = collections[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.xs),
              child: SizedBox(
                width: 56,
                height: 56,
                child: collection.coverImageUrl != null
                    ? Image.network(
                        collection.coverImageUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _imagePlaceholder(theme),
                      )
                    : _imagePlaceholder(theme),
              ),
            ),
            title: Text(
              collection.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
            subtitle: Row(
              children: [
                _StatusChip(
                  label: collection.published ? 'Publicado' : 'Borrador',
                  color: collection.published
                      ? const Color(0xFF2E7D32)
                      : theme.colorScheme.onSurfaceVariant,
                  filled: collection.published,
                ),
                const SizedBox(width: AppSpacing.xs),
                _StatusChip(
                  label: 'Orden ${collection.displayOrder}',
                  color: theme.colorScheme.primary,
                  filled: false,
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    context.push('/collections/${collection.id}/edit');
                  case 'togglePublish':
                    final updated = collection.copyWith(published: !collection.published);
                    ref.read(updateCollectionProvider(updated).future);
                  case 'delete':
                    _confirmDelete(context, ref, collection);
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'edit', child: Text('Editar')),
                PopupMenuItem(
                  value: 'togglePublish',
                  child: Text(collection.published ? 'Archivar' : 'Publicar'),
                ),
                const PopupMenuItem(
                  value: 'delete',
                  child: Text('Eliminar', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _imagePlaceholder(ThemeData theme) {
    return Container(
      color: theme.colorScheme.surfaceContainerHigh,
      child: Icon(Icons.collections_bookmark_outlined, size: 24, color: theme.colorScheme.onSurfaceVariant.withAlpha(80)),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Collection collection) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Archivar colección'),
        content: Text('¿Archivar "${collection.name}"? Se ocultará del catálogo público.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              final updated = collection.copyWith(published: false);
              ref.read(updateCollectionProvider(updated).future);
            },
            style: TextButton.styleFrom(foregroundColor: Colors.red),
            child: const Text('Archivar'),
          ),
        ],
      ),
    );
  }
}

class _StatusChip extends StatelessWidget {
  final String label;
  final Color color;
  final bool filled;

  const _StatusChip({required this.label, required this.color, this.filled = false});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: filled ? color.withAlpha(25) : Colors.transparent,
        border: Border.all(color: color.withAlpha(100), width: 0.5),
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w500),
      ),
    );
  }
}
