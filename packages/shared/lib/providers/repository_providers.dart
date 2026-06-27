import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/providers/firebase_providers.dart';
import 'package:shared/repositories/firestore_artwork_repository.dart';
import 'package:shared/repositories/firestore_artist_repository.dart';
import 'package:shared/repositories/firestore_collection_repository.dart';
import 'package:shared/repositories/firestore_settings_repository.dart';
import 'package:shared/repositories/firestore_technique_repository.dart';

final artworkRepositoryProvider = Provider<FirestoreArtworkRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return FirestoreArtworkRepository(firestoreService);
});

final artistRepositoryProvider = Provider<FirestoreArtistRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return FirestoreArtistRepository(firestoreService);
});

final collectionRepositoryProvider = Provider<FirestoreCollectionRepository>((
  ref,
) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return FirestoreCollectionRepository(firestoreService);
});

final techniqueRepositoryProvider = Provider<FirestoreTechniqueRepository>((
  ref,
) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return FirestoreTechniqueRepository(firestoreService);
});

final settingsRepositoryProvider = Provider<FirestoreSettingsRepository>((ref) {
  final firestoreService = ref.watch(firestoreServiceProvider);
  return FirestoreSettingsRepository(firestoreService);
});
