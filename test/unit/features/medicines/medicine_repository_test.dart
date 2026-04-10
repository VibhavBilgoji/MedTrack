import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:medtrack/core/error/failures.dart';
import 'package:medtrack/core/utils/expiry_risk_engine.dart';
import 'package:medtrack/features/medicines/domain/entities/medicine_entity.dart';
import 'package:medtrack/features/medicines/domain/repositories/medicine_repository.dart';
import 'package:medtrack/features/medicines/domain/usecases/medicine_usecases.dart';

class MockMedicineRepository extends Mock implements MedicineRepository {}

void main() {
  late MockMedicineRepository mockRepository;
  late GetMedicinesUseCase getMedicinesUseCase;
  late AddMedicineUseCase addMedicineUseCase;
  late DeleteMedicineUseCase deleteMedicineUseCase;

  final testMedicine = MedicineEntity(
    id: 'test-id-1',
    userId: 'user-1',
    name: 'Paracetamol 500mg',
    category: 'Tablet / Capsule',
    expiryDate: DateTime.now().add(const Duration(days: 100)),
    status: ExpiryStatus.safe,
    createdAt: DateTime.now(),
  );

  setUpAll(() {
    registerFallbackValue(testMedicine);
  });

  setUp(() {
    mockRepository = MockMedicineRepository();
    getMedicinesUseCase = GetMedicinesUseCase(mockRepository);
    addMedicineUseCase = AddMedicineUseCase(mockRepository);
    deleteMedicineUseCase = DeleteMedicineUseCase(mockRepository);
  });

  group('GetMedicinesUseCase', () {
    test('returns list of medicines on success', () async {
      when(() => mockRepository.getMedicines('user-1'))
          .thenAnswer((_) async => Right([testMedicine]));

      final result = await getMedicinesUseCase('user-1');

      expect(result.isRight(), true);
      result.fold(
        (_) => fail('Should be Right'),
        (list) => expect(list.length, 1),
      );
      verify(() => mockRepository.getMedicines('user-1')).called(1);
    });

    test('returns ServerFailure on error', () async {
      when(() => mockRepository.getMedicines('user-1'))
          .thenAnswer((_) async => const Left(ServerFailure('Server error')));

      final result = await getMedicinesUseCase('user-1');
      expect(result.isLeft(), true);
    });
  });

  group('AddMedicineUseCase', () {
    test('adds medicine and returns it', () async {
      when(() => mockRepository.addMedicine(any()))
          .thenAnswer((_) async => Right(testMedicine));

      final result = await addMedicineUseCase(testMedicine);
      expect(result.isRight(), true);
    });
  });

  group('DeleteMedicineUseCase', () {
    test('deletes medicine successfully', () async {
      when(() => mockRepository.deleteMedicine('user-1', 'test-id-1'))
          .thenAnswer((_) async => const Right(null));

      final result = await deleteMedicineUseCase('user-1', 'test-id-1');
      expect(result.isRight(), true);
    });
  });

  group('MedicineEntity', () {
    test('daysUntilExpiry is positive for future date', () {
      expect(testMedicine.daysUntilExpiry, greaterThan(0));
    });

    test('isExpired is false for future date', () {
      expect(testMedicine.isExpired, false);
    });

    test('copyWith preserves fields', () {
      final updated = testMedicine.copyWith(name: 'Ibuprofen');
      expect(updated.name, 'Ibuprofen');
      expect(updated.id, testMedicine.id);
      expect(updated.userId, testMedicine.userId);
    });
  });
}
