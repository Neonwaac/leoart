import 'package:flutter/material.dart';
import 'package:shared/core/design/app_spacing.dart';

class CollectionInfo extends StatelessWidget {
  final String name;
  final String? description;
  final int? artworkCount;
  final bool compact;

  const CollectionInfo({
    super.key,
    required this.name,
    this.description,
    this.artworkCount,
    this.compact = false,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          name,
          style: compact
              ? theme.textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.w500,
                  letterSpacing: -0.3,
                )
              : theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w400,
                  letterSpacing: -0.5,
                ),
        ),
        if (description != null && description!.isNotEmpty) ...[
          SizedBox(height: compact ? AppSpacing.xs : AppSpacing.sm),
          Text(
            description!,
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.6,
            ),
            maxLines: compact ? 2 : 4,
            overflow: compact ? TextOverflow.ellipsis : null,
          ),
        ],
        if (artworkCount != null) ...[
          SizedBox(height: compact ? AppSpacing.sm : AppSpacing.md),
          Text(
            '$artworkCount obra${artworkCount == 1 ? '' : 's'}',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              letterSpacing: 0.5,
            ),
          ),
        ],
      ],
    );
  }
}
