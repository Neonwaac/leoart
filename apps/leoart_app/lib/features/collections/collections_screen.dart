import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared.dart';
import '../../providers/collections_providers.dart';

class CollectionsScreen extends ConsumerWidget {
  const CollectionsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final collectionsAsync = ref.watch(collectionsProvider);
    final width = MediaQuery.sizeOf(context).width;
    final isWide = width >= AppSpacing.breakpointMedium;

    return Column(
      children: [
        const LeoAppBar(),
        Expanded(
          child: AsyncStateBuilder<List<Collection>>(
            value: collectionsAsync,
            loading: const _LoadingSkeleton(),
            error: (err, stack) => ErrorView(
              message: 'Error al cargar colecciones',
              details: err.toString(),
              icon: Icons.cloud_off_rounded,
              onRetry: () => ref.invalidate(collectionsProvider),
            ),
            builder: (collections) {
              if (collections.isEmpty) {
                return const EmptyState(
                  icon: Icons.collections_outlined,
                  title: 'Sin colecciones',
                  subtitle: 'Aún no hay colecciones publicadas.',
                );
              }

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
                      child: EditorialSection(
                        title: 'Colecciones',
                        subtitle: 'Series temáticas',
                        padding: EdgeInsets.zero,
                        child: const SizedBox.shrink(),
                      ),
                    ),
                    const SizedBox(height: AppSpacing.lg),
                    ...List.generate(collections.length, (index) {
                      final collection = collections[index];
                      final reverse = isWide && index.isOdd;

                      return FadeAnimation(
                        child: SlideAnimation(
                          begin: const Offset(0, 0.04),
                          duration: AppDurations.fast,
                          child: Padding(
                            padding: EdgeInsets.fromLTRB(
                              AppSpacing.md,
                              index == 0 ? 0 : AppSpacing.lg,
                              AppSpacing.md,
                              AppSpacing.lg,
                            ),
                            child: _CollectionBlock(
                              collection: collection,
                              reverse: reverse,
                              isWide: isWide,
                              onTap: () => context.push(
                                '/catalog?collectionId=${collection.id}',
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CollectionBlock extends StatelessWidget {
  final Collection collection;
  final bool reverse;
  final bool isWide;
  final VoidCallback onTap;

  const _CollectionBlock({
    required this.collection,
    required this.reverse,
    required this.isWide,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final card = CollectionCard(
      collection: collection,
      variant: CollectionCardVariant.standard,
      onTap: onTap,
    );

    if (!isWide) return card;

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (!reverse)
          Expanded(flex: 3, child: card)
        else
          const Spacer(flex: 1),
        if (!reverse) const SizedBox(width: AppSpacing.xl),
        Padding(
          padding: EdgeInsets.only(top: reverse ? AppSpacing.xl : 0),
          child: SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '0${collection.displayOrder}',
                  style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w200,
                    color: Theme.of(context)
                        .colorScheme
                        .onSurface
                        .withAlpha(30),
                    letterSpacing: -1,
                  ),
                ),
              ],
            ),
          ),
        ),
        if (reverse) const SizedBox(width: AppSpacing.xl),
        if (reverse)
          Expanded(flex: 3, child: card)
        else
          const Spacer(flex: 1),
      ],
    );
  }
}

class _LoadingSkeleton extends StatelessWidget {
  const _LoadingSkeleton();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const SizedBox(height: AppSpacing.md),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: 200,
                  height: 28,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                ),
                const SizedBox(height: AppSpacing.xs),
                Container(
                  width: 140,
                  height: 18,
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(AppRadius.xs),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppSpacing.lg),
          ...List.generate(4, (index) {
            return Padding(
              padding: EdgeInsets.fromLTRB(
                AppSpacing.md,
                index == 0 ? 0 : AppSpacing.lg,
                AppSpacing.md,
                AppSpacing.lg,
              ),
              child: AspectRatio(
                aspectRatio: 16 / 9,
                child: Container(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHigh,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}
