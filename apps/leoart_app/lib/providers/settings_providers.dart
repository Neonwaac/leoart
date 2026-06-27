import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

final settingsAppProvider = StreamProvider<Settings?>((ref) {
  final repository = ref.watch(settingsRepositoryProvider);
  return repository.watchById('app');
});
