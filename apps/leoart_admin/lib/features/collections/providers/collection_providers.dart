import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

final adminCollectionsProvider = StreamProvider<List<Collection>>((ref) {
  final repo = ref.watch(collectionRepositoryProvider);
  return repo.watchAll();
});

final adminCollectionProvider = StreamProvider.family<Collection?, String>((ref, id) {
  final repo = ref.watch(collectionRepositoryProvider);
  return repo.watchById(id);
});

final createCollectionProvider = FutureProvider.family<Collection, Collection>((ref, collection) async {
  final repo = ref.watch(collectionRepositoryProvider);
  return repo.create(collection);
});

final updateCollectionProvider = FutureProvider.family<Collection, Collection>((ref, collection) async {
  final repo = ref.watch(collectionRepositoryProvider);
  return repo.update(collection);
});

final deleteCollectionProvider = FutureProvider.family<void, String>((ref, id) async {
  final repo = ref.watch(collectionRepositoryProvider);
  return repo.delete(id);
});
