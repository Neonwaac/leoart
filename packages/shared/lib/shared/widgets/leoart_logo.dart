import 'package:flutter/material.dart';

enum LogoVariant { full, round }

class LeoArtLogo extends StatelessWidget {
  final LogoVariant variant;
  final double? height;
  final double? width;
  final BoxFit fit;

  const LeoArtLogo({
    super.key,
    this.variant = LogoVariant.round,
    this.height,
    this.width,
    this.fit = BoxFit.contain,
  });

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    final isDark = brightness == Brightness.dark;

    final assetName = switch ((variant, isDark)) {
      (LogoVariant.round, true) => 'assets/redondo-blanco.png',
      (LogoVariant.round, false) => 'assets/redondo-negro.png',
      (LogoVariant.full, true) => 'assets/logo-full-blanco.png',
      (LogoVariant.full, false) => 'assets/logo-full-negro.png',
    };

    return Image.asset(
      assetName,
      height: height,
      width: width,
      fit: fit,
      errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
    );
  }
}
