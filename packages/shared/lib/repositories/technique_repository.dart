import 'package:shared/models/technique.dart';

abstract class TechniqueRepository {
  Stream<List<Technique>> watchAll();
  Stream<Technique?> watchById(String id);
  Future<List<Technique>> getAll();
  Future<Technique?> getById(String id);
  Future<Technique> create(Technique technique);
  Future<Technique> update(Technique technique);
  Future<void> delete(String id);
}
