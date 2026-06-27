import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

final collectionsProvider = StreamProvider<List<Collection>>((ref) {
  final repository = ref.watch(collectionRepositoryProvider);
  return repository.watchPublished();
});
