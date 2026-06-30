import 'package:flutter/material.dart';
import 'package:shared/shared/widgets/hero_artwork_image.dart';

class DetailHeroImage extends StatelessWidget {
  final String? imageUrl;
  final String heroTag;
  final double aspectRatio;
  final double opacity;
  final String? blurHash;

  const DetailHeroImage({
    super.key,
    required this.imageUrl,
    required this.heroTag,
    this.aspectRatio = 1.0,
    this.opacity = 1.0,
    this.blurHash,
  });

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: opacity,
      child: HeroArtworkImage(
        imageUrl: imageUrl,
        heroTag: heroTag,
        width: double.infinity,
        aspectRatio: aspectRatio,
        borderRadius: 0,
        fit: BoxFit.cover,
        blurHash: blurHash,
      ),
    );
  }
}
