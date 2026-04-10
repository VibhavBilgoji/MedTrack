import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/medicine_entity.dart';
import '../repositories/medicine_repository.dart';

class GetMedicinesUseCase {
  final MedicineRepository _repository;
  GetMedicinesUseCase(this._repository);
  Future<Either<Failure, List<MedicineEntity>>> call(String userId) =>
      _repository.getMedicines(userId);
}

class WatchMedicinesUseCase {
  final MedicineRepository _repository;
  WatchMedicinesUseCase(this._repository);
  Stream<List<MedicineEntity>> call(String userId) =>
      _repository.watchMedicines(userId);
}

class AddMedicineUseCase {
  final MedicineRepository _repository;
  AddMedicineUseCase(this._repository);
  Future<Either<Failure, MedicineEntity>> call(MedicineEntity medicine) =>
      _repository.addMedicine(medicine);
}

class UpdateMedicineUseCase {
  final MedicineRepository _repository;
  UpdateMedicineUseCase(this._repository);
  Future<Either<Failure, MedicineEntity>> call(MedicineEntity medicine) =>
      _repository.updateMedicine(medicine);
}

class DeleteMedicineUseCase {
  final MedicineRepository _repository;
  DeleteMedicineUseCase(this._repository);
  Future<Either<Failure, void>> call(String userId, String id) =>
      _repository.deleteMedicine(userId, id);
}

class GetExpiringSoonUseCase {
  final MedicineRepository _repository;
  GetExpiringSoonUseCase(this._repository);
  Future<Either<Failure, List<MedicineEntity>>> call(String userId, int days) =>
      _repository.getExpiringSoon(userId, days);
}
