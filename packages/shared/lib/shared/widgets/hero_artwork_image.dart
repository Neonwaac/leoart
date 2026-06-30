import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:shared/core/design/app_radius.dart';

class HeroArtworkImage extends StatelessWidget {
  final String? imageUrl;
  final String heroTag;
  final double? width;
  final double aspectRatio;
  final double borderRadius;
  final BoxFit fit;
  final String? blurHash;

  const HeroArtworkImage({
    super.key,
    this.imageUrl,
    required this.heroTag,
    this.width,
    this.aspectRatio = 1.0,
    this.borderRadius = AppRadius.md,
    this.fit = BoxFit.cover,
    this.blurHash,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    final imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: hasImage
          ? _BlurHashNetworkImage(
              imageUrl: imageUrl!,
              blurHash: blurHash,
              width: width,
              fit: fit,
              theme: theme,
            )
          : _Placeholder(theme: theme),
    );

    return Hero(
      tag: heroTag,
      child: AspectRatio(
        aspectRatio: aspectRatio,
        child: imageWidget,
      ),
    );
  }
}

class _BlurHashNetworkImage extends StatefulWidget {
  final String imageUrl;
  final String? blurHash;
  final double? width;
  final BoxFit fit;
  final ThemeData theme;

  const _BlurHashNetworkImage({
    required this.imageUrl,
    this.blurHash,
    this.width,
    required this.fit,
    required this.theme,
  });

  @override
  State<_BlurHashNetworkImage> createState() => _BlurHashNetworkImageState();
}

class _BlurHashNetworkImageState extends State<_BlurHashNetworkImage> {
  bool _loaded = false;
  bool _failed = false;

  @override
  Widget build(BuildContext context) {
    if (_failed) {
      return _Placeholder(theme: widget.theme);
    }

    if (widget.blurHash != null && !_loaded) {
      return Stack(
        fit: StackFit.expand,
        children: [
          BlurHash(hash: widget.blurHash!),
          Image.network(
            widget.imageUrl,
            width: widget.width,
            fit: widget.fit,
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  if (mounted && !_loaded) {
                    setState(() => _loaded = true);
                  }
                });
                return child;
              }
              return const SizedBox.shrink();
            },
            errorBuilder: (context, error, stackTrace) {
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (mounted && !_failed) {
                  setState(() => _failed = true);
                }
              });
              return _Placeholder(theme: widget.theme);
            },
          ),
        ],
      );
    }

    return Image.network(
      widget.imageUrl,
      width: widget.width,
      fit: widget.fit,
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_loaded) {
              setState(() => _loaded = true);
            }
          });
          return child;
        }
        return _Placeholder(theme: widget.theme);
      },
      errorBuilder: (context, error, stackTrace) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (mounted && !_failed) {
            setState(() => _failed = true);
          }
        });
        return _Placeholder(theme: widget.theme);
      },
    );
  }
}

class _Placeholder extends StatelessWidget {
  final ThemeData theme;

  const _Placeholder({required this.theme});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            theme.colorScheme.surfaceContainerHigh,
            theme.colorScheme.surfaceContainerLow,
          ],
        ),
      ),
      child: Center(
        child: Icon(
          Icons.image_outlined,
          size: 48,
          color: theme.colorScheme.onSurfaceVariant.withAlpha(60),
        ),
      ),
    );
  }
}
