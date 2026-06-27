import 'package:shared/models/json_converters.dart';
import 'package:shared/models/technique.dart';
import 'package:shared/repositories/technique_repository.dart';
import 'package:shared/services/firestore_service.dart';

class FirestoreTechniqueRepository implements TechniqueRepository {
  final FirestoreService _firestoreService;
  final String _collectionPath;

  FirestoreTechniqueRepository(
    this._firestoreService, {
    this._collectionPath = 'techniques',
  });

  Map<String, dynamic> _techniqueToJson(Technique technique) {
    final json = <String, dynamic>{
      'name': technique.name,
      'description': technique.description,
      'published': technique.published,
    };
    if (technique.id != null) json['id'] = technique.id;
    return json;
  }

  Technique _techniqueFromJson(Map<String, dynamic> json) {
    return Technique(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      published: json['published'] as bool? ?? false,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );
  }

  @override
  Stream<List<Technique>> watchAll() {
    return _firestoreService.watchAll(
      path: _collectionPath,
      fromJson: _techniqueFromJson,
    );
  }

  @override
  Stream<Technique?> watchById(String id) {
    return _firestoreService.watchById(
      path: _collectionPath,
      id: id,
      fromJson: _techniqueFromJson,
    );
  }

  @override
  Future<List<Technique>> getAll() {
    return _firestoreService.getAll(
      path: _collectionPath,
      fromJson: _techniqueFromJson,
    );
  }

  @override
  Future<Technique?> getById(String id) {
    return _firestoreService.getById(
      path: _collectionPath,
      id: id,
      fromJson: _techniqueFromJson,
    );
  }

  @override
  Future<Technique> create(Technique technique) {
    return _firestoreService.create(
      path: _collectionPath,
      data: technique,
      fromJson: _techniqueFromJson,
      toJson: _techniqueToJson,
    );
  }

  @override
  Future<Technique> update(Technique technique) {
    return _firestoreService.update(
      path: _collectionPath,
      id: technique.id!,
      data: technique,
      fromJson: _techniqueFromJson,
      toJson: _techniqueToJson,
    );
  }

  @override
  Future<void> delete(String id) {
    return _firestoreService.delete(path: _collectionPath, id: id);
  }
}
