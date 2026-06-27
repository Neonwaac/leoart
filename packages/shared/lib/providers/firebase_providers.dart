import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase_auth;
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared/services/auth_service.dart';
import 'package:shared/services/cloudinary_service.dart';
import 'package:shared/services/firestore_service.dart';

final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final firebaseAuthProvider = Provider<firebase_auth.FirebaseAuth>((ref) {
  return firebase_auth.FirebaseAuth.instance;
});

final firestoreServiceProvider = Provider<FirestoreService>((ref) {
  final firestore = ref.watch(firestoreProvider);
  return FirestoreService(firestore);
});

final authServiceProvider = Provider<AuthService>((ref) {
  final auth = ref.watch(firebaseAuthProvider);
  return AuthService(auth);
});

final cloudinaryConfigProvider = Provider<CloudinaryConfig?>((ref) {
  final cloudName = dotenv.env['CLOUDINARY_CLOUD_NAME'];
  final apiKey = dotenv.env['CLOUDINARY_API_KEY'];
  final apiSecret = dotenv.env['CLOUDINARY_API_SECRET'];
  if (cloudName == null || apiKey == null || apiSecret == null) return null;
  return CloudinaryConfig(
    cloudName: cloudName,
    apiKey: apiKey,
    apiSecret: apiSecret,
  );
});

final cloudinaryServiceProvider = Provider<CloudinaryService?>((ref) {
  final config = ref.watch(cloudinaryConfigProvider);
  if (config == null) return null;
  return CloudinaryService(config: config);
});

final authStateProvider = StreamProvider<firebase_auth.User?>((ref) {
  final authService = ref.watch(authServiceProvider);
  return authService.authStateChanges;
});
