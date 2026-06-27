import 'package:shared/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'artist.freezed.dart';
part 'artist.g.dart';

@freezed
class Artist with _$Artist {
  const factory Artist({
    String? id,
    required String name,
    String? bio,
    String? quote,
    String? photoUrl,
    String? profession,
    String? email,
    String? website,
    String? location,
    Map<String, String>? socialLinks,
    @Default(false) bool published,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _Artist;

  factory Artist.fromJson(Map<String, dynamic> json) => _$ArtistFromJson(json);
}
