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
    return _remoteDataSource.authStateChanges.map((model) {
      return model?.toEntity();
    });
  }

  @override
  UserEntity? get currentUser {
    return _remoteDataSource.currentUser?.toEntity();
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithEmail({
    required String email,
    required String password,
  }) async {
    try {
      final model = await _remoteDataSource.signInWithEmail(email, password);
      return Right(model.toEntity());
    } on ServerException catch (e) {
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
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, UserEntity>> signInWithGoogle() async {
    return const Left(ServerFailure('Google sign-in not implemented for simple auth.'));
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
    } on ServerException catch (e) {
      return Left(AuthFailure(e.message));
    } catch (e) {
      return Left(ServerFailure(e.toString()));
    }
  }
}


