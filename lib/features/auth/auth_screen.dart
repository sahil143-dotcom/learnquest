import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_theme.dart';
import '../../core/constants/routes.dart';
import '../../core/services/auth_service.dart';
import '../../shared/widgets/glass_card.dart';

// ─── AuthScreen ───────────────────────────────────────────────────────────────
// Combined login + sign-up screen, now wired to Firebase Auth.
// Uses ConsumerStatefulWidget so we can read Riverpod providers.

class AuthScreen extends ConsumerStatefulWidget {
  const AuthScreen({super.key});

  @override
  ConsumerState<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends ConsumerState<AuthScreen> {
  bool _isSignUp = true;
  bool _isLoading = false;
  String? _errorMessage;

  // Saved career path (null = not yet chosen)
  String? _selectedCareerId;
  String? _selectedCareerEmoji;
  String? _selectedCareerTitle;

  final _nameController     = TextEditingController();
  final _emailController    = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCareerAndCheckAuth();
  }

  Future<void> _loadCareerAndCheckAuth() async {
    final prefs = await SharedPreferences.getInstance();
    final id = prefs.getString('selected_career_id');
    if (id != null && mounted) {
      setState(() {
        _selectedCareerId    = id;
        _selectedCareerEmoji = prefs.getString('selected_career_emoji');
        _selectedCareerTitle = prefs.getString('selected_career_title');
      });
    }
  }

  Future<void> _clearCareerPath() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('selected_career_id');
    await prefs.remove('selected_career_emoji');
    await prefs.remove('selected_career_title');
    if (mounted) {
      setState(() {
        _selectedCareerId    = null;
        _selectedCareerEmoji = null;
        _selectedCareerTitle = null;
      });
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _navigateAfterLogin({bool isNewUser = false}) {
    if (isNewUser) {
      Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.welcome, (route) => false);
    } else {
      Navigator.pushNamedAndRemoveUntil(
        context, AppRoutes.artifacts, (route) => false);
    }
  }

