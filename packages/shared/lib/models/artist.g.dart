// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'artist.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ArtistImpl _$$ArtistImplFromJson(Map<String, dynamic> json) => _$ArtistImpl(
  id: json['id'] as String?,
  name: json['name'] as String,
  bio: json['bio'] as String?,
  quote: json['quote'] as String?,
  photoUrl: json['photoUrl'] as String?,
  profession: json['profession'] as String?,
  email: json['email'] as String?,
  website: json['website'] as String?,
  location: json['location'] as String?,
  socialLinks: (json['socialLinks'] as Map<String, dynamic>?)?.map(
    (k, e) => MapEntry(k, e as String),
  ),
  published: json['published'] as bool? ?? false,
  createdAt: const TimestampConverter().fromJson(json['createdAt']),
  updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
);

Map<String, dynamic> _$$ArtistImplToJson(_$ArtistImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'bio': instance.bio,
      'quote': instance.quote,
      'photoUrl': instance.photoUrl,
      'profession': instance.profession,
      'email': instance.email,
      'website': instance.website,
      'location': instance.location,
      'socialLinks': instance.socialLinks,
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
