import 'package:shared/models/collection.dart';

abstract class CollectionRepository {
  Stream<List<Collection>> watchAll();
  Stream<List<Collection>> watchPublished();
  Stream<Collection?> watchById(String id);
  Future<List<Collection>> getAll({bool? published});
  Future<Collection?> getById(String id);
  Future<Collection> create(Collection collection);
  Future<Collection> update(Collection collection);
  Future<void> delete(String id);
}
