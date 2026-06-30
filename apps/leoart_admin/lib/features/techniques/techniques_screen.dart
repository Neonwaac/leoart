import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';
import 'providers/technique_providers.dart';

class TechniquesScreen extends ConsumerWidget {
  const TechniquesScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final techniquesAsync = ref.watch(adminTechniquesProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Técnicas'),
        actions: [
          IconButton(
            icon: const Icon(Icons.add),
            tooltip: 'Nueva técnica',
            onPressed: () => context.push('/techniques/new'),
          ),
        ],
      ),
      body: techniquesAsync.when(
        loading: () => const Center(child: CircularProgressIndicator(strokeWidth: 2.5)),
        error: (err, _) => ErrorView(
          message: 'Error al cargar técnicas',
          details: err.toString(),
          icon: Icons.cloud_off_rounded,
        ),
        data: (techniques) {
          if (techniques.isEmpty) {
            return const Center(
              child: EmptyState(
                title: 'Sin técnicas',
                subtitle: 'No hay técnicas registradas.',
                icon: Icons.brush_outlined,
              ),
            );
          }
          return _TechniquesTable(techniques: techniques);
        },
      ),
    );
  }
}

class _TechniquesTable extends ConsumerWidget {
  final List<Technique> techniques;

  const _TechniquesTable({required this.techniques});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return ListView.builder(
      padding: const EdgeInsets.all(AppSpacing.md),
      itemCount: techniques.length,
      itemBuilder: (context, index) {
        final technique = techniques[index];
        return Card(
          margin: const EdgeInsets.only(bottom: AppSpacing.sm),
          child: ListTile(
            title: Text(
              technique.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: theme.textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w500),
            ),
            subtitle: technique.description != null && technique.description!.isNotEmpty
                ? Text(
                    technique.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.onSurfaceVariant,
                    ),
                  )
                : Row(
                    children: [
                      _StatusChip(
                        label: technique.published ? 'Publicado' : 'Borrador',
                        color: technique.published
                            ? const Color(0xFF2E7D32)
                            : theme.colorScheme.onSurfaceVariant,
                        filled: technique.published,
                      ),
                    ],
                  ),
            trailing: PopupMenuButton<String>(
              onSelected: (value) {
                switch (value) {
                  case 'edit':
                    context.push('/techniques/${technique.id}/edit');
                  case 'togglePublish':
                    final updated = technique.copyWith(published: !technique.published);
                    ref.read(updateTechniqueProvider(updated).future);
                  case 'archive':
                    _confirmArchive(context, ref, technique);
                }
              },
              itemBuilder: (_) => [
                const PopupMenuItem(value: 'edit', child: Text('Editar')),
                PopupMenuItem(
                  value: 'togglePublish',
                  child: Text(technique.published ? 'Archivar' : 'Publicar'),
                ),
                const PopupMenuItem(
                  value: 'archive',
                  child: Text('Eliminar', style: TextStyle(color: Colors.red)),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmArchive(BuildContext context, WidgetRef ref, Technique technique) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Archivar técnica'),
        content: Text('¿Archivar "${technique.name}"? Se ocultará del catálogo público.'),
        actions: [
          TextButton(onPressed: () => Navigator.of(ctx).pop(), child: const Text('Cancelar')),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              final updated = technique.copyWith(published: false);
              ref.read(updateTechniqueProvider(updated).future);
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
