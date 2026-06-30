import 'package:flutter/material.dart';
import 'package:flutter_blurhash/flutter_blurhash.dart';
import 'package:shared/core/design/app_durations.dart';

class AppNetworkImage extends StatefulWidget {
  final String imageUrl;
  final double? width;
  final double? height;
  final double aspectRatio;
  final BoxFit fit;
  final double borderRadius;
  final String? placeholderAsset;
  final String? blurHash;

  const AppNetworkImage({
    super.key,
    required this.imageUrl,
    this.width,
    this.height,
    this.aspectRatio = 1,
    this.fit = BoxFit.cover,
    this.borderRadius = 0,
    this.placeholderAsset,
    this.blurHash,
  });

  @override
  State<AppNetworkImage> createState() => _AppNetworkImageState();
}

class _AppNetworkImageState extends State<AppNetworkImage> {
  bool _loaded = false;
  bool _failed = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Widget imageWidget = ClipRRect(
      borderRadius: BorderRadius.circular(widget.borderRadius),
      child: widget.width != null || widget.height != null
          ? SizedBox(
              width: widget.width,
              height: widget.height,
              child: _buildImage(theme),
            )
          : AspectRatio(
              aspectRatio: widget.aspectRatio,
              child: _buildImage(theme),
            ),
    );

    return AnimatedOpacity(
      opacity: _loaded ? 1.0 : 0.0,
      duration: AppDurations.normal,
      curve: Curves.easeIn,
      child: imageWidget,
    );
  }

  Widget _buildImage(ThemeData theme) {
    if (_failed) {
      return _buildPlaceholder(
        Icons.broken_image_outlined,
        theme.colorScheme.onSurfaceVariant.withAlpha(80),
      );
    }

    if (widget.blurHash != null && !_loaded) {
      return Stack(
        fit: StackFit.expand,
        children: [
          BlurHash(hash: widget.blurHash!),
          Image.network(
            widget.imageUrl,
            fit: widget.fit,
            width: widget.width,
            height: widget.height,
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
              return _buildPlaceholder(
                Icons.broken_image_outlined,
                theme.colorScheme.onSurfaceVariant.withAlpha(80),
              );
            },
          ),
        ],
      );
    }

    return GestureDetector(
      onTap: () {},
      child: Image.network(
        widget.imageUrl,
        fit: widget.fit,
        width: widget.width,
        height: widget.height,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              if (mounted && !_loaded) {
                setState(() => _loaded = true);
              }
            });
            return child;
          }
          return _buildPlaceholder(
            Icons.image_outlined,
            theme.colorScheme.onSurfaceVariant.withAlpha(40),
          );
        },
        errorBuilder: (context, error, stackTrace) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (mounted && !_failed) {
              setState(() => _failed = true);
            }
          });
          return _buildPlaceholder(
            Icons.broken_image_outlined,
            theme.colorScheme.onSurfaceVariant.withAlpha(80),
          );
        },
      ),
    );
  }

  Widget _buildPlaceholder(IconData icon, Color color) {
    return Container(
      color: Theme.of(context).colorScheme.surfaceContainerLow,
      child: Center(child: Icon(icon, size: 32, color: color)),
    );
  }
}
