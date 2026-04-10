import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/medicine_entity.dart';
import '../models/medicine_model.dart';
import '../../../../core/error/failures.dart';

/// Firestore remote data source for medicines
class MedicineRemoteDataSource {
  final FirebaseFirestore _firestore;
  final Uuid _uuid;

  MedicineRemoteDataSource({required FirebaseFirestore firestore, Uuid? uuid})
      : _firestore = firestore,
        _uuid = uuid ?? const Uuid();

  CollectionReference<Map<String, dynamic>> _col(String userId) =>
      _firestore.collection('users').doc(userId).collection('medicines');

  Stream<List<MedicineModel>> watchMedicines(String userId) {
    return _col(userId)
        .orderBy('expiryDate', descending: false)
        .snapshots()
        .map((snap) => snap.docs.map(MedicineModel.fromFirestore).toList());
  }

  Future<List<MedicineModel>> getMedicines(String userId) async {
    try {
      final snap = await _col(userId)
          .orderBy('expiryDate', descending: false)
          .get();
      return snap.docs.map(MedicineModel.fromFirestore).toList();
    } catch (e) {
      throw ServerException('Failed to fetch medicines: $e');
    }
  }

  Future<MedicineModel> getMedicineById(String userId, String id) async {
    try {
      final doc = await _col(userId).doc(id).get();
      if (!doc.exists) throw ServerException('Medicine not found.');
      return MedicineModel.fromFirestore(doc);
    } catch (e) {
      throw ServerException('Failed to get medicine: $e');
    }
  }

  Future<MedicineModel> addMedicine(MedicineEntity entity) async {
    try {
      final id = _uuid.v4();
      final model = MedicineModel.fromEntity(entity.copyWith()).copyWithId(id);
      await _col(entity.userId).doc(id).set(model.toFirestore());
      return model;
    } catch (e) {
      throw ServerException('Failed to add medicine: $e');
    }
  }

  Future<MedicineModel> updateMedicine(MedicineEntity entity) async {
    try {
      final model = MedicineModel.fromEntity(entity);
      await _col(entity.userId).doc(entity.id).update(model.toFirestore());
      return model;
    } catch (e) {
      throw ServerException('Failed to update medicine: $e');
    }
  }

  Future<void> deleteMedicine(String userId, String id) async {
    try {
      await _col(userId).doc(id).delete();
    } catch (e) {
      throw ServerException('Failed to delete medicine: $e');
    }
  }

  Future<List<MedicineModel>> getExpiringSoon(String userId, int days) async {
    try {
      final now = DateTime.now();
      final cutoff = now.add(Duration(days: days));
      final snap = await _col(userId)
          .where('expiryDate', isGreaterThanOrEqualTo: Timestamp.fromDate(now))
          .where('expiryDate', isLessThanOrEqualTo: Timestamp.fromDate(cutoff))
          .orderBy('expiryDate')
          .get();
      return snap.docs.map(MedicineModel.fromFirestore).toList();
    } catch (e) {
      throw ServerException('Failed to query expiring medicines: $e');
    }
  }

  Future<List<MedicineModel>> getExpired(String userId) async {
    try {
      final now = DateTime.now();
      final snap = await _col(userId)
          .where('expiryDate', isLessThan: Timestamp.fromDate(now))
          .orderBy('expiryDate', descending: true)
          .get();
      return snap.docs.map(MedicineModel.fromFirestore).toList();
    } catch (e) {
      throw ServerException('Failed to query expired medicines: $e');
    }
  }
}

extension MedicineModelExt on MedicineModel {
  MedicineModel copyWithId(String newId) => MedicineModel(
    id: newId,
    userId: userId,
    name: name,
    category: category,
    expiryDate: expiryDate,
    manufacturingDate: manufacturingDate,
    shelfLifeMonths: shelfLifeMonths,
    imageUrl: imageUrl,
    ocrConfidence: ocrConfidence,
    createdAt: createdAt,
    lastNotifiedAt: lastNotifiedAt,
    notificationEnabled: notificationEnabled,
    batchNumber: batchNumber,
    notes: notes,
  );
}
