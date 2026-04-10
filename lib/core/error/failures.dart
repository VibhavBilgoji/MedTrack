import 'package:equatable/equatable.dart';

/// Base failure class for the domain layer
abstract class Failure extends Equatable {
  final String message;
  const Failure(this.message);

  @override
  List<Object> get props => [message];
}

class ServerFailure extends Failure {
  const ServerFailure([super.message = 'Server error occurred.']);
}

class NetworkFailure extends Failure {
  const NetworkFailure([super.message = 'No internet connection.']);
}

class AuthFailure extends Failure {
  const AuthFailure([super.message = 'Authentication failed.']);
}

class CacheFailure extends Failure {
  const CacheFailure([super.message = 'Local cache error.']);
}

class OcrFailure extends Failure {
  const OcrFailure([super.message = 'Could not detect expiry date.']);
}

class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = 'Resource not found.']);
}

class PermissionFailure extends Failure {
  const PermissionFailure([super.message = 'Camera permission denied.']);
}

/// Base exception class for the data layer
class AppException implements Exception {
  final String message;
  final String? code;
  AppException(this.message, {this.code});

  @override
  String toString() => 'AppException: $message (code: $code)';
}

class ServerException extends AppException {
  ServerException([super.message = 'Server error.', String? code]) : super(code: code);
}

class NetworkException extends AppException {
  NetworkException([super.message = 'No internet.']);
}

class AuthException extends AppException {
  AuthException([super.message = 'Auth failed.', String? code]) : super(code: code);
}

class CacheException extends AppException {
  CacheException([super.message = 'Cache error.']);
}
