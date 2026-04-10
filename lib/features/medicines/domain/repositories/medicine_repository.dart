import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/medicine_entity.dart';

abstract class MedicineRepository {
  Stream<List<MedicineEntity>> watchMedicines(String userId);
  Future<Either<Failure, List<MedicineEntity>>> getMedicines(String userId);
  Future<Either<Failure, MedicineEntity>> getMedicineById(String userId, String id);
  Future<Either<Failure, MedicineEntity>> addMedicine(MedicineEntity medicine);
  Future<Either<Failure, MedicineEntity>> updateMedicine(MedicineEntity medicine);
  Future<Either<Failure, void>> deleteMedicine(String userId, String id);
  Future<Either<Failure, List<MedicineEntity>>> getExpiringSoon(String userId, int days);
  Future<Either<Failure, List<MedicineEntity>>> getExpired(String userId);
}
