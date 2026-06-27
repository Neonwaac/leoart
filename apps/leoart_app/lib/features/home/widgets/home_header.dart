import 'package:flutter/material.dart';
import 'package:shared/shared.dart';

class HomeHeader extends StatelessWidget {
  final String artistName;
  final String presentation;

  const HomeHeader({
    super.key,
    required this.artistName,
    required this.presentation,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        AppSpacing.md,
        AppSpacing.xl,
        AppSpacing.md,
        AppSpacing.md,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            artistName,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w300,
              letterSpacing: -1.0,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            presentation,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
