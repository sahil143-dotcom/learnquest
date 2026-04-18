// ─── dashboard_screen.dart ────────────────────────────────────────────────────
// Daily Dashboard — native Flutter, matches the app's glass/gradient UI.
// Hero feature: animated water-fill container showing XP level progress.

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../core/theme/app_theme.dart';
import '../core/constants/routes.dart';
import '../providers/user_provider.dart';
import '../shared/widgets/glass_card.dart';
import '../features/roadmap/data/career_data.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  String _greeting() {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good morning';
    if (h < 17) return 'Good afternoon';
    if (h < 21) return 'Good evening';
    return 'Good night';
  }

  String _date() {
    const months = ['Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'];
    const days   = ['Mon','Tue','Wed','Thu','Fri','Sat','Sun'];
    final now    = DateTime.now();
    return '${days[now.weekday - 1]}, ${months[now.month - 1]} ${now.day}';
  }

  String _tip(int streak) {
    if (streak == 0) return 'Start your first learning session today! 🚀';
    if (streak < 3)  return 'Great start! Keep showing up every day 💪';
    if (streak < 7)  return 'Building a habit! Don\'t break the chain 🔥';
    if (streak < 14) return 'One week strong! Consistency is your superpower ⚡';
    if (streak < 30) return 'Top 10% of learners — keep going 🏆';
    return 'A month-long streak! You\'re unstoppable 🌟';
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user     = ref.watch(userProgressProvider);
    final xpToNext = user.xpToNextLevel;
    final xpInLvl  = user.xp % xpToNext;
    final fillPct  = (xpInLvl / xpToNext).clamp(0.0, 1.0);

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 20, 20, 100),
            children: [

              // ── Greeting row ───────────────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('${_greeting()},',
                          style: AppTextStyles.bodyMedium
                              .copyWith(color: AppColors.text2)),
                      Text('${user.name}! 👋',
                          style: AppTextStyles.headingLarge),
                    ],
                  ),
                  GlassCard(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 8),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.calendar_today_rounded,
                            size: 11, color: AppColors.text3),
                        const SizedBox(width: 5),
                        Text(_date(),
                            style: AppTextStyles.label
                                .copyWith(fontSize: 10)),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── ★ Water Animation Stats Card ───────────────────────────
              _WaterStatsCard(
                level:      user.level,
                xpInLevel:  xpInLvl,
                xpToNext:   xpToNext,
                streakDays: user.streakDays,
                totalXp:    user.xp,
                fillPct:    fillPct,
              ),
              const SizedBox(height: 20),

              // ── Your Path ──────────────────────────────────────────────
              _RoadmapCard(
                selectedCareers: user.selectedCareers,
                onTapCareer: (careerId) => Navigator.pushNamed(
                  context, AppRoutes.roadmap, arguments: careerId),
                onAddCareer: () => Navigator.pushNamed(
                  context, AppRoutes.domainSelect),
                onTapEmpty: () => Navigator.pushNamed(
                  context, AppRoutes.domainSelect),
              ),
              const SizedBox(height: 14),

              // ── Weekly Challenge ───────────────────────────────────────
              const _WeeklyChallengeCard(),
              const SizedBox(height: 14),

              // ── Daily Quests ───────────────────────────────────────────
              const _DailyQuestsCard(),
              const SizedBox(height: 16),

              // ── Daily tip ──────────────────────────────────────────────
              _TipCard(tip: _tip(user.streakDays)),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// ★ WATER ANIMATION STATS CARD
// ═══════════════════════════════════════════════════════════════════════════════
// A tall rounded card with animated water waves that fill up based on the
// user's XP progress to the next level. Two staggered sine waves create a
// realistic liquid motion effect. Stats (Level, XP, Streak) float on top.

class _WaterStatsCard extends StatefulWidget {
  final int    level;
  final int    xpInLevel;
  final int    xpToNext;
  final int    streakDays;
  final int    totalXp;
  final double fillPct;       // 0.0 – 1.0

  const _WaterStatsCard({
    required this.level,
    required this.xpInLevel,
    required this.xpToNext,
    required this.streakDays,
    required this.totalXp,
    required this.fillPct,
  });

  @override
  State<_WaterStatsCard> createState() => _WaterStatsCardState();
}

