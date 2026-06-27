import 'package:shared/models/json_converters.dart';
import 'package:shared/models/settings.dart';
import 'package:shared/repositories/settings_repository.dart';
import 'package:shared/services/firestore_service.dart';

class FirestoreSettingsRepository implements SettingsRepository {
  final FirestoreService _firestoreService;
  final String _collectionPath;

  FirestoreSettingsRepository(
    this._firestoreService, {
    this._collectionPath = 'settings',
  });

  Map<String, dynamic> _settingsToJson(Settings settings) {
    final json = <String, dynamic>{
      'appName': settings.appName,
      'appDescription': settings.appDescription,
      'primaryColor': settings.primaryColor,
      'logoUrl': settings.logoUrl,
      'faviconUrl': settings.faviconUrl,
      'email': settings.email,
      'socialLinks': settings.socialLinks,
      'maintenanceMode': settings.maintenanceMode,
    };
    if (settings.id != null) json['id'] = settings.id;
    return json;
  }

  Settings _settingsFromJson(Map<String, dynamic> json) {
    return Settings(
      id: json['id'] as String?,
      appName: json['appName'] as String? ?? '',
      appDescription: json['appDescription'] as String?,
      primaryColor: json['primaryColor'] as String?,
      logoUrl: json['logoUrl'] as String?,
      faviconUrl: json['faviconUrl'] as String?,
      email: json['email'] as String?,
      socialLinks:
          (json['socialLinks'] as Map<String, dynamic>?)
              ?.map((k, e) => MapEntry(k, e as String)),
      maintenanceMode: json['maintenanceMode'] as bool? ?? false,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );
  }

  @override
  Stream<List<Settings>> watchAll() {
    return _firestoreService.watchAll(
      path: _collectionPath,
      fromJson: _settingsFromJson,
    );
  }

  @override
  Stream<Settings?> watchById(String id) {
    return _firestoreService.watchById(
      path: _collectionPath,
      id: id,
      fromJson: _settingsFromJson,
    );
  }

  @override
  Future<List<Settings>> getAll() {
    return _firestoreService.getAll(
      path: _collectionPath,
      fromJson: _settingsFromJson,
    );
  }

  @override
  Future<Settings?> getById(String id) {
    return _firestoreService.getById(
      path: _collectionPath,
      id: id,
      fromJson: _settingsFromJson,
    );
  }

  @override
  Future<Settings> create(Settings settings) {
    return _firestoreService.create(
      path: _collectionPath,
      data: settings,
      fromJson: _settingsFromJson,
      toJson: _settingsToJson,
    );
  }

  @override
  Future<Settings> update(Settings settings) {
    return _firestoreService.update(
      path: _collectionPath,
      id: settings.id!,
      data: settings,
      fromJson: _settingsFromJson,
      toJson: _settingsToJson,
    );
  }

  @override
  Future<void> delete(String id) {
    return _firestoreService.delete(path: _collectionPath, id: id);
  }
}
