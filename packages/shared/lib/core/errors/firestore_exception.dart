import 'app_exception.dart';

class FirestoreException extends AppException {
  const FirestoreException({
    required super.message,
    super.code,
    super.stackTrace,
  });
}
