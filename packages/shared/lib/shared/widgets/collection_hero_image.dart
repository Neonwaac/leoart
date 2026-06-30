import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:shared/core/design/app_radius.dart';

class CollectionHeroImage extends StatelessWidget {
  final String? imageUrl;
  final String? heroTag;
  final double aspectRatio;
  final double borderRadius;
  final String? blurHash;

  const CollectionHeroImage({
    super.key,
    this.imageUrl,
    this.heroTag,
    this.aspectRatio = 16 / 9,
    this.borderRadius = AppRadius.md,
    this.blurHash,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final hasImage = imageUrl != null && imageUrl!.isNotEmpty;

    Widget image = AspectRatio(
      aspectRatio: aspectRatio,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: hasImage
            ? _BlurHashNetworkImage(
                imageUrl: imageUrl!,
                blurHash: blurHash,
                theme: theme,
              )
            : _Placeholder(theme: theme),
      ),
    );

    if (heroTag != null) {
      image = Hero(tag: heroTag!, child: image);
    }

    return image;
  }
}

class _BlurHashNetworkImage extends StatefulWidget {
  final String imageUrl;
  final String? blurHash;
  final ThemeData theme;

  const _BlurHashNetworkImage({
    required this.imageUrl,
    this.blurHash,
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
            fit: BoxFit.cover,
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
      fit: BoxFit.cover,
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
          Icons.collections_outlined,
          size: 48,
          color: theme.colorScheme.onSurfaceVariant.withAlpha(60),
        ),
      ),
    );
  }
}
