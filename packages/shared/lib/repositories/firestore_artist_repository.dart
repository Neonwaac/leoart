import 'package:shared/models/artist.dart';
import 'package:shared/models/json_converters.dart';
import 'package:shared/repositories/artist_repository.dart';
import 'package:shared/services/firestore_service.dart';

class FirestoreArtistRepository implements ArtistRepository {
  final FirestoreService _firestoreService;
  final String _collectionPath;

  FirestoreArtistRepository(
    this._firestoreService, {
    this._collectionPath = 'artists',
  });

  Map<String, dynamic> _artistToJson(Artist artist) {
    final json = <String, dynamic>{
      'name': artist.name,
      'bio': artist.bio,
      'photoUrl': artist.photoUrl,
      'email': artist.email,
      'website': artist.website,
      'quote': artist.quote,
      'profession': artist.profession,
      'location': artist.location,
      'published': artist.published,
      'socialLinks': artist.socialLinks,
    };
    if (artist.id != null) json['id'] = artist.id;
    return json;
  }

  Artist _artistFromJson(Map<String, dynamic> json) {
    final socialLinksJson = json['socialLinks'] as Map<String, dynamic>?;

    return Artist(
      id: json['id'] as String?,
      name: json['name'] as String? ?? '',
      bio: json['bio'] as String?,
      photoUrl: json['photoUrl'] as String?,
      email: json['email'] as String?,
      website: json['website'] as String?,
      quote: json['quote'] as String?,
      profession: json['profession'] as String?,
      location: json['location'] as String?,
      published: json['published'] as bool? ?? false,
      socialLinks: socialLinksJson?.map(
        (key, value) => MapEntry(key, value as String),
      ),
      createdAt: const TimestampConverter().fromJson(json['createdAt']),
      updatedAt: const TimestampConverter().fromJson(json['updatedAt']),
    );
  }

  @override
  Stream<List<Artist>> watchAll() {
    return _firestoreService.watchAll(
      path: _collectionPath,
      fromJson: _artistFromJson,
    );
  }

  @override
  Stream<Artist?> watchById(String id) {
    return _firestoreService.watchById(
      path: _collectionPath,
      id: id,
      fromJson: _artistFromJson,
    );
  }

  @override
  Future<List<Artist>> getAll() {
    return _firestoreService.getAll(
      path: _collectionPath,
      fromJson: _artistFromJson,
    );
  }

  @override
  Future<Artist?> getById(String id) {
    return _firestoreService.getById(
      path: _collectionPath,
      id: id,
      fromJson: _artistFromJson,
    );
  }

  @override
  Future<Artist> create(Artist artist) async {
    final id = await _firestoreService.getNextId(
      path: _collectionPath,
      prefix: 'artist-',
    );
    final withId = artist.copyWith(id: id);
    return _firestoreService.create(
      path: _collectionPath,
      data: withId,
      id: id,
      fromJson: _artistFromJson,
      toJson: _artistToJson,
    );
  }

  @override
  Future<Artist> update(Artist artist) {
    return _firestoreService.update(
      path: _collectionPath,
      id: artist.id!,
      data: artist,
      fromJson: _artistFromJson,
      toJson: _artistToJson,
    );
  }

  @override
  Future<void> delete(String id) {
    return _firestoreService.delete(path: _collectionPath, id: id);
  }
}
