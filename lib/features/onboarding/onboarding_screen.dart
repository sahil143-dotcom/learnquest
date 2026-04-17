import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/routes.dart';
import '../../shared/widgets/glass_card.dart';

// ─── OnboardingScreen ─────────────────────────────────────────────────────────
// 3-page onboarding with PageView, animated page indicators, and per-page
// staggered entrance animations. Shown only on first launch.

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final _pageController = PageController();
  int _currentPage = 0;

  late AnimationController _animController;
  late List<Animation<double>> _fadeAnims;

  static const _pages = [
    _PageData(
      emoji: '🚀',
      label: 'WELCOME',
      title: 'Your Career,\nYour Journey',
      subtitle:
          'Stop guessing. Get a personalised roadmap built for the career you actually want.',
      gradientColors: [Color(0xFFA8D5BA), Color(0xFFB8E0D2), Color(0xFFC5DCE8)],
      pill1: 'Clarity',
      pill2: 'Direction',
      pill3: 'Confidence',
    ),
    _PageData(
      emoji: '🎯',
      label: 'DISCOVER',
      title: 'Find Your\nPerfect Path',
      subtitle:
          'AI, Web Dev, Cloud, Cybersecurity — explore every career with honest, beginner-friendly breakdowns.',
      gradientColors: [Color(0xFFBBD4F5), Color(0xFFC8DCF0), Color(0xFFD0E8D8)],
      pill1: 'AI & ML',
      pill2: 'Web Dev',
      pill3: 'Cloud',
    ),
    _PageData(
      emoji: '🏆',
      label: 'ACHIEVE',
      title: 'Learn, Grow,\nGet Placed',
      subtitle:
          'Step-by-step milestones from beginner to placement-ready. One focused day at a time.',
      gradientColors: [Color(0xFFD0C8F5), Color(0xFFCFDCEE), Color(0xFFB8E0D2)],
      pill1: 'Milestones',
      pill2: 'Projects',
      pill3: 'Placement',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _buildAnims();
    _animController.forward();
  }

  void _buildAnims() {
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _fadeAnims = List.generate(5, (i) {
      final start = i * 0.13;
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _animController,
          curve: Interval(start, (start + 0.45).clamp(0, 1),
              curve: Curves.easeOut),
        ),
      );
    });
  }

  void _restartAnims() {
    _animController.reset();
    _animController.forward();
  }

  @override
  void dispose() {
    _pageController.dispose();
    _animController.dispose();
    super.dispose();
  }

  Future<void> _proceed() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboarding_done', true);
    if (!mounted) return;
    Navigator.pushReplacementNamed(context, AppRoutes.domainSelect);
  }

  void _nextPage() {
    if (_currentPage < _pages.length - 1) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 450),
        curve: Curves.easeInOutCubic,
      );
    } else {
      _proceed();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        colors: _pages[_currentPage].gradientColors,
        child: SafeArea(
          child: Column(
            children: [
              // ── Top bar: skip ──────────────────────────────────────────────
              SizedBox(
                height: 48,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: _currentPage < _pages.length - 1
                        ? TextButton(
                            onPressed: _proceed,
                            child: Text(
                              'Skip',
                              style: TextStyle(
                                  color: AppColors.text3, fontSize: 13),
                            ),
                          )
                        : const SizedBox.shrink(),
                  ),
                ),
              ),

              // ── Swipeable pages ────────────────────────────────────────────
              Expanded(
                child: PageView.builder(
                  controller: _pageController,
                  onPageChanged: (i) {
                    setState(() => _currentPage = i);
                    _restartAnims();
                  },
                  itemCount: _pages.length,
                  itemBuilder: (_, index) => _PageContent(
                    data: _pages[index],
                    fadeAnims: _fadeAnims,
                  ),
                ),
              ),

              // ── Bottom: dots + CTA ─────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(32, 8, 32, 36),
                child: Column(
                  children: [
                    // Page indicator dots
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_pages.length, (i) {
                        final isActive = _currentPage == i;
                        return AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          margin: const EdgeInsets.symmetric(horizontal: 4),
                          width: isActive ? 28 : 8,
                          height: 8,
                          decoration: BoxDecoration(
                            color: isActive
                                ? AppColors.blue
                                : AppColors.blue.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(4),
                          ),
                        );
                      }),
                    ),
                    const SizedBox(height: 28),
                    // CTA button
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: _nextPage,
                        child: Text(
                          _currentPage < _pages.length - 1
                              ? 'Next  →'
                              : 'Get Started  →',
                        ),
                      ),
                    ),
                    if (_currentPage == 0) ...[
                      const SizedBox(height: 14),
                      TextButton(
                        onPressed: _proceed,
                        child: Text(
                          'Skip for now',
                          style: TextStyle(
                              color: AppColors.text3, fontSize: 13),
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Page data ────────────────────────────────────────────────────────────────

class _PageData {
  final String emoji;
  final String label;
  final String title;
  final String subtitle;
  final List<Color> gradientColors;
  final String pill1;
  final String pill2;
  final String pill3;

  const _PageData({
    required this.emoji,
    required this.label,
    required this.title,
    required this.subtitle,
    required this.gradientColors,
    required this.pill1,
    required this.pill2,
    required this.pill3,
  });
}

// ─── Page content (animates in on each page change) ───────────────────────────

class _PageContent extends StatelessWidget {
  final _PageData data;
  final List<Animation<double>> fadeAnims;

  const _PageContent({required this.data, required this.fadeAnims});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(flex: 2),

          // Label
          _Fade(
            anim: fadeAnims[0],
            child: Text(
              data.label,
              style: AppTextStyles.label.copyWith(
                color: AppColors.green,
                letterSpacing: 3,
                fontSize: 11,
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Hero icon
          _Fade(
            anim: fadeAnims[1],
            child: Container(
              width: 108,
              height: 108,
              decoration: BoxDecoration(
                color: AppColors.glassWhite,
                border: Border.all(color: AppColors.glassBorder, width: 2),
                borderRadius: BorderRadius.circular(34),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.blue.withOpacity(0.14),
                    blurRadius: 32,
                    offset: const Offset(0, 10),
                  ),
                ],
              ),
              child: Center(
                child: Text(data.emoji,
                    style: const TextStyle(fontSize: 50)),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // Title
          _Fade(
            anim: fadeAnims[2],
            child: Text(
              data.title,
              textAlign: TextAlign.center,
              style: AppTextStyles.displayLarge,
            ),
          ),

          const SizedBox(height: 16),

          // Subtitle
          _Fade(
            anim: fadeAnims[3],
            child: Text(
              data.subtitle,
              textAlign: TextAlign.center,
              style: AppTextStyles.bodyLarge,
            ),
          ),

          const SizedBox(height: 28),

          // Three keyword pills
          _Fade(
            anim: fadeAnims[4],
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _Pill(data.pill1),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Text('·',
                      style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                ),
                _Pill(data.pill2),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Text('·',
                      style: TextStyle(
                          color: AppColors.green,
                          fontWeight: FontWeight.w700,
                          fontSize: 16)),
                ),
                _Pill(data.pill3),
              ],
            ),
          ),

          const Spacer(flex: 3),
        ],
      ),
    );
  }
}

// ─── Helpers ──────────────────────────────────────────────────────────────────

class _Pill extends StatelessWidget {
  final String label;
  const _Pill(this.label);

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
      borderRadius: 50,
      child: Text(
        label,
        style: AppTextStyles.headingSmall.copyWith(color: AppColors.blue),
      ),
    );
  }
}

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
          begin: const Offset(0, 0.18),
          end: Offset.zero,
        ).animate(anim),
        child: child,
      ),
    );
  }
}
