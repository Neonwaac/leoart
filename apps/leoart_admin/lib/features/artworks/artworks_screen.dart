import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';
import 'providers/artwork_providers.dart';

class ArtworksScreen extends ConsumerWidget {
  const ArtworksScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final artworksAsync = ref.watch(adminArtworksProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Obras'),
        actions: [
          TextButton.icon(
            icon: const Icon(Icons.stars, size: 20),
            label: const Text('Destacados'),
            onPressed: () => context.push('/artworks/featured'),
          ),
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Nueva obra',
            onPressed: () => context.push('/artworks/new'),
          ),
        ],
      ),
      body: artworksAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
        error: (err, _) => ErrorView(
          message: 'Error al cargar obras',
          details: err.toString(),
          icon: Icons.cloud_off_rounded,
        ),
        data: (artworks) {
          if (artworks.isEmpty) {
            return const Center(
              child: EmptyState(
                title: 'Sin obras',
                subtitle: 'No hay obras en el catálogo.',
                icon: Icons.image_not_supported_outlined,
              ),
            );
          }
          return _ArtworkTable(artworks: artworks);
        },
      ),
    );
  }
}

class _ArtworkTable extends ConsumerWidget {
  final List<Artwork> artworks;

  const _ArtworkTable({required this.artworks});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: artworks.length,
      itemBuilder: (context, index) {
        final artwork = artworks[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: ListTile(
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(AppRadius.xs),
              child: SizedBox(
                width: 56,
                height: 56,
                child: artwork.thumbnailUrl != null
                    ? Image.network(
                        artwork.thumbnailUrl!,
                        fit: BoxFit.cover,
                        errorBuilder: (_, _, _) => _imagePlaceholder(theme),
                      )
                    : _imagePlaceholder(theme),
              ),
            ),
            title: Text(
              artwork.title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
            subtitle: Row(
              children: [
                _StatusChip(
                  label: artwork.published ? 'Publicado' : 'Borrador',
                  color: artwork.published
                      ? const Color(0xFF2E7D32)
                      : theme.colorScheme.onSurfaceVariant,
                  filled: artwork.published,
                ),
                const SizedBox(width: AppSpacing.xs),
                if (artwork.featured) ...[
                  _StatusChip(
                    label: '#${artwork.featuredOrder}',
                    color: const Color(0xFFE65100),
                    filled: true,
                  ),
                  const SizedBox(width: AppSpacing.xs),
                ],
                Expanded(
                  child: Text(
                    _formatDate(artwork.createdAt),
                    textAlign: TextAlign.right,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    context.push('/artworks/${artwork.id}/edit');
                  case 'preview':
                    _showPreview(context, artwork);
                  case 'delete':
                    _confirmDelete(context, ref, artwork);
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'edit', child: Text('Editar')),
                const PopupMenuItem(value: 'preview', child: Text('Vista previa')),
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
      child: Icon(Icons.image_outlined, size: 24, color: theme.colorScheme.onSurfaceVariant.withAlpha(80)),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return '';
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showPreview(BuildContext context, Artwork artwork) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(artwork.title),
        content: SizedBox(
          width: 480,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (artwork.imageUrl != null)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                    child: Image.network(artwork.imageUrl!, fit: BoxFit.cover),
                  ),
                const SizedBox(height: AppSpacing.md),
                if (artwork.description != null && artwork.description!.isNotEmpty)
                  Text(artwork.description!),
                const SizedBox(height: AppSpacing.sm),
                _metaRow('ID', artwork.id ?? '-'),
                _metaRow('Aspect Ratio', artwork.aspectRatio.toString()),
                _metaRow('Featured', artwork.featured ? 'Sí (orden ${artwork.featuredOrder})' : 'No'),
                _metaRow('Publicado', artwork.published ? 'Sí' : 'No'),
              ],
            ),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cerrar')),
        ],
      ),
    );
  }

  Widget _metaRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 120,
            child: Text(label, style: const TextStyle(fontWeight: FontWeight.w500, fontSize: 12)),
          ),
          Expanded(child: Text(value, style: const TextStyle(fontSize: 12))),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, Artwork artwork) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Archivar obra'),
        content: Text('¿Archivar "${artwork.title}"? Se ocultará del catálogo público.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              final updated = artwork.copyWith(published: false);
              ref.read(updateArtworkProvider(updated).future);
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
