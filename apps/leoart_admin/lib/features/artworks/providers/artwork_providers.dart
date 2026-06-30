import 'dart:async';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

final adminArtworksProvider = StreamProvider<List<Artwork>>((ref) {
  final repo = ref.watch(artworkRepositoryProvider);
  final controller = StreamController<List<Artwork>>();
  final sub = repo.watchAll().listen(
    (artworks) {
      artworks.sort((a, b) {
        final aDate = a.createdAt ?? DateTime(2000);
        final bDate = b.createdAt ?? DateTime(2000);
        return bDate.compareTo(aDate);
      });
      controller.add(artworks);
    },
    onError: (err) => controller.addError(err),
  );
  ref.onDispose(() {
    sub.cancel();
    controller.close();
  });
  return controller.stream;
});

final adminArtworkProvider = StreamProvider.family<Artwork?, String>((ref, id) {
  final repo = ref.watch(artworkRepositoryProvider);
  return repo.watchById(id);
});

final createArtworkProvider = FutureProvider.family<Artwork, Artwork>((ref, artwork) async {
  final repo = ref.watch(artworkRepositoryProvider);
  return repo.create(artwork);
});

final updateArtworkProvider = FutureProvider.family<Artwork, Artwork>((ref, artwork) async {
  final repo = ref.watch(artworkRepositoryProvider);
  return repo.update(artwork);
});

final deleteArtworkProvider = FutureProvider.family<void, String>((ref, id) async {
  final repo = ref.watch(artworkRepositoryProvider);
  return repo.delete(id);
});

final adminArtistsProvider = StreamProvider<List<Artist>>((ref) {
  final repo = ref.watch(artistRepositoryProvider);
  return repo.watchAll();
});
