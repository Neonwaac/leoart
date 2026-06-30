import 'package:flutter/material.dart';
import 'package:shared/core/design/app_durations.dart';
import 'package:shared/core/design/app_spacing.dart';
import 'package:shared/models/artwork.dart';
import 'package:shared/shared/animations/fade_animation.dart';
import 'package:shared/shared/animations/slide_animation.dart';
import 'package:shared/shared/widgets/artwork_tile.dart';

class ArtworkGrid extends StatelessWidget {
  final List<Artwork> artworks;
  final void Function(Artwork artwork)? onArtworkTap;

  const ArtworkGrid({
    super.key,
    required this.artworks,
    this.onArtworkTap,
  });

  int _columnCount(double width) {
    if (width < AppSpacing.breakpointCompact) return 2;
    if (width < AppSpacing.breakpointMedium) return 3;
    if (width < 1200) return 4;
    return 5;
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = _columnCount(constraints.maxWidth);
        return _buildMasonry(context, constraints.maxWidth, columns);
      },
    );
  }

  Widget _buildMasonry(BuildContext context, double totalWidth, int columns) {
    const gap = AppSpacing.md;
    final colWidth = (totalWidth - (columns - 1) * gap) / columns;

    final columnChildren = List.generate(columns, (_) => <Widget>[]);
    final columnHeights = List.filled(columns, 0.0);

    for (int i = 0; i < artworks.length; i++) {
      final artwork = artworks[i];
      final aspectRatio = artwork.aspectRatio;
      final estimatedHeight = aspectRatio > 0 ? colWidth / aspectRatio : colWidth;

      final col = _shortestColumn(columnHeights);
      columnChildren[col].add(
        Padding(
          padding: const EdgeInsets.only(bottom: gap),
          child: _StaggeredTile(
            index: i,
            child: ArtworkTile(
              key: ValueKey(artwork.id),
              artwork: artwork,
              onTap: onArtworkTap != null
                  ? () => onArtworkTap!(artwork)
                  : null,
            ),
          ),
        ),
      );
      columnHeights[col] += estimatedHeight;
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: List.generate(columns, (col) {
        return Expanded(
          child: Padding(
            padding: EdgeInsets.only(
              left: col > 0 ? gap / 2 : 0,
              right: col < columns - 1 ? gap / 2 : 0,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: columnChildren[col],
            ),
          ),
        );
      }),
    );
  }

  int _shortestColumn(List<double> heights) {
    var minIdx = 0;
    var minVal = heights[0];
    for (int i = 1; i < heights.length; i++) {
      if (heights[i] < minVal) {
        minVal = heights[i];
        minIdx = i;
      }
    }
    return minIdx;
  }
}

class _StaggeredTile extends StatefulWidget {
  final Widget child;
  final int index;

  const _StaggeredTile({required this.child, required this.index});

  @override
  State<_StaggeredTile> createState() => _StaggeredTileState();
}

class _StaggeredTileState extends State<_StaggeredTile> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration(milliseconds: 60 * widget.index), () {
      if (mounted) setState(() => _visible = true);
    });
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) {
      return Opacity(
        opacity: 0,
        child: widget.child,
      );
    }
    return FadeAnimation(
      duration: AppDurations.normal,
      child: SlideAnimation(
        begin: const Offset(0, 0.06),
        duration: AppDurations.fast,
        child: widget.child,
      ),
    );
  }
}
