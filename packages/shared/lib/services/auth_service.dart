import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:shared/core/errors/authentication_exception.dart';

class AuthService {
  final firebase.FirebaseAuth _auth;

  AuthService(this._auth);

  firebase.User? get currentUser => _auth.currentUser;

  Stream<firebase.User?> get authStateChanges => _auth.authStateChanges();

  Future<firebase.User?> signInWithEmailAndPassword({
    required String email,
    required String password,
  }) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      return result.user;
    } on firebase.FirebaseAuthException catch (e) {
      throw AuthenticationException(
        message: e.message ?? 'Authentication failed',
        code: e.code,
        stackTrace: StackTrace.current,
      );
    }
  }

  Future<void> signOut() async {
    try {
      await _auth.signOut();
    } on firebase.FirebaseAuthException catch (e) {
      throw AuthenticationException(
        message: e.message ?? 'Sign out failed',
        code: e.code,
        stackTrace: StackTrace.current,
      );
    }
  }

  Future<void> sendPasswordResetEmail({required String email}) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
    } on firebase.FirebaseAuthException catch (e) {
      throw AuthenticationException(
        message: e.message ?? 'Failed to send password reset email',
        code: e.code,
        stackTrace: StackTrace.current,
      );
    }
  }
}
