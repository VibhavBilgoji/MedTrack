import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/extensions/extensions.dart';
import '../controllers/auth_controller.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _signIn() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(authControllerProvider.notifier)
        .signInWithEmail(_emailCtrl.text.trim(), _passCtrl.text);
    if (ok && mounted) context.go(AppRoutes.dashboard);
  }

  // Future<void> _signInGoogle() async {
  //   final ok = await ref.read(authControllerProvider.notifier).signInWithGoogle();
  //   if (ok && mounted) context.go(AppRoutes.dashboard);
  // }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: isDark
                    ? [const Color(0xFF0F172A), const Color(0xFF1E293B), const Color(0xFF0F172A)]
                    : [const Color(0xFFEFF6FF), const Color(0xFFDBEAFE), const Color(0xFFEFF6FF)],
              ),
            ),
          ),
          // Decorative circles
          Positioned(
            top: -80, right: -80,
            child: Container(
              width: 250, height: 250,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primary.withValues(alpha: 0.15),
              ),
            ),
          ),
          Positioned(
            bottom: -60, left: -60,
            child: Container(
              width: 200, height: 200,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.primaryLight.withValues(alpha: 0.1),
              ),
            ),
          ),
          // Main content
          SafeArea(
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 60),
                  // Logo & Title
                  _buildHeader(isDark)
                      .animate().fadeIn(duration: 600.ms).slideY(begin: -0.2, end: 0),
                  const SizedBox(height: 48),
                  // Glass Card
                  _buildGlassCard(isDark, state)
                      .animate().fadeIn(delay: 200.ms, duration: 600.ms).slideY(begin: 0.2, end: 0),
                  const SizedBox(height: 24),
                  // Register link
                  _buildRegisterLink()
                      .animate().fadeIn(delay: 400.ms, duration: 600.ms),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(bool isDark) {
    return Column(
      children: [
        Container(
          width: 72, height: 72,
          decoration: BoxDecoration(
            color: AppColors.primary,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.4),
                blurRadius: 20, offset: const Offset(0, 8),
              ),
            ],
          ),
          child: const Icon(Icons.medical_services_rounded, color: Colors.white, size: 40),
        ),
        const SizedBox(height: 16),
        Text(
          AppStrings.appName,
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
            color: isDark ? AppColors.textPrimaryDark : AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: 6),
        Text(
          AppStrings.appTagline,
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ],
    );
  }

  Widget _buildGlassCard(bool isDark, AuthState state) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppSizes.radiusLg),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: const EdgeInsets.all(28),
          decoration: BoxDecoration(
            color: isDark ? AppColors.glassDark : AppColors.glassLight,
            borderRadius: BorderRadius.circular(AppSizes.radiusLg),
            border: Border.all(
              color: isDark ? AppColors.glassBorderDark : AppColors.glassBorderLight,
            ),
          ),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text('Welcome back',
                    style: Theme.of(context).textTheme.headlineMedium),
                const SizedBox(height: 4),
                Text('Sign in to your account',
                    style: Theme.of(context).textTheme.bodyMedium),
                const SizedBox(height: 24),
                // Error banner
                if (state.error != null) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.criticalContainer,
                      borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline, color: AppColors.critical, size: 16),
                        const SizedBox(width: 8),
                        Expanded(child: Text(state.error!, style: const TextStyle(color: AppColors.critical, fontSize: 13))),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
                // Email
                TextFormField(
                  key: const Key('login_email'),
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    prefixIcon: Icon(Icons.email_outlined),
                  ),
                  validator: (v) {
                    if (v == null || v.isBlank) return 'Email is required';
                    if (!v.isValidEmail) return 'Enter a valid email';
                    return null;
                  },
                ),
                const SizedBox(height: 16),
                // Password
                TextFormField(
                  key: const Key('login_password'),
                  controller: _passCtrl,
                  obscureText: _obscure,
                  decoration: InputDecoration(
                    labelText: 'Password',
                    prefixIcon: const Icon(Icons.lock_outlined),
                    suffixIcon: IconButton(
                      icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                      onPressed: () => setState(() => _obscure = !_obscure),
                    ),
                  ),
                  validator: (v) {
                    if (v == null || v.isBlank) return 'Password is required';
                    return null;
                  },
                ),
                const SizedBox(height: 8),
                Align(
                  alignment: Alignment.centerRight,
                  child: TextButton(
                    onPressed: () {},
                    child: const Text(AppStrings.forgotPassword),
                  ),
                ),
                const SizedBox(height: 8),
                // Sign in button
                SizedBox(
                  height: 52,
                  child: ElevatedButton(
                    key: const Key('login_submit'),
                    onPressed: state.isLoading ? null : _signIn,
                    child: state.isLoading
                        ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text(AppStrings.signIn),
                  ),
                ),
                const SizedBox(height: 20),
                // Divider
                Row(
                  children: [
                    const Expanded(child: Divider()),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('or', style: Theme.of(context).textTheme.bodySmall),
                    ),
                    const Expanded(child: Divider()),
                  ],
                ),
                const SizedBox(height: 20),
                // Google Sign-In (Disabled for now)
                /*
                OutlinedButton.icon(
                  key: const Key('login_google'),
                  onPressed: state.isLoading ? null : _signInGoogle,
                  icon: Container(
                    width: 20, height: 20,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: NetworkImage('https://www.gstatic.com/firebasejs/ui/2.0.0/images/auth/google.svg'),
                      ),
                    ),
                  ),
                  label: const Text(AppStrings.continueWithGoogle),
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                  ),
                ),
                */
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildRegisterLink() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(AppStrings.dontHaveAccount, style: Theme.of(context).textTheme.bodyMedium),
        TextButton(
          onPressed: () => context.push(AppRoutes.register),
          child: const Text(AppStrings.signUp),
        ),
      ],
    );
  }
}

