import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:shared/shared/widgets/leoart_logo.dart';

class LeoAppBar extends StatelessWidget implements PreferredSizeWidget {
  final bool? showBack;
  final VoidCallback? onBack;
  final Widget? titleWidget;
  final Widget? trailing;
  final Color? backgroundColor;

  const LeoAppBar({
    super.key,
    this.showBack,
    this.onBack,
    this.titleWidget,
    this.trailing,
    this.backgroundColor,
  });

  @override
  Size get preferredSize => const Size.fromHeight(72);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = backgroundColor ?? theme.colorScheme.surfaceContainerHigh;
    final canPop = GoRouter.of(context).canPop();
    final effectiveShowBack = showBack ?? canPop;

    return Container(
      height: 72,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        color: bg,
      ),
      child: SafeArea(
        bottom: false,
        child: Row(
          children: [
            SizedBox(
              width: 44,
              child: effectiveShowBack
                  ? IconButton(
                      icon: const Icon(Icons.arrow_back_rounded, size: 22),
                      onPressed: onBack ?? () => Navigator.maybePop(context),
                      visualDensity: VisualDensity.compact,
                    )
                  : null,
            ),
            const Spacer(),
            SizedBox(
              height: 32,
              child: titleWidget ?? LeoArtLogo(variant: LogoVariant.full, height: 32),
            ),
            const Spacer(),
            SizedBox(
              width: 44,
              child: trailing ?? const SizedBox.shrink(),
            ),
          ],
        ),
      ),
    );
  }
}
