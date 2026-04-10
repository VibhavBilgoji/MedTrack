// ─── Auth Feature — Domain Layer ──────────────────────────────────────────────

import 'package:dartz/dartz.dart';
import 'package:medtrack/core/error/failures.dart';
import 'package:medtrack/features/auth/domain/entities/user_entity.dart';

/// Abstract interface for authentication operations
abstract class AuthRepository {
  Stream<UserEntity?> get authStateChanges;

  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  });

  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });

  Future<Either<Failure, UserEntity>> signInWithGoogle();

  Future<Either<Failure, void>> signOut();

  Future<Either<Failure, void>> sendPasswordReset(String email);

  UserEntity? get currentUser;
}
