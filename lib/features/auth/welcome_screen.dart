import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../core/theme/app_theme.dart';
import '../../core/constants/routes.dart';
import '../../shared/widgets/glass_card.dart';

// ─── WelcomeScreen ────────────────────────────────────────────────────────────
// Shown once, right after a new user creates their account.
// Greets them by name and lets them continue to their path (or domain select).

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _anims;

  String? _selectedCareerId;
  String? _selectedCareerEmoji;
  String? _selectedCareerTitle;

  String get _firstName {
    final full = FirebaseAuth.instance.currentUser?.displayName ?? 'there';
    return full.split(' ').first;
  }

  @override
  void initState() {
    super.initState();
    _loadCareer();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    // 5 staggered fade+slide animations
    _anims = List.generate(5, (i) {
      final start = i * 0.13;
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, (start + 0.5).clamp(0, 1),
              curve: Curves.easeOut),
        ),
      );
    });

    _controller.forward();
  }

  Future<void> _loadCareer() async {
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _continue() {
    if (_selectedCareerId != null) {
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.roadmapLoading,
        arguments: _selectedCareerId,
      );
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.domainSelect);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
            child: Column(
              children: [
                const Spacer(flex: 2),

                // ── Celebration icon ─────────────────────────────────────────
                _Fade(
                  anim: _anims[0],
                  child: Container(
                    width: 110,
                    height: 110,
                    decoration: BoxDecoration(
                      color: AppColors.glassWhite,
                      border:
                          Border.all(color: AppColors.glassBorder, width: 2),
                      borderRadius: BorderRadius.circular(36),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.green.withOpacity(0.18),
                          blurRadius: 36,
                          offset: const Offset(0, 12),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🎉', style: TextStyle(fontSize: 52)),
                    ),
                  ),
                ),

                const SizedBox(height: 36),

                // ── Headline ─────────────────────────────────────────────────
                _Fade(
                  anim: _anims[1],
                  child: Text(
                    'Welcome,\n$_firstName! ✦',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.displayLarge,
                  ),
                ),

                const SizedBox(height: 14),

                // ── Subtitle ─────────────────────────────────────────────────
                _Fade(
                  anim: _anims[2],
                  child: Text(
                    'Your account is ready. Time to build\nthe career you actually want.',
                    textAlign: TextAlign.center,
                    style: AppTextStyles.bodyLarge,
                  ),
                ),

                const SizedBox(height: 32),

                // ── Selected path preview (if already chosen) ─────────────────
                if (_selectedCareerId != null)
                  _Fade(
                    anim: _anims[3],
                    child: GlassCard(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 18, vertical: 14),
                      child: Row(
                        children: [
                          Container(
                            width: 46,
                            height: 46,
                            decoration: BoxDecoration(
                              color: AppColors.green.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Center(
                              child: Text(
                                _selectedCareerEmoji ?? '🎯',
                                style: const TextStyle(fontSize: 22),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'YOUR CHOSEN PATH',
                                  style: AppTextStyles.label.copyWith(
                                    fontSize: 9,
                                    letterSpacing: 1.5,
                                    color: AppColors.green,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  _selectedCareerTitle ?? '',
                                  style: AppTextStyles.headingSmall,
                                ),
                              ],
                            ),
                          ),
                          Icon(Icons.check_circle_rounded,
                              color: AppColors.green, size: 22),
                        ],
                      ),
                    ),
                  ),

                const Spacer(flex: 3),

                // ── CTA button ────────────────────────────────────────────────
                _Fade(
                  anim: _anims[4],
                  child: SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: _continue,
                      child: Text(
                        _selectedCareerId != null
                            ? 'Go to My Roadmap  →'
                            : 'Choose My Path  →',
                      ),
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

// ─── Fade + slide helper ──────────────────────────────────────────────────────

class _Fade extends StatelessWidget {
  final Animation<double> anim;
  final Widget child;
  const _Fade({required this.anim, required this.child});

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: anim,
      child: SlideTransition(
        position: Tween<Offset>(
          begin: const Offset(0, 0.15),
          end: Offset.zero,
        ).animate(anim),
        child: child,
      ),
    );
  }
}
