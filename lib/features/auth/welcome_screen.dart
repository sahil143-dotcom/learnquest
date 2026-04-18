import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../core/theme/app_theme.dart';
import '../../core/constants/routes.dart';

class WelcomeScreen extends StatefulWidget {
  const WelcomeScreen({super.key});

  @override
  State<WelcomeScreen> createState() => _WelcomeScreenState();
}

class _WelcomeScreenState extends State<WelcomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _anims;

  String get _firstName {
    final full = FirebaseAuth.instance.currentUser?.displayName ?? 'there';
    return full.split(' ').first;
  }

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _anims = List.generate(5, (i) {
      final start = i * 0.12;
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

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _continue() {
    Navigator.pushNamedAndRemoveUntil(
      context,
      AppRoutes.artifacts,
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(28, 0, 28, 40),
          child: Column(
            children: [
              const Spacer(flex: 2),

              // ── Celebration icon ───────────────────────────────────────────
              _Fade(
                anim: _anims[0],
                child: Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(36),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF4CAF82).withOpacity(0.2),
                        blurRadius: 40,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: const Center(
                    child: Text('🎉', style: TextStyle(fontSize: 56)),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ── Headline ───────────────────────────────────────────────────
              _Fade(
                anim: _anims[1],
                child: RichText(
                  textAlign: TextAlign.center,
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: 'Welcome,\n',
                        style: GoogleFonts.inter(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF1A1A2E),
                          height: 1.2,
                        ),
                      ),
                      TextSpan(
                        text: '$_firstName! ',
                        style: GoogleFonts.inter(
                          fontSize: 36,
                          fontWeight: FontWeight.w800,
                          color: const Color(0xFF4CAF82),
                          height: 1.2,
                        ),
                      ),
                      const TextSpan(
                        text: '✦',
                        style: TextStyle(
                          fontSize: 28,
                          color: Color(0xFF1A1A2E),
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // ── Subtitle ───────────────────────────────────────────────────
              _Fade(
                anim: _anims[2],
                child: Text(
                  'Your account is ready.\nTime to build the career you actually want.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.inter(
                    fontSize: 15,
                    color: const Color(0xFF6B7280),
                    height: 1.6,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // ── Feature highlights ─────────────────────────────────────────
              _Fade(
                anim: _anims[3],
                child: Column(
                  children: [
                    _FeatureTile(
                      emoji: '🗺️',
                      title: 'Personalized Roadmap',
                      subtitle: 'Step-by-step career path just for you',
                    ),
                    const SizedBox(height: 12),
                    _FeatureTile(
                      emoji: '⚡',
                      title: 'Track Your Progress',
                      subtitle: 'XP, levels, and milestones as you grow',
                    ),
                    const SizedBox(height: 12),
                    _FeatureTile(
                      emoji: '🏆',
                      title: 'Placement Ready',
                      subtitle: 'Interview prep built right in',
                    ),
                  ],
                ),
              ),

              const Spacer(flex: 3),

              // ── CTA button ─────────────────────────────────────────────────
              _Fade(
                anim: _anims[4],
                child: SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: _continue,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF4CAF82),
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      "Let's Get Started  →",
                      style: GoogleFonts.inter(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Feature tile ─────────────────────────────────────────────────────────────

class _FeatureTile extends StatelessWidget {
  final String emoji;
  final String title;
  final String subtitle;

  const _FeatureTile({
    required this.emoji,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: const Color(0xFF4CAF82).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Center(
              child: Text(emoji, style: const TextStyle(fontSize: 20)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
        ],
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
