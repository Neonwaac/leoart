import 'app_exception.dart';

class CloudinaryException extends AppException {
  const CloudinaryException({
    required super.message,
    super.code,
    super.stackTrace,
  });
}
