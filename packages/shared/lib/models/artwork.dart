import 'package:shared/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'artwork.freezed.dart';
part 'artwork.g.dart';

@freezed
class Artwork with _$Artwork {
  const factory Artwork({
    String? id,
    required String title,
    String? description,
    String? imageUrl,
    String? thumbnailUrl,
    String? blurHash,
    String? artistId,
    @Default([]) List<String> collectionIds,
    @Default([]) List<String> techniqueIds,
    @Default(1.0) double aspectRatio,
    @Default(false) bool featured,
    @Default(0) int featuredOrder,
    @Default(false) bool published,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _Artwork;

  factory Artwork.fromJson(Map<String, dynamic> json) =>
      _$ArtworkFromJson(json);
}
