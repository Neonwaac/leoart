import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';

class CollectionsSection extends StatelessWidget {
  final List<Collection> collections;
  final VoidCallback? onViewAll;

  const CollectionsSection({
    super.key,
    required this.collections,
    this.onViewAll,
  });

  @override
  Widget build(BuildContext context) {
    if (collections.isEmpty) return const SizedBox.shrink();

    return EditorialSection(
      title: 'Colecciones',
      subtitle: 'Series tem\u00e1ticas',
      trailing: onViewAll != null
          ? TextButton.icon(
              onPressed: onViewAll,
              icon: const Text('Ver todas'),
              label: const Icon(Icons.arrow_forward_ios, size: 14),
            )
          : null,
      child: SizedBox(
        height: 340,
        child: ListView.separated(
          scrollDirection: Axis.horizontal,
          padding: const EdgeInsets.only(
            left: AppSpacing.md,
            right: AppSpacing.md,
            bottom: AppSpacing.xs,
          ),
          itemCount: collections.length,
          separatorBuilder: (context, index) =>
              const SizedBox(width: AppSpacing.xl),
          itemBuilder: (context, index) {
            final collection = collections[index];
            final width = MediaQuery.sizeOf(context).width;
            final cardWidth = width >= AppSpacing.breakpointCompact
                ? width * 0.7
                : width * 0.75;

            return SizedBox(
              width: cardWidth,
              child: CollectionCard(
                collection: collection,
                variant: CollectionCardVariant.featured,
                onTap: () =>
                    context.push('/catalog?collectionId=${collection.id}'),
              ),
            );
          },
        ),
      ),
    );
  }
}
