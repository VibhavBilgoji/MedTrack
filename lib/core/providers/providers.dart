import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import 'package:medtrack/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:medtrack/features/auth/data/datasources/simple_auth_service.dart';
import 'package:medtrack/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:medtrack/features/auth/domain/entities/user_entity.dart';
import 'package:medtrack/features/auth/domain/repositories/auth_repository.dart';
import 'package:medtrack/features/auth/domain/usecases/auth_usecases.dart';
import 'package:medtrack/features/medicines/data/datasources/medicine_remote_datasource.dart';
import 'package:medtrack/features/medicines/data/repositories/medicine_repository_impl.dart';
import 'package:medtrack/features/medicines/domain/repositories/medicine_repository.dart';
import 'package:medtrack/features/medicines/domain/usecases/medicine_usecases.dart';

// ── Supabase & Utils ──────────────────────────────────────────────────────────
final supabaseClientProvider = Provider<SupabaseClient>((ref) => Supabase.instance.client);
final uuidProvider = Provider<Uuid>((ref) => const Uuid());

// ── Auth data sources & repo ──────────────────────────────────────────────────
final simpleAuthServiceProvider = Provider<SimpleAuthService>((ref) {
  return SimpleAuthService(ref.read(supabaseClientProvider));
});

final authRemoteDataSourceProvider = Provider<AuthRemoteDataSource>((ref) {
  return AuthRemoteDataSource(
    supabase: ref.read(supabaseClientProvider),
    simpleAuth: ref.read(simpleAuthServiceProvider),
  );
});

final authRepositoryProvider = Provider<AuthRepository>((ref) {
  return AuthRepositoryImpl(ref.read(authRemoteDataSourceProvider));
});

// ── Auth use cases ────────────────────────────────────────────────────────────
final signInWithEmailUseCaseProvider = Provider((ref) =>
    SignInWithEmailUseCase(ref.read(authRepositoryProvider)));
final signUpWithEmailUseCaseProvider = Provider((ref) =>
    SignUpWithEmailUseCase(ref.read(authRepositoryProvider)));
final signOutUseCaseProvider = Provider((ref) =>
    SignOutUseCase(ref.read(authRepositoryProvider)));

// ── Auth state stream ─────────────────────────────────────────────────────────
final authStateProvider = StreamProvider<UserEntity?>((ref) {
  return ref.watch(authRepositoryProvider).authStateChanges;
});

// ── Medicine data sources & repo ──────────────────────────────────────────────
final medicineRemoteDataSourceProvider = Provider<MedicineRemoteDataSource>((ref) {
  return MedicineRemoteDataSource(
    supabase: ref.read(supabaseClientProvider),
    uuid: ref.read(uuidProvider),
  );
});

final medicineRepositoryProvider = Provider<MedicineRepository>((ref) {
  return MedicineRepositoryImpl(ref.read(medicineRemoteDataSourceProvider));
});

// ── Medicine use cases ────────────────────────────────────────────────────────
final getMedicinesUseCaseProvider = Provider((ref) =>
    GetMedicinesUseCase(ref.read(medicineRepositoryProvider)));
final watchMedicinesUseCaseProvider = Provider((ref) =>
    WatchMedicinesUseCase(ref.read(medicineRepositoryProvider)));
final addMedicineUseCaseProvider = Provider((ref) =>
    AddMedicineUseCase(ref.read(medicineRepositoryProvider)));
final updateMedicineUseCaseProvider = Provider((ref) =>
    UpdateMedicineUseCase(ref.read(medicineRepositoryProvider)));
final deleteMedicineUseCaseProvider = Provider((ref) =>
    DeleteMedicineUseCase(ref.read(medicineRepositoryProvider)));
final getExpiringSoonUseCaseProvider = Provider((ref) =>
    GetExpiringSoonUseCase(ref.read(medicineRepositoryProvider)));
