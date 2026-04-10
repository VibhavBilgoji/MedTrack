import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user_entity.dart';
import '../repositories/auth_repository.dart';

class SignInWithEmailUseCase {
  final AuthRepository _repository;
  SignInWithEmailUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
  }) => _repository.signInWithEmail(email: email, password: password);
}

class SignUpWithEmailUseCase {
  final AuthRepository _repository;
  SignUpWithEmailUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call({
    required String email,
    required String password,
    required String name,
  }) => _repository.signUpWithEmail(email: email, password: password, name: name);
}

class SignInWithGoogleUseCase {
  final AuthRepository _repository;
  SignInWithGoogleUseCase(this._repository);

  Future<Either<Failure, UserEntity>> call() => _repository.signInWithGoogle();
}

class SignOutUseCase {
  final AuthRepository _repository;
  SignOutUseCase(this._repository);

  Future<Either<Failure, void>> call() => _repository.signOut();
}

class GetCurrentUserUseCase {
  final AuthRepository _repository;
  GetCurrentUserUseCase(this._repository);

  UserEntity? call() => _repository.currentUser;
}
