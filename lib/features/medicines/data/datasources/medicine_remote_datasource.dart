import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../../domain/entities/medicine_entity.dart';
import '../models/medicine_model.dart';
import '../../../../core/error/failures.dart';

/// Supabase remote data source for medicines
class MedicineRemoteDataSource {
  final SupabaseClient _supabase;
  final Uuid _uuid;

  MedicineRemoteDataSource({required SupabaseClient supabase, Uuid? uuid})
      : _supabase = supabase,
        _uuid = uuid ?? const Uuid();

  /// Polls every 5 seconds instead of using Supabase Realtime (which requires
  /// JWT auth that we've bypassed). This avoids RealtimeSubscribeException.
  Stream<List<MedicineModel>> watchMedicines(String userId) async* {
    while (true) {
      try {
        final data = await getMedicines(userId);
        yield data;
      } catch (_) {
        yield [];
      }
      await Future.delayed(const Duration(seconds: 5));
    }
  }

  Future<List<MedicineModel>> getMedicines(String userId) async {
    try {
      final List<dynamic> response = await _supabase
          .from('medicines')
          .select()
          .eq('user_id', userId)
          .order('expiry_date', ascending: true);
          
      return response.map((json) => MedicineModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw ServerException('Failed to fetch medicines: $e');
    }
  }

  Future<MedicineModel> getMedicineById(String userId, String id) async {
    try {
      final response = await _supabase
          .from('medicines')
          .select()
          .eq('user_id', userId)
          .eq('id', id)
          .single();
          
      return MedicineModel.fromJson(response);
    } catch (e) {
      throw ServerException('Failed to get medicine: $e');
    }
  }

  Future<MedicineModel> addMedicine(MedicineEntity entity) async {
    try {
      final id = _uuid.v4();
      final model = MedicineModel.fromEntity(entity).copyWithId(id);
      await _supabase.from('medicines').insert(model.toJson());
      return model;
    } catch (e) {
      throw ServerException('Failed to add medicine: $e');
    }
  }

  Future<MedicineModel> updateMedicine(MedicineEntity entity) async {
    try {
      final model = MedicineModel.fromEntity(entity);
      await _supabase
          .from('medicines')
          .update(model.toJson())
          .eq('id', entity.id)
          .eq('user_id', entity.userId);
      return model;
    } catch (e) {
      throw ServerException('Failed to update medicine: $e');
    }
  }

  Future<void> deleteMedicine(String userId, String id) async {
    try {
      await _supabase
          .from('medicines')
          .delete()
          .eq('id', id)
          .eq('user_id', userId);
    } catch (e) {
      throw ServerException('Failed to delete medicine: $e');
    }
  }

  Future<List<MedicineModel>> getExpiringSoon(String userId, int days) async {
    try {
      final now = DateTime.now();
      final cutoff = now.add(Duration(days: days));
      
      final List<dynamic> response = await _supabase
          .from('medicines')
          .select()
          .eq('user_id', userId)
          .gte('expiry_date', now.toIso8601String())
          .lte('expiry_date', cutoff.toIso8601String())
          .order('expiry_date', ascending: true);
          
      return response.map((json) => MedicineModel.fromJson(json as Map<String, dynamic>)).toList();
    } catch (e) {
      throw ServerException('Failed to query expiring medicines: $e');
    }
  }

  Future<List<MedicineModel>> getExpired(String userId) async {
    try {
      final now = DateTime.now();
      final List<dynamic> response = await _supabase
          .from('medicines')
          .select()
          .eq('user_id', userId)
          .lt('expiry_date', now.toIso8601String())
          .order('expiry_date', ascending: false);
          
      return response.map((json) => MedicineModel.fromJson(json as Map<String, dynamic>)).toList();
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
