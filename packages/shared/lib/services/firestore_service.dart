import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared/core/errors/firestore_exception.dart';

class FirestoreService {
  final FirebaseFirestore _firestore;

  FirestoreService(this._firestore);

  FirebaseFirestore get firestore => _firestore;

  CollectionReference<T> collection<T>({
    required String path,
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, dynamic> Function(T data)? toJson,
  }) {
    return _firestore
        .collection(path)
        .withConverter<T>(
          fromFirestore: (snapshot, _) => fromJson(snapshot.data()!),
          toFirestore: (data, _) =>
              toJson != null ? toJson(data) : (data as dynamic).toJson(),
        );
  }

  Future<T> create<T>({
    required String path,
    required T data,
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, dynamic> Function(T data)? toJson,
    String? id,
  }) async {
    try {
      final ref = id != null
          ? _firestore.collection(path).doc(id)
          : _firestore.collection(path).doc();
      final json = toJson != null ? toJson(data) : (data as dynamic).toJson();
      json['id'] = ref.id;
      json['createdAt'] = FieldValue.serverTimestamp();
      json['updatedAt'] = FieldValue.serverTimestamp();
      await ref.set(json);
      return fromJson(json);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to create document',
        code: e.code,
        stackTrace: StackTrace.current,
      );
    }
  }

  Future<T> update<T>({
    required String path,
    required String id,
    required T data,
    required T Function(Map<String, dynamic> json) fromJson,
    Map<String, dynamic> Function(T data)? toJson,
  }) async {
    try {
      final json = toJson != null ? toJson(data) : (data as dynamic).toJson();
      json['id'] = id;
      json['updatedAt'] = FieldValue.serverTimestamp();
      await _firestore.collection(path).doc(id).update(json);
      return fromJson(json);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to update document',
        code: e.code,
        stackTrace: StackTrace.current,
      );
    }
  }

  Future<void> delete({required String path, required String id}) async {
    try {
      await _firestore.collection(path).doc(id).delete();
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to delete document',
        code: e.code,
        stackTrace: StackTrace.current,
      );
    }
  }

  Future<T?> getById<T>({
    required String path,
    required String id,
    required T Function(Map<String, dynamic> json) fromJson,
  }) async {
    try {
      final doc = await _firestore.collection(path).doc(id).get();
      if (!doc.exists) return null;
      return fromJson(doc.data()!);
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to get document',
        code: e.code,
        stackTrace: StackTrace.current,
      );
    }
  }

  Future<List<T>> getAll<T>({
    required String path,
    required T Function(Map<String, dynamic> json) fromJson,
    Query<Map<String, dynamic>>? query,
  }) async {
    try {
      final snapshots = await (query ?? _firestore.collection(path)).get();
      return snapshots.docs.map((doc) => fromJson(doc.data())).toList();
    } on FirebaseException catch (e) {
      throw FirestoreException(
        message: 'Failed to get documents',
        code: e.code,
        stackTrace: StackTrace.current,
      );
    }
  }

  Stream<List<T>> watchAll<T>({
    required String path,
    required T Function(Map<String, dynamic> json) fromJson,
    Query<Map<String, dynamic>>? query,
  }) {
    return (query ?? _firestore.collection(path)).snapshots().map(
      (snapshot) => snapshot.docs.map((doc) => fromJson(doc.data())).toList(),
    );
  }

  Stream<T?> watchById<T>({
    required String path,
    required String id,
    required T Function(Map<String, dynamic> json) fromJson,
  }) {
    return _firestore
        .collection(path)
        .doc(id)
        .snapshots()
        .map(
          (snapshot) => snapshot.exists
              ? fromJson(snapshot.data() as Map<String, dynamic>)
              : null,
        );
  }
}
