import 'package:shared/models/json_converters.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'settings.freezed.dart';
part 'settings.g.dart';

@freezed
class Settings with _$Settings {
  const factory Settings({
    String? id,
    required String appName,
    String? appDescription,
    String? primaryColor,
    String? logoUrl,
    String? faviconUrl,
    String? email,
    Map<String, String>? socialLinks,
    @Default(false) bool maintenanceMode,
    @TimestampConverter() DateTime? createdAt,
    @TimestampConverter() DateTime? updatedAt,
  }) = _Settings;

  factory Settings.fromJson(Map<String, dynamic> json) =>
      _$SettingsFromJson(json);
}
