import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/models/artwork.dart';
import 'package:shared/models/json_converters.dart';
import 'package:shared/repositories/artwork_repository.dart';
import 'package:shared/services/firestore_service.dart';

class FirestoreArtworkRepository implements ArtworkRepository {
  final FirestoreService _firestoreService;
  final String _collectionPath;

  FirestoreArtworkRepository(
    this._firestoreService, {
    this._collectionPath = 'artworks',
  });

  Map<String, dynamic> _artworkToJson(Artwork artwork) {
    final json = <String, dynamic>{
      'title': artwork.title,
      'description': artwork.description,
      'imageUrl': artwork.imageUrl,
      'thumbnailUrl': artwork.thumbnailUrl,
      'blurHash': artwork.blurHash,
      'artistId': artwork.artistId,
      'collectionIds': artwork.collectionIds.isEmpty ? null : artwork.collectionIds,
      'techniqueIds': artwork.techniqueIds.isEmpty ? null : artwork.techniqueIds,
      'aspectRatio': artwork.aspectRatio,
      'featured': artwork.featured,
      'featuredOrder': artwork.featuredOrder,
      'published': artwork.published,

    };
    if (artwork.id != null) json['id'] = artwork.id;
    return json;
  }

  Artwork _artworkFromJson(Map<String, dynamic> json) {
    return Artwork(
      id: json['id'] as String?,
      title: json['title'] as String? ?? '',
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      blurHash: json['blurHash'] as String?,
      artistId: json['artistId'] as String?,
      collectionIds: (json['collectionIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      techniqueIds: (json['techniqueIds'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      aspectRatio: (json['aspectRatio'] as num?)?.toDouble() ?? 1.0,
      featured: json['featured'] as bool? ?? false,
      featuredOrder: json['featuredOrder'] as int? ?? 0,
      published: json['published'] as bool? ?? false,

      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );
  }

  @override
  Stream<List<Artwork>> watchAll() {
    return _firestoreService.watchAll(
      path: _collectionPath,
      fromJson: _artworkFromJson,
    );
  }

  @override
  Stream<List<Artwork>> watchPublished() {
    final query = _firestoreService.firestore
        .collection(_collectionPath)
        .where('published', isEqualTo: true)
        .orderBy('createdAt', descending: true);
    return _firestoreService.watchAll(
      path: _collectionPath,
      fromJson: _artworkFromJson,
      query: query,
    );
  }

  @override
  Stream<List<Artwork>> watchFeatured() {
    final query = _firestoreService.firestore
        .collection(_collectionPath)
        .where('published', isEqualTo: true)
        .where('featured', isEqualTo: true)
        .orderBy('featuredOrder');
    return _firestoreService.watchAll(
      path: _collectionPath,
      fromJson: _artworkFromJson,
      query: query,
    );
  }

  @override
  Stream<List<Artwork>> watchByCollection(String collectionId) {
    final query = _firestoreService.firestore
        .collection(_collectionPath)
        .where('published', isEqualTo: true)
        .where('collectionIds', arrayContains: collectionId);
    return _firestoreService.watchAll(
      path: _collectionPath,
      fromJson: _artworkFromJson,
      query: query,
    );
  }

  @override
  Stream<List<Artwork>> watchByArtist(String artistId) {
    final query = _firestoreService.firestore
        .collection(_collectionPath)
        .where('published', isEqualTo: true)
        .where('artistId', isEqualTo: artistId);
    return _firestoreService.watchAll(
      path: _collectionPath,
      fromJson: _artworkFromJson,
      query: query,
    );
  }

  @override
  Stream<Artwork?> watchById(String id) {
    return _firestoreService.watchById(
      path: _collectionPath,
      id: id,
      fromJson: _artworkFromJson,
    );
  }

  @override
  Stream<Artwork?> watchByFieldId(String id) {
    final query = _firestoreService.firestore
        .collection(_collectionPath)
        .where('id', isEqualTo: id)
        .limit(1);
    return _firestoreService.watchAll(
      path: _collectionPath,
      fromJson: _artworkFromJson,
      query: query,
    ).map((list) => list.isNotEmpty ? list.first : null);
  }

  @override
  Future<List<Artwork>> getAll({bool? published}) async {
    Query<Map<String, dynamic>>? query;
    if (published != null) {
      query = _firestoreService.firestore
          .collection(_collectionPath)
          .where('published', isEqualTo: published);
    }
    return _firestoreService.getAll(
      path: _collectionPath,
      fromJson: _artworkFromJson,
      query: query,
    );
  }

  @override
  Future<Artwork?> getById(String id) {
    return _firestoreService.getById(
      path: _collectionPath,
      id: id,
      fromJson: _artworkFromJson,
    );
  }

  @override
  Future<Artwork> create(Artwork artwork) async {
    final id = await _firestoreService.getNextId(
      path: _collectionPath,
      prefix: 'artwork-',
      padLength: 4,
    );
    final withId = artwork.copyWith(id: id);
    return _firestoreService.create(
      path: _collectionPath,
      data: withId,
      id: id,
      fromJson: _artworkFromJson,
      toJson: _artworkToJson,
    );
  }

  @override
  Future<Artwork> update(Artwork artwork) {
    return _firestoreService.update(
      path: _collectionPath,
      id: artwork.id!,
      data: artwork,
      fromJson: _artworkFromJson,
      toJson: _artworkToJson,
    );
  }

  @override
  Future<void> delete(String id) {
    return _firestoreService.delete(path: _collectionPath, id: id);
  }
}
