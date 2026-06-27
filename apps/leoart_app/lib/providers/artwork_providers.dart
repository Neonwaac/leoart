import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

final catalogProvider = StreamProvider<List<Artwork>>((ref) {
  final repository = ref.watch(artworkRepositoryProvider);
  return repository.watchPublished();
});

final featuredArtworksProvider = StreamProvider<List<Artwork>>((ref) {
  final repository = ref.watch(artworkRepositoryProvider);
  return repository.watchFeatured();
});

final artworkProvider =
    StreamProvider.family<Artwork?, String>((ref, id) {
  final repository = ref.watch(artworkRepositoryProvider);
  return repository.watchById(id);
});

final collectionArtworksProvider =
    StreamProvider.family<List<Artwork>, String>((ref, collectionId) {
  final repository = ref.watch(artworkRepositoryProvider);
  return repository.watchByCollection(collectionId);
});

final techniquesProvider = StreamProvider<List<Technique>>((ref) {
  final repository = ref.watch(techniqueRepositoryProvider);
  return repository.watchAll();
});
