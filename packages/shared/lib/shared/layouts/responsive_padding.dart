import 'package:flutter/material.dart';
import 'package:shared/core/design/app_spacing.dart';

class ResponsivePadding extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? compact;
  final EdgeInsetsGeometry? medium;
  final EdgeInsetsGeometry? expanded;

  const ResponsivePadding({
    super.key,
    required this.child,
    this.padding,
    this.compact,
    this.medium,
    this.expanded,
  });

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;

    EdgeInsetsGeometry resolvePadding() {
      if (padding != null) return padding!;

      if (width <= 600) {
        return compact ?? const EdgeInsets.symmetric(horizontal: AppSpacing.md);
      }
      if (width <= 840) {
        return medium ?? const EdgeInsets.symmetric(horizontal: AppSpacing.xl);
      }
      return expanded ?? EdgeInsets.symmetric(horizontal: width * 0.15);
    }

    return Padding(padding: resolvePadding(), child: child);
  }
}
