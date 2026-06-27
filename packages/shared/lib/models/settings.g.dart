// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$SettingsImpl _$$SettingsImplFromJson(Map<String, dynamic> json) =>
    _$SettingsImpl(
      id: json['id'] as String?,
      appName: json['appName'] as String,
      appDescription: json['appDescription'] as String?,
      primaryColor: json['primaryColor'] as String?,
      logoUrl: json['logoUrl'] as String?,
      faviconUrl: json['faviconUrl'] as String?,
      email: json['email'] as String?,
      socialLinks: (json['socialLinks'] as Map<String, dynamic>?)?.map(
        (k, e) => MapEntry(k, e as String),
      ),
      maintenanceMode: json['maintenanceMode'] as bool? ?? false,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );

Map<String, dynamic> _$$SettingsImplToJson(_$SettingsImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'appName': instance.appName,
      'appDescription': instance.appDescription,
      'primaryColor': instance.primaryColor,
      'logoUrl': instance.logoUrl,
      'faviconUrl': instance.faviconUrl,
      'email': instance.email,
      'socialLinks': instance.socialLinks,
      'maintenanceMode': instance.maintenanceMode,
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
