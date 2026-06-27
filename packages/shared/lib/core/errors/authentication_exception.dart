import 'app_exception.dart';

class AuthenticationException extends AppException {
  const AuthenticationException({
    required super.message,
    super.code,
    super.stackTrace,
  });
}