class _WaterStatsCardState extends State<_WaterStatsCard>
    with TickerProviderStateMixin {

  // Wave motion — repeating, drives the sine oscillation
  late final AnimationController _waveCtrl;

  // Fill level — one-shot, animates water rising from 0 to fillPct
  late final AnimationController _fillCtrl;
  late final Animation<double>   _fillAnim;

  @override
  void initState() {
    super.initState();

    _waveCtrl = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat();

    _fillCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1600),
    );

    // Clamp: always show at least a small wave (0.08), never overflow (0.90)
    final targetFill = widget.fillPct.clamp(0.08, 0.90);
    _fillAnim = Tween<double>(begin: 0.04, end: targetFill).animate(
      CurvedAnimation(parent: _fillCtrl, curve: Curves.easeOutCubic),
    );

    // Small delay before fill rises — feels more intentional
    Future.delayed(const Duration(milliseconds: 400), () {
      if (mounted) _fillCtrl.forward();
    });
  }

  @override
  void dispose() {
    _waveCtrl.dispose();
    _fillCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge([_waveCtrl, _fillAnim]),
      builder: (context, _) {
        return Container(
          height: 220,
          decoration: BoxDecoration(
            // Card background — dark ocean base that shows above the water line
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [Color(0xFF1E3A5C), Color(0xFF1A4A3A)],
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF4A90B8).withOpacity(0.30),
                blurRadius: 24,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Stack(
              children: [
                // ── Water waves (CustomPainter) ───────────────────────
                Positioned.fill(
                  child: CustomPaint(
                    painter: _WavePainter(
                      phase:     _waveCtrl.value,
                      fillLevel: _fillAnim.value,
                    ),
                  ),
                ),

                // ── Subtle top shimmer ────────────────────────────────
                Positioned(
                  top: 0, left: 0, right: 0,
                  child: Container(
                    height: 60,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withOpacity(0.06),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ),

                // ── Stats overlay ─────────────────────────────────────
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 24, vertical: 18),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [

                      // Top row: streak pill + XP display
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Streak pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.20)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('🔥',
                                    style: TextStyle(fontSize: 12)),
                                const SizedBox(width: 5),
                                Text(
                                  '${widget.streakDays}-day streak',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // Total XP pill
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 10, vertical: 5),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.15),
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(
                                  color: Colors.white.withOpacity(0.20)),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Text('✨',
                                    style: TextStyle(fontSize: 12)),
                                const SizedBox(width: 5),
                                Text(
                                  '${widget.totalXp} XP',
                                  style: GoogleFonts.inter(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),

                      const Spacer(),

                      // Level (big) + XP progress
                      Text(
                        'Level ${widget.level}',
                        style: GoogleFonts.poppins(
                          fontSize: 44,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          height: 1.0,
                          letterSpacing: -1,
                        ),
                      ),
                      const SizedBox(height: 6),

                      // XP progress bar (thin, white)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(50),
                        child: LinearProgressIndicator(
                          value: _fillAnim.value,
                          minHeight: 5,
                          backgroundColor: Colors.white24,
                          valueColor:
                              const AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                      const SizedBox(height: 6),

                      // XP label
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${widget.xpInLevel} / ${widget.xpToNext} XP',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.80),
                            ),
                          ),
                          Text(
                            '${((1 - _fillAnim.value) * widget.xpToNext).round()} XP to Lv ${widget.level + 1}',
                            style: GoogleFonts.inter(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                              color: Colors.white.withOpacity(0.60),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// ─── Wave CustomPainter ───────────────────────────────────────────────────────
// Draws two overlapping sine waves and fills below them with gradient water.
// Wave 1 (front) — blue, higher amplitude
// Wave 2 (back)  — teal/green, slightly offset phase, lower amplitude

class _WavePainter extends CustomPainter {
  final double phase;      // 0.0 – 1.0, drives wave horizontal motion
  final double fillLevel;  // 0.0 – 1.0, how high the water rises

  const _WavePainter({required this.phase, required this.fillLevel});

  @override
  void paint(Canvas canvas, Size size) {
    final waterY      = size.height * (1.0 - fillLevel);
    const amplitude1  = 10.0;   // px height of front wave
    const amplitude2  = 7.0;    // px height of back wave
    const frequency   = 1.6;    // wave cycles across full width

    // ── Back wave (teal) — slightly higher than front ─────────────────────
    final path2 = Path();
    path2.moveTo(0, waterY - 4);
    for (double x = 0; x <= size.width; x++) {
      final y = (waterY - 4) +
          sin((x / size.width * frequency * 2 * pi) +
                  (phase * 2 * pi) +
                  pi * 0.65) *
              amplitude2;
      path2.lineTo(x, y);
    }
    path2.lineTo(size.width, size.height);
    path2.lineTo(0, size.height);
    path2.close();

    canvas.drawPath(
      path2,
      Paint()
        ..color = const Color(0xFF3DB48C).withOpacity(0.55)
        ..style = PaintingStyle.fill,
    );

    // ── Front wave (blue) ─────────────────────────────────────────────────
    final path1 = Path();
    path1.moveTo(0, waterY);
    for (double x = 0; x <= size.width; x++) {
      final y = waterY +
          sin((x / size.width * frequency * 2 * pi) +
                  (phase * 2 * pi)) *
              amplitude1;
      path1.lineTo(x, y);
    }
    path1.lineTo(size.width, size.height);
    path1.lineTo(0, size.height);
    path1.close();

    // Front wave uses a vertical gradient shader
    final gradientRect = Rect.fromLTWH(
        0, waterY - amplitude1, size.width, size.height);
    final gradient = const LinearGradient(
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
      colors: [Color(0xFF4A90B8), Color(0xFF2E7D6E)],
    ).createShader(gradientRect);

    canvas.drawPath(
      path1,
      Paint()
        ..shader = gradient
        ..style = PaintingStyle.fill,
    );
  }

  @override
  bool shouldRepaint(_WavePainter old) =>
      old.phase != phase || old.fillLevel != fillLevel;
}

// ═══════════════════════════════════════════════════════════════════════════════
// SUPPORTING WIDGETS
// ═══════════════════════════════════════════════════════════════════════════════

// ─── Daily Quests Card ────────────────────────────────────────────────────────
class _DailyQuestsCard extends StatelessWidget {
  const _DailyQuestsCard();

  @override
  Widget build(BuildContext context) {
    final quests = [
      _Quest('Solve 5 DSA problems', true),
      _Quest('Read 1 concept article', true),
      _Quest('Complete today\'s quiz', false),
    ];
    final done = quests.where((q) => q.done).length;

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Daily Quests',
                style: GoogleFonts.inter(
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF1A1A2E),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '$done/${quests.length} done',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF27AE60),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          ...quests.map((q) => _QuestRow(quest: q)),
        ],
      ),
    );
  }
}

class _Quest {
  final String title;
  final bool done;
  const _Quest(this.title, this.done);
}

class _QuestRow extends StatelessWidget {
  final _Quest quest;
  const _QuestRow({required this.quest});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Row(
        children: [
          Container(
            width: 22,
            height: 22,
            decoration: BoxDecoration(
              color: quest.done ? const Color(0xFF27AE60) : Colors.transparent,
              border: Border.all(
                color: quest.done
                    ? const Color(0xFF27AE60)
                    : const Color(0xFFDDE1E7),
                width: 2,
              ),
              borderRadius: BorderRadius.circular(6),
            ),
            child: quest.done
                ? const Icon(Icons.check_rounded, size: 14, color: Colors.white)
                : null,
          ),
          const SizedBox(width: 12),
          Text(
            quest.title,
            style: GoogleFonts.inter(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: quest.done
                  ? const Color(0xFFADB5BD)
                  : const Color(0xFF1A1A2E),
              decoration:
                  quest.done ? TextDecoration.lineThrough : TextDecoration.none,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Your Path / Roadmap Card ─────────────────────────────────────────────────
class _RoadmapCard extends StatelessWidget {
  final List<String> selectedCareers;
  final void Function(String careerId) onTapCareer;
  final VoidCallback onAddCareer;
  final VoidCallback onTapEmpty;

  const _RoadmapCard({
    required this.selectedCareers,
    required this.onTapCareer,
    required this.onAddCareer,
    required this.onTapEmpty,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFEEF4FF), Color(0xFFE8F5FF)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFBDD7FF), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ── Header ─────────────────────────────────────────────────────────
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'YOUR PATHS',
                  style: GoogleFonts.inter(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFF4A90B8),
                    letterSpacing: 1.4,
                  ),
                ),
                GestureDetector(
                  onTap: onAddCareer,
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 5),
                    decoration: BoxDecoration(
                      color: const Color(0xFF4A90B8),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.add_rounded,
                            size: 13, color: Colors.white),
                        const SizedBox(width: 4),
                        Text(
                          'Add Domain',
                          style: GoogleFonts.inter(
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Career rows or empty state ──────────────────────────────────────
          if (selectedCareers.isEmpty)
            GestureDetector(
              onTap: onTapEmpty,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    'Tap to choose your career path →',
                    style: GoogleFonts.inter(
                      fontSize: 13,
                      color: const Color(0xFF4A90B8),
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.fromLTRB(12, 0, 12, 12),
              child: Column(
                children: selectedCareers.map((id) {
                  final career = findCareerById(id);
                  return GestureDetector(
                    onTap: () => onTapCareer(id),
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 8),
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.8),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Row(
                        children: [
                          Text(career.emoji,
                              style: const TextStyle(fontSize: 20)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  career.title,
                                  style: GoogleFonts.inter(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w700,
                                    color: const Color(0xFF1A1A2E),
                                  ),
                                ),
                                Text(
                                  career.subtitle,
                                  style: GoogleFonts.inter(
                                    fontSize: 11,
                                    color: const Color(0xFF6B7280),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(Icons.arrow_forward_ios_rounded,
                              size: 14, color: Color(0xFF4A90B8)),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}

// ─── Weekly Challenge Card ────────────────────────────────────────────────────
class _WeeklyChallengeCard extends StatelessWidget {
  const _WeeklyChallengeCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFFF0F0), Color(0xFFFFF5F0)],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFFFCCBB), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            width: 56,
            height: 56,
            decoration: BoxDecoration(
              color: const Color(0xFFE8593C).withOpacity(0.12),
              borderRadius: BorderRadius.circular(16),
            ),
            child: const Center(
              child: Text('🏰', style: TextStyle(fontSize: 28)),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'WEEKLY CHALLENGE',
                      style: GoogleFonts.inter(
                        fontSize: 9,
                        fontWeight: FontWeight.w700,
                        color: const Color(0xFFE8593C),
                        letterSpacing: 1.3,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8593C),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        'LIVE',
                        style: GoogleFonts.inter(
                          fontSize: 8,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                          letterSpacing: 0.5,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 3),
                Text(
                  'Dungeon Raid',
                  style: GoogleFonts.inter(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
                Text(
                  'Arrays Boss · 2h 14m left',
                  style: GoogleFonts.inter(
                    fontSize: 12,
                    color: const Color(0xFF6B7280),
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8593C).withOpacity(0.10),
              borderRadius: BorderRadius.circular(14),
              border: Border.all(
                  color: const Color(0xFFE8593C).withOpacity(0.25), width: 1.2),
            ),
            child: Column(
              children: [
                Text(
                  'REWARD',
                  style: GoogleFonts.inter(
                    fontSize: 8,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFE8593C),
                    letterSpacing: 0.8,
                  ),
                ),
                Text(
                  '+500',
                  style: GoogleFonts.inter(
                    fontSize: 20,
                    fontWeight: FontWeight.w900,
                    color: const Color(0xFFE8593C),
                    height: 1.1,
                  ),
                ),
                Text(
                  'XP',
                  style: GoogleFonts.inter(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: const Color(0xFFE8593C),
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

class _TipCard extends StatelessWidget {
  final String tip;
  const _TipCard({required this.tip});

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            width: 40, height: 40,
            decoration: BoxDecoration(
              color: AppColors.green.withOpacity(0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Center(
                child: Text('💡', style: TextStyle(fontSize: 20))),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'DAILY TIP',
                  style: AppTextStyles.label.copyWith(
                      color: AppColors.green,
                      fontSize: 9,
                      letterSpacing: 1.2),
                ),
                const SizedBox(height: 4),
                Text(tip,
                    style: AppTextStyles.bodyMedium
                        .copyWith(fontWeight: FontWeight.w500)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
