import 'package:shared/models/settings.dart';

abstract class SettingsRepository {
  Stream<List<Settings>> watchAll();
  Stream<Settings?> watchById(String id);
  Future<List<Settings>> getAll();
  Future<Settings?> getById(String id);
  Future<Settings> create(Settings settings);
  Future<Settings> update(Settings settings);
  Future<void> delete(String id);
}