  // ── Submit (sign up or login) ──────────────────────────────────────────────
  Future<void> _submit() async {
    final email    = _emailController.text.trim();
    final password = _passwordController.text;
    final name     = _nameController.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() => _errorMessage = 'Please fill in all fields.');
      return;
    }
    if (_isSignUp && name.isEmpty) {
      setState(() => _errorMessage = 'Please enter your name.');
      return;
    }

    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      final authService = ref.read(authServiceProvider);

      if (_isSignUp) {
        await authService.signUpWithEmail(
          name: name, email: email, password: password,
        );
      } else {
        await authService.loginWithEmail(
          email: email, password: password,
        );
      }

      if (!mounted) return;
      _navigateAfterLogin(isNewUser: _isSignUp);
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = _friendlyError(e.code));
    } catch (e) {
      setState(() => _errorMessage = 'Something went wrong. Try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Google Sign-In ─────────────────────────────────────────────────────────
  Future<void> _googleSignIn() async {
    setState(() { _isLoading = true; _errorMessage = null; });

    try {
      final authService = ref.read(authServiceProvider);
      final result = await authService.signInWithGoogle();

      if (result == null) {
        // User cancelled
        setState(() => _isLoading = false);
        return;
      }

      if (!mounted) return;
      _navigateAfterLogin(isNewUser: result.additionalUserInfo?.isNewUser ?? false);
    } on FirebaseAuthException catch (e) {
      setState(() => _errorMessage = _friendlyError(e.code));
    } catch (e) {
      setState(() => _errorMessage = 'Google sign-in failed. Try again.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  // ── Password reset ─────────────────────────────────────────────────────────
  Future<void> _forgotPassword() async {
    final email = _emailController.text.trim();
    if (email.isEmpty) {
      setState(() => _errorMessage = 'Enter your email first to reset password.');
      return;
    }
    try {
      await ref.read(authServiceProvider).sendPasswordReset(email);
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Password reset email sent!')),
      );
    } catch (_) {
      setState(() => _errorMessage = 'Could not send reset email.');
    }
  }

  // ── Human-readable Firebase error messages ─────────────────────────────────
  String _friendlyError(String code) {
    switch (code) {
      case 'email-already-in-use':  return 'An account with this email already exists.';
      case 'invalid-email':         return 'The email address is not valid.';
      case 'weak-password':         return 'Password must be at least 6 characters.';
      case 'user-not-found':        return 'No account found with this email.';
      case 'wrong-password':        return 'Incorrect password. Try again.';
      case 'too-many-requests':     return 'Too many attempts. Please wait and try again.';
      case 'network-request-failed':return 'No internet connection.';
      default:                      return 'Authentication failed ($code).';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(24, 52, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header — no step tag needed (career is chosen before login)
                Text(
                  _isSignUp ? 'Create your\naccount ✦' : 'Welcome\nback ✦',
                  style: AppTextStyles.displayMedium,
                ),
                const SizedBox(height: 6),
                Text(
                  'Join 10,000+ students building their future',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 20),

                // ── Selected career path card (login tab only) ────────────
                if (_selectedCareerId != null && !_isSignUp) ...[
                  Container(
                    padding: const EdgeInsets.fromLTRB(14, 12, 10, 12),
                    decoration: BoxDecoration(
                      color: AppColors.blue.withOpacity(0.07),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                          color: AppColors.blue.withOpacity(0.22), width: 1.5),
                    ),
                    child: Row(
                      children: [
                        // Emoji bubble
                        Container(
                          width: 42,
                          height: 42,
                          decoration: BoxDecoration(
                            color: AppColors.blue.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Center(
                            child: Text(
                              _selectedCareerEmoji ?? '🎯',
                              style: const TextStyle(fontSize: 20),
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        // Path info
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'YOUR SAVED PATH',
                                style: AppTextStyles.label.copyWith(
                                  fontSize: 9,
                                  letterSpacing: 1.4,
                                  color: AppColors.blue,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Text(
                                _selectedCareerTitle ?? '',
                                style: AppTextStyles.headingSmall,
                              ),
                            ],
                          ),
                        ),
                        // Change path button
                        TextButton(
                          onPressed: _clearCareerPath,
                          style: TextButton.styleFrom(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 6),
                            minimumSize: Size.zero,
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: const Text(
                            'Change\nPath',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.blue,
                              height: 1.3,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 20),
                ] else if (_selectedCareerId == null || _isSignUp)
                  const SizedBox(height: 8),

                // ── Error banner ───────────────────────────────────────────
                if (_errorMessage != null) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFEE2E2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: const Color(0xFFFCA5A5)),
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.error_outline_rounded,
                            color: Color(0xFFDC2626), size: 18),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            _errorMessage!,
                            style: const TextStyle(
                              fontSize: 13,
                              color: Color(0xFFDC2626),
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],

                // ── Form card ─────────────────────────────────────────────
                GlassCard(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    children: [
                      _TabToggle(
                        isSignUp: _isSignUp,
                        onToggle: (v) => setState(() {
                          _isSignUp = v;
                          _errorMessage = null;
                        }),
                      ),
                      const SizedBox(height: 20),
                      if (_isSignUp) ...[
                        _Field(
                          controller: _nameController,
                          label: 'Full Name',
                          hint: 'Your name',
                        ),
                        const SizedBox(height: 14),
                      ],
                      _Field(
                        controller: _emailController,
                        label: 'Email Address',
                        hint: 'you@email.com',
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 14),
                      _Field(
                        controller: _passwordController,
                        label: 'Password',
                        hint: _isSignUp
                            ? 'Create a strong password (6+ chars)'
                            : 'Your password',
                        obscureText: true,
                      ),
                      if (!_isSignUp) ...[
                        const SizedBox(height: 6),
                        Align(
                          alignment: Alignment.centerRight,
                          child: TextButton(
                            onPressed: _forgotPassword,
                            child: const Text('Forgot password?',
                                style: TextStyle(
                                    fontSize: 12,
                                    color: AppColors.blue,
                                    fontWeight: FontWeight.w600)),
                          ),
                        ),
                      ],
                      const SizedBox(height: 8),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submit,
                          child: _isLoading
                              ? const SizedBox(
                                  height: 20, width: 20,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2,
                                    color: Colors.white,
                                  ),
                                )
                              : Text(_isSignUp
                                  ? 'Create Account →'
                                  : 'Login →'),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 16),

                // ── Divider ───────────────────────────────────────────────
                Row(
                  children: [
                    const Expanded(
                      child: Divider(color: Color(0x60FFFFFF), thickness: 1),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text('or continue with',
                          style: AppTextStyles.bodySmall),
                    ),
                    const Expanded(
                      child: Divider(color: Color(0x60FFFFFF), thickness: 1),
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // ── Google sign-in (full-width) ───────────────────────────
                _SocialButton(
                  label: 'Continue with Google',
                  emoji: '🇬',
                  onTap: _isLoading ? null : _googleSignIn,
                  fullWidth: true,
                ),

                const SizedBox(height: 20),

                Center(
                  child: Text.rich(
                    TextSpan(
                      text: 'By signing up you agree to our ',
                      style: AppTextStyles.bodySmall,
                      children: [
                        TextSpan(
                          text: 'Terms',
                          style: const TextStyle(
                              color: AppColors.blue,
                              fontWeight: FontWeight.w600),
                        ),
                        const TextSpan(text: ' & '),
                        TextSpan(
                          text: 'Privacy',
                          style: const TextStyle(
                              color: AppColors.blue,
                              fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ─── Sub-widgets (unchanged from original) ────────────────────────────────────

class _TabToggle extends StatelessWidget {
  final bool isSignUp;
  final ValueChanged<bool> onToggle;
  const _TabToggle({required this.isSignUp, required this.onToggle});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0x66FFFFFF),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xB3FFFFFF)),
      ),
      child: Row(
        children: [
          _Tab(
              label: 'Sign Up',
              active: isSignUp,
              onTap: () => onToggle(true)),
          _Tab(
              label: 'Login',
              active: !isSignUp,
              onTap: () => onToggle(false)),
        ],
      ),
    );
  }
}

class _Tab extends StatelessWidget {
  final String label;
  final bool active;
  final VoidCallback onTap;
  const _Tab({required this.label, required this.active, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 220),
          padding: const EdgeInsets.symmetric(vertical: 10),
          decoration: BoxDecoration(
            color: active ? Colors.white : Colors.transparent,
            borderRadius: BorderRadius.circular(9),
            boxShadow: active
                ? [
                    BoxShadow(
                      color: AppColors.blue.withOpacity(0.12),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    )
                  ]
                : null,
          ),
          child: Text(
            label,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: active ? AppColors.blue : AppColors.text3,
            ),
          ),
        ),
      ),
    );
  }
}

class _Field extends StatefulWidget {
  final TextEditingController controller;
  final String label;
  final String hint;
  final bool obscureText;
  final TextInputType? keyboardType;

  const _Field({
    required this.controller,
    required this.label,
    required this.hint,
    this.obscureText = false,
    this.keyboardType,
  });

  @override
  State<_Field> createState() => _FieldState();
}

class _FieldState extends State<_Field> {
  bool _visible = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.label.toUpperCase(),
            style: AppTextStyles.label.copyWith(fontSize: 11)),
        const SizedBox(height: 7),
        TextField(
          controller: widget.controller,
          obscureText: widget.obscureText && !_visible,
          keyboardType: widget.keyboardType,
          decoration: InputDecoration(
            hintText: widget.hint,
            suffixIcon: widget.obscureText
                ? IconButton(
                    icon: Icon(
                      _visible
                          ? Icons.visibility_off_rounded
                          : Icons.visibility_rounded,
                      size: 18,
                      color: AppColors.text3,
                    ),
                    onPressed: () => setState(() => _visible = !_visible),
                  )
                : null,
          ),
        ),
      ],
    );
  }
}

class _SocialButton extends StatelessWidget {
  final String label;
  final String emoji;
  final VoidCallback? onTap;
  final bool fullWidth;

  const _SocialButton({
    required this.label,
    required this.emoji,
    required this.onTap,
    this.fullWidth = false,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: fullWidth ? double.infinity : null,
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.glassWhite,
          border: Border.all(color: AppColors.glassBorder, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 16)),
            const SizedBox(width: 8),
            Text(label,
                style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.text2)),
          ],
        ),
      ),
    );
  }
}
