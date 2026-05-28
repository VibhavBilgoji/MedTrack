import 'package:supabase_flutter/supabase_flutter.dart';
import '../../../../core/error/failures.dart' hide AuthException;
import '../models/user_model.dart';
import 'simple_auth_service.dart';

/// Remote data source for Supabase Database user profile (custom auth)
class AuthRemoteDataSource {
  final SupabaseClient _supabase;
  final SimpleAuthService _simpleAuth;
  
  AuthRemoteDataSource({
    required SupabaseClient supabase,
    required SimpleAuthService simpleAuth,
  }) : _supabase = supabase, 
       _simpleAuth = simpleAuth;

  Stream<UserModel?> get authStateChanges => _simpleAuth.authStateChanges;

  UserModel? get currentUser => _simpleAuth.currentUser;

  Future<UserModel> signInWithEmail(String email, String password) async {
    try {
      return await _simpleAuth.signIn(email, password);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<UserModel> signUpWithEmail(String email, String password, String name) async {
    try {
      return await _simpleAuth.signUp(email, password, name);
    } on AuthException catch (e) {
      throw ServerException(e.message);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  Future<void> signOut() async {
    await _simpleAuth.signOut();
  }

  Future<void> sendPasswordReset(String email) async {
    // Simplified: in "Mock Auth" mode, we don't have a real reset flow
    throw ServerException('Password reset is not available in simplified auth mode.');
  }

  Future<UserModel> getUserModel(String userId) async {
    try {
      final response = await _supabase.from('users').select().eq('id', userId).single();
      return UserModel.fromJson(response);
    } catch (e) {
      throw ServerException('User profile not found: $e');
    }
  }
}
