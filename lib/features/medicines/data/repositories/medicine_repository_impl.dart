import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/medicine_entity.dart';
import '../../domain/repositories/medicine_repository.dart';
import '../datasources/medicine_remote_datasource.dart';

class MedicineRepositoryImpl implements MedicineRepository {
  final MedicineRemoteDataSource _remote;

  MedicineRepositoryImpl(this._remote);

  @override
  Stream<List<MedicineEntity>> watchMedicines(String userId) =>
      _remote.watchMedicines(userId).map((list) => list.map((m) => m.toEntity()).toList());

  @override
  Future<Either<Failure, List<MedicineEntity>>> getMedicines(String userId) async {
    try {
      final models = await _remote.getMedicines(userId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, MedicineEntity>> getMedicineById(String userId, String id) async {
    try {
      return Right((await _remote.getMedicineById(userId, id)).toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, MedicineEntity>> addMedicine(MedicineEntity medicine) async {
    try {
      return Right((await _remote.addMedicine(medicine)).toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, MedicineEntity>> updateMedicine(MedicineEntity medicine) async {
    try {
      return Right((await _remote.updateMedicine(medicine)).toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, void>> deleteMedicine(String userId, String id) async {
    try {
      await _remote.deleteMedicine(userId, id);
      return const Right(null);
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<MedicineEntity>>> getExpiringSoon(String userId, int days) async {
    try {
      final models = await _remote.getExpiringSoon(userId, days);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }

  @override
  Future<Either<Failure, List<MedicineEntity>>> getExpired(String userId) async {
    try {
      final models = await _remote.getExpired(userId);
      return Right(models.map((m) => m.toEntity()).toList());
    } on ServerException catch (e) {
      return Left(ServerFailure(e.message));
    }
  }
}
