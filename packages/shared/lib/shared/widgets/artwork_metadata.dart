import 'package:flutter/material.dart';
import 'package:shared/core/design/app_spacing.dart';

class ArtworkMetadata extends StatelessWidget {
  final String? technique;
  final List<Widget>? additional;

  const ArtworkMetadata({
    super.key,
    this.technique,
    this.additional,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final items = <Widget>[
      if (technique != null)
        _MetadataItem(
          label: technique!,
          color: theme.colorScheme.onSurfaceVariant,
        ),
      ...?additional,
    ];

    if (items.isEmpty) return const SizedBox.shrink();

    return Wrap(
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: AppSpacing.xxs,
      runSpacing: AppSpacing.xxs,
      children: items,
    );
  }
}

class _MetadataItem extends StatelessWidget {
  final String label;
  final Color color;

  const _MetadataItem({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      label,
      style: theme.textTheme.bodySmall?.copyWith(
        color: color,
        letterSpacing: 0.3,
      ),
    );
  }
}
