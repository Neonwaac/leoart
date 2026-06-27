// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artwork.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArtworkImpl _$$ArtworkImplFromJson(Map<String, dynamic> json) =>
    _$ArtworkImpl(
      id: json['id'] as String?,
      title: json['title'] as String,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      blurHash: json['blurHash'] as String?,
      artistId: json['artistId'] as String?,
      collectionIds:
          (json['collectionIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      techniqueIds:
          (json['techniqueIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          const [],
      aspectRatio: (json['aspectRatio'] as num?)?.toDouble() ?? 1.0,
      featured: json['featured'] as bool? ?? false,
      featuredOrder: (json['featuredOrder'] as num?)?.toInt() ?? 0,
      published: json['published'] as bool? ?? false,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$ArtworkImplToJson(_$ArtworkImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'imageUrl': instance.imageUrl,
      'thumbnailUrl': instance.thumbnailUrl,
      'blurHash': instance.blurHash,
      'artistId': instance.artistId,
      'collectionIds': instance.collectionIds,
      'techniqueIds': instance.techniqueIds,
      'aspectRatio': instance.aspectRatio,
      'featured': instance.featured,
      'featuredOrder': instance.featuredOrder,
      'published': instance.published,
      'createdAt': _$JsonConverterToJson<dynamic, DateTime>(
        instance.createdAt,
        const TimestampConverter().toJson,
      ),
      'updatedAt': _$JsonConverterToJson<dynamic, DateTime>(
        instance.updatedAt,
        const TimestampConverter().toJson,
      ),
    };

Json? _$JsonConverterToJson<Json, Value>(
  Value? value,
  Json? Function(Value value) toJson,
) => value == null ? null : toJson(value);
