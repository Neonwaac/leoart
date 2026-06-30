import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

final adminSettingsProvider = StreamProvider<Settings?>((ref) {
  final repo = ref.watch(settingsRepositoryProvider);
  return repo.watchById('app');
});

final updateSettingsProvider = FutureProvider.family<Settings, Settings>((ref, settings) async {
  final repo = ref.watch(settingsRepositoryProvider);
  return repo.update(settings);
});

final createSettingsProvider = FutureProvider.family<Settings, Settings>((ref, settings) async {
  final repo = ref.watch(settingsRepositoryProvider);
  return repo.create(settings);
});
