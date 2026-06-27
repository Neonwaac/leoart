import 'package:flutter/material.dart';
import 'package:shared/core/design/app_spacing.dart';

class AppDivider extends StatelessWidget {
  final double thickness;
  final double indent;
  final double endIndent;
  final Color? color;

  const AppDivider({
    super.key,
    this.thickness = 0.5,
    this.indent = AppSpacing.md,
    this.endIndent = AppSpacing.md,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Divider(
      thickness: thickness,
      indent: indent,
      endIndent: endIndent,
      color: color ?? theme.colorScheme.outlineVariant,
      height: 0,
    );
  }
}