// ── Register Screen ────────────────────────────────────────────────────────────

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _obscure = true;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_formKey.currentState!.validate()) return;
    final ok = await ref.read(authControllerProvider.notifier)
        .signUpWithEmail(_emailCtrl.text.trim(), _passCtrl.text, _nameCtrl.text.trim());
    if (ok && mounted) context.go(AppRoutes.dashboard);
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(authControllerProvider);
    // final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(title: const Text('Create Account')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const SizedBox(height: 16),
              Text('Join MedTrack', style: Theme.of(context).textTheme.headlineLarge),
              const SizedBox(height: 6),
              Text('Track your medicines smarter', style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: 32),
              if (state.error != null) ...[
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.criticalContainer,
                    borderRadius: BorderRadius.circular(AppSizes.radiusSm),
                  ),
                  child: Text(state.error!, style: const TextStyle(color: AppColors.critical)),
                ),
                const SizedBox(height: 16),
              ],
              TextFormField(
                key: const Key('register_name'),
                controller: _nameCtrl,
                decoration: const InputDecoration(labelText: 'Full Name', prefixIcon: Icon(Icons.person_outline)),
                validator: (v) => (v == null || v.isBlank) ? 'Name is required' : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('register_email'),
                controller: _emailCtrl,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(labelText: 'Email', prefixIcon: Icon(Icons.email_outlined)),
                validator: (v) {
                  if (v == null || v.isBlank) return 'Email is required';
                  if (!v.isValidEmail) return 'Invalid email';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('register_password'),
                controller: _passCtrl,
                obscureText: _obscure,
                decoration: InputDecoration(
                  labelText: 'Password',
                  prefixIcon: const Icon(Icons.lock_outlined),
                  suffixIcon: IconButton(
                    icon: Icon(_obscure ? Icons.visibility_outlined : Icons.visibility_off_outlined),
                    onPressed: () => setState(() => _obscure = !_obscure),
                  ),
                  helperText: 'Minimum 8 characters',
                ),
                validator: (v) {
                  if (v == null || v.isBlank) return 'Password is required';
                  if (!v.isStrongPassword) return 'Minimum 8 characters';
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                key: const Key('register_confirm'),
                controller: _confirmCtrl,
                obscureText: _obscure,
                decoration: const InputDecoration(labelText: 'Confirm Password', prefixIcon: Icon(Icons.lock_outline_rounded)),
                validator: (v) => v != _passCtrl.text ? 'Passwords do not match' : null,
              ),
              const SizedBox(height: 32),
              SizedBox(
                height: 52,
                child: ElevatedButton(
                  key: const Key('register_submit'),
                  onPressed: state.isLoading ? null : _register,
                  child: state.isLoading
                      ? const SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                      : const Text('Create Account'),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
