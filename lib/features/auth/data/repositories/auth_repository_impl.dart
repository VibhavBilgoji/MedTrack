import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/user_entity.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource _remoteDataSource;

  AuthRepositoryImpl(this._remoteDataSource);

  @override
  Stream<UserEntity?> get authStateChanges {
    return _remoteDataSource.authStateChanges.asyncMap((user) async {
      if (user == null) return null;
      try {
        return await _remoteDataSource.getUserModel(user).then((m) => m.toEntity());
      } catch (_) {
        return null;
      }
    });
  }

  @override
  UserEntity? get currentUser {
    final user = _remoteDataSource.currentFirebaseUser;
    if (user == null) return null;
    return UserEntity(
      id: user.uid,
      email: user.email ?? '',
      name: user.displayName ?? 'User',
      photoUrl: user.photoURL,
      createdAt: DateTime.now(),
    );
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _remoteDataSource.signInWithEmail(email, password);
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  }) async {
    try {
      final model = await _remoteDataSource.signUpWithEmail(email, password, name);
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    try {
      final model = await _remoteDataSource.signInWithGoogle();
      return Right(model.toEntity());
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> signOut() async {
    try {
      await _remoteDataSource.signOut();
      return const Right(null);
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> sendPasswordReset(String email) async {
    try {
      await _remoteDataSource.sendPasswordReset(email);
      return const Right(null);
    } on AuthException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}


