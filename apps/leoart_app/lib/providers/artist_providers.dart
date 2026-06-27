import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/shared.dart';

final artistProvider = StreamProvider<Artist?>((ref) {
  final repository = ref.watch(artistRepositoryProvider);
  return repository.watchById('artist');
});
