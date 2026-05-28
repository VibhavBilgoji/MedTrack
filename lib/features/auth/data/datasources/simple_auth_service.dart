import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:uuid/uuid.dart';
import '../models/user_model.dart';

/// A simplified authentication service that bypasses Supabase Auth.
/// It stores user credentials directly in a Supabase table ('users') and 
/// manages a local session to keep the user logged in.
class SimpleAuthService {
  final SupabaseClient _supabase;
  final _storage = const FlutterSecureStorage();
  final _authStateController = StreamController<UserModel?>.broadcast();
  
  UserModel? _currentUser;
  
  SimpleAuthService(this._supabase) {
    _init();
  }

  Stream<UserModel?> get authStateChanges => _authStateController.stream;
  UserModel? get currentUser => _currentUser;

  Future<void> _init() async {
    try {
      final sessionJson = await _storage.read(key: 'user_session');
      if (sessionJson != null) {
        _currentUser = UserModel.fromJson(jsonDecode(sessionJson));
        _authStateController.add(_currentUser);
      } else {
        _authStateController.add(null);
      }
    } catch (_) {
      await _storage.delete(key: 'user_session');
      _authStateController.add(null);
    }
  }

  Future<UserModel> signIn(String email, String password) async {
    try {
      // Query the 'users' table for match
      final response = await _supabase
          .from('users')
          .select()
          .eq('email', email)
          .eq('password', password) // Simple match for prototype
          .maybeSingle();

      if (response == null) {
        throw const AuthException('Invalid email or password');
      }

      final user = UserModel.fromJson(response);
      await _saveSession(user);
      return user;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Login failed: ${e.toString()}');
    }
  }

  Future<UserModel> signUp(String email, String password, String name) async {
    try {
      // Check if user already exists
      final existing = await _supabase
          .from('users')
          .select('email')
          .eq('email', email)
          .maybeSingle();

      if (existing != null) {
        throw const AuthException('User with this email already exists');
      }

      final userId = const Uuid().v4();
      final user = UserModel(
        id: userId,
        email: email,
        name: name,
        createdAt: DateTime.now(),
      );

      final userData = user.toJson();
      userData['password'] = password; // Add password to the data for our custom auth

      await _supabase.from('users').upsert(userData);
      
      await _saveSession(user);
      return user;
    } catch (e) {
      if (e is AuthException) rethrow;
      throw AuthException('Registration failed: ${e.toString()}');
    }
  }

  Future<void> signOut() async {
    await _storage.delete(key: 'user_session');
    _currentUser = null;
    _authStateController.add(null);
  }

  Future<void> _saveSession(UserModel user) async {
    _currentUser = user;
    await _storage.write(key: 'user_session', value: jsonEncode(user.toJson()));
    _authStateController.add(user);
  }
}
