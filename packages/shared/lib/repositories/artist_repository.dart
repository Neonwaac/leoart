import 'package:shared/models/artist.dart';

abstract class ArtistRepository {
  Stream<List<Artist>> watchAll();
  Stream<Artist?> watchById(String id);
  Future<List<Artist>> getAll();
  Future<Artist?> getById(String id);
  Future<Artist> create(Artist artist);
  Future<Artist> update(Artist artist);
  Future<void> delete(String id);
}
