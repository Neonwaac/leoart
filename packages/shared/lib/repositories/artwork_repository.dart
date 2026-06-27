import 'package:shared/models/artwork.dart';

abstract class ArtworkRepository {
  Stream<List<Artwork>> watchAll();
  Stream<List<Artwork>> watchPublished();
  Stream<List<Artwork>> watchFeatured();
  Stream<List<Artwork>> watchByCollection(String collectionId);
  Stream<List<Artwork>> watchByArtist(String artistId);
  Stream<Artwork?> watchById(String id);
  Future<List<Artwork>> getAll({bool? published});
  Future<Artwork?> getById(String id);
  Future<Artwork> create(Artwork artwork);
  Future<Artwork> update(Artwork artwork);
  Future<void> delete(String id);
}
