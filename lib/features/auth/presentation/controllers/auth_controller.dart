import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:medtrack/core/providers/providers.dart';
import 'package:medtrack/features/auth/domain/entities/user_entity.dart';

// ── Auth State ────────────────────────────────────────────────────────────────

class AuthState {
  final bool isLoading;
  final UserEntity? user;
  final String? error;

  const AuthState({this.isLoading = false, this.user, this.error});

  AuthState copyWith({bool? isLoading, UserEntity? user, String? error, bool clearError = false}) {
    return AuthState(
      isLoading: isLoading ?? this.isLoading,
      user: user ?? this.user,
      error: clearError ? null : (error ?? this.error),
    );
  }
}

// ── Auth Controller ───────────────────────────────────────────────────────────

class AuthController extends StateNotifier<AuthState> {
  final Ref _ref;

  AuthController(this._ref) : super(const AuthState());

  Future<bool> signInWithEmail(String email, String password) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _ref.read(signInWithEmailUseCaseProvider)(
      email: email, password: password,
    );
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (user) {
        state = state.copyWith(isLoading: false, user: user);
        return true;
      },
    );
  }

  Future<bool> signUpWithEmail(String email, String password, String name) async {
    state = state.copyWith(isLoading: true, clearError: true);
    final result = await _ref.read(signUpWithEmailUseCaseProvider)(
      email: email, password: password, name: name,
    );
    return result.fold(
      (failure) {
        state = state.copyWith(isLoading: false, error: failure.message);
        return false;
      },
      (user) {
        state = state.copyWith(isLoading: false, user: user);
        return true;
      },
    );
  }

  // Google Sign-In not yet supported in Supabase migration
  // Future<bool> signInWithGoogle() async { ... }

  Future<void> signOut() async {
    await _ref.read(signOutUseCaseProvider)();
    state = const AuthState();
  }

  void clearError() => state = state.copyWith(clearError: true);
}

final authControllerProvider = StateNotifierProvider<AuthController, AuthState>((ref) {
  return AuthController(ref);
});
