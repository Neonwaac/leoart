import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

final adminTechniquesProvider = StreamProvider<List<Technique>>((ref) {
  final repo = ref.watch(techniqueRepositoryProvider);
  return repo.watchAll();
});

final adminTechniqueProvider = StreamProvider.family<Technique?, String>((ref, id) {
  final repo = ref.watch(techniqueRepositoryProvider);
  return repo.watchById(id);
});

final createTechniqueProvider = FutureProvider.family<Technique, Technique>((ref, technique) async {
  final repo = ref.watch(techniqueRepositoryProvider);
  return repo.create(technique);
});

final updateTechniqueProvider = FutureProvider.family<Technique, Technique>((ref, technique) async {
  final repo = ref.watch(techniqueRepositoryProvider);
  return repo.update(technique);
});
