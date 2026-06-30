import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/collection.dart';
import 'package:shared/models/json_converters.dart';
import 'package:shared/repositories/collection_repository.dart';
import 'package:shared/services/firestore_service.dart';

class FirestoreCollectionRepository implements CollectionRepository {
  final FirestoreService _firestoreService;
  final String _collectionPath;

  FirestoreCollectionRepository(
    this._firestoreService, {
    this._collectionPath = 'collections',
  });

  Map<String, dynamic> _collectionToJson(Collection collection) {
    final json = <String, dynamic>{
      'name': collection.name,
      'description': collection.description,
      'coverImageUrl': collection.coverImageUrl,
      'published': collection.published,
      'displayOrder': collection.displayOrder,
    };
    if (collection.id != null) json['id'] = collection.id;
    return json;
  }

  Collection _collectionFromJson(Map<String, dynamic> json) {
    return Collection(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      description: json['description'] as String?,
      coverImageUrl: json['coverImageUrl'] as String?,
      published: json['published'] as bool? ?? false,
      displayOrder: json['displayOrder'] as int? ?? 0,
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );
  }

  @override
  Stream<List<Collection>> watchAll() {
    return _firestoreService.watchAll(
      path: _collectionPath,
      fromJson: _collectionFromJson,
    );
  }

  @override
  Stream<List<Collection>> watchPublished() {
    final query = _firestoreService.firestore
        .collection(_collectionPath)
        .where('published', isEqualTo: true)
        .orderBy('displayOrder');
    return _firestoreService.watchAll(
      path: _collectionPath,
      fromJson: _collectionFromJson,
      query: query,
    );
  }

  @override
  Stream<Collection?> watchById(String id) {
    return _firestoreService.watchById(
      path: _collectionPath,
      id: id,
      fromJson: _collectionFromJson,
    );
  }

  CollectionReference<Map<String, dynamic>> get _collection =>
      _firestoreService.firestore.collection(_collectionPath);

  @override
  Future<List<Collection>> getAll({bool? published}) async {
    var query = _collection.orderBy('displayOrder');
    if (published != null) {
      query = query.where('published', isEqualTo: published);
    }
    return _firestoreService.getAll(
      path: _collectionPath,
      fromJson: _collectionFromJson,
      query: query,
    );
  }

  @override
  Future<Collection?> getById(String id) {
    return _firestoreService.getById(
      path: _collectionPath,
      id: id,
      fromJson: _collectionFromJson,
    );
  }

  @override
  Future<Collection> create(Collection collection) async {
    final id = await _firestoreService.getNextId(
      path: _collectionPath,
      prefix: 'collection-',
    );
    final withId = collection.copyWith(id: id);
    return _firestoreService.create(
      path: _collectionPath,
      data: withId,
      id: id,
      fromJson: _collectionFromJson,
      toJson: _collectionToJson,
    );
  }

  @override
  Future<Collection> update(Collection collection) {
    return _firestoreService.update(
      path: _collectionPath,
      id: collection.id!,
      data: collection,
      fromJson: _collectionFromJson,
      toJson: _collectionToJson,
    );
  }

  @override
  Future<void> delete(String id) {
    return _firestoreService.delete(path: _collectionPath, id: id);
  }
}
