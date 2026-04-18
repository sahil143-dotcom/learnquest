// ─── branch_select_screen.dart ────────────────────────────────────────────────
// Shown after user taps "Engineering" on the Domain Select screen.
// Lists all engineering branches; only CSE is live for MVP.
// Tapping CSE → SpecializationScreen. Others show a "Coming Soon" snackbar.

import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/routes.dart';
import '../../../shared/widgets/glass_card.dart';

class BranchSelectScreen extends StatefulWidget {
  const BranchSelectScreen({super.key});

  @override
  State<BranchSelectScreen> createState() => _BranchSelectScreenState();
}

class _BranchSelectScreenState extends State<BranchSelectScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _anims;

  // ── All engineering branches ──────────────────────────────────────────────
  static const _branches = [
    _BranchItem(
      emoji: '💻',
      shortName: 'CSE',
      fullName: 'Computer Science & Engineering',
      subtitle: 'Software, AI, Web & App development',
      isLive: true,
    ),
    _BranchItem(
      emoji: '📡',
      shortName: 'ECE',
      fullName: 'Electronics & Communication',
      subtitle: 'VLSI, embedded systems & signal processing',
      isLive: false,
    ),
    _BranchItem(
      emoji: '⚡',
      shortName: 'EEE',
      fullName: 'Electrical & Electronics',
      subtitle: 'Power systems, drives & automation',
      isLive: false,
    ),
    _BranchItem(
      emoji: '⚙️',
      shortName: 'Mechanical',
      fullName: 'Mechanical Engineering',
      subtitle: 'Design, manufacturing & robotics',
      isLive: false,
    ),
    _BranchItem(
      emoji: '🧬',
      shortName: 'Biotech',
      fullName: 'Biotechnology',
      subtitle: 'Life sciences & bioengineering',
      isLive: false,
    ),
    _BranchItem(
      emoji: '🏗️',
      shortName: 'Civil',
      fullName: 'Civil Engineering',
      subtitle: 'Infrastructure, structures & construction',
      isLive: false,
    ),
    _BranchItem(
      emoji: '🖥️',
      shortName: 'IT',
      fullName: 'Information Technology',
      subtitle: 'Networking, databases & cloud systems',
      isLive: false,
    ),
    _BranchItem(
      emoji: '🤖',
      shortName: 'AI & DS',
      fullName: 'Artificial Intelligence & Data Science',
      subtitle: 'Machine learning, NLP & analytics',
      isLive: false,
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _anims = List.generate(_branches.length, (i) {
      final start = (i * 0.10).clamp(0.0, 0.6);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, (start + 0.4).clamp(0.0, 1.0),
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

  void _onBranchTap(_BranchItem branch) {
    if (!branch.isLive) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              const Text('🚀', style: TextStyle(fontSize: 16)),
              const SizedBox(width: 10),
              Text(
                '${branch.shortName} roadmap is coming soon!',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ],
          ),
          backgroundColor: AppColors.purple,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }
    // CSE is live — navigate with branch name as argument
    Navigator.pushReplacementNamed(
      context,
      AppRoutes.specialization,
      arguments: branch.shortName,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 20, 24, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Back button ───────────────────────────────────────────
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: AppColors.glassWhite,
                      border:
                          Border.all(color: AppColors.glassBorder, width: 1.5),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.arrow_back_ios_new_rounded,
                            size: 14, color: AppColors.text2),
                        SizedBox(width: 6),
                        Text('Back',
                            style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.text2)),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                // ── Breadcrumb tag ────────────────────────────────────────
                const ScreenTag('Engineering 💻'),
                const SizedBox(height: 12),

                // ── Heading ───────────────────────────────────────────────
                Text('Choose Your\nBranch 🎓', style: AppTextStyles.displayMedium),
                const SizedBox(height: 6),
                Text(
                  'Pick your engineering stream to explore career paths.',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 20),

                // ── Branch list ───────────────────────────────────────────
                Expanded(
                  child: ListView.separated(
                    itemCount: _branches.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 10),
                    itemBuilder: (_, i) {
                      final branch = _branches[i];
                      return AnimatedBuilder(
                        animation: _anims[i],
                        builder: (_, child) => Opacity(
                          opacity: _anims[i].value,
                          child: Transform.translate(
                            offset: Offset(28 * (1 - _anims[i].value), 0),
                            child: child,
                          ),
                        ),
                        child: _BranchCard(
                          branch: branch,
                          onTap: () => _onBranchTap(branch),
                        ),
                      );
                    },
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

// ─── Data model ───────────────────────────────────────────────────────────────

class _BranchItem {
  final String emoji;
  final String shortName;
  final String fullName;
  final String subtitle;
  final bool isLive;

  const _BranchItem({
    required this.emoji,
    required this.shortName,
    required this.fullName,
    required this.subtitle,
    required this.isLive,
  });
}

// ─── Branch card ──────────────────────────────────────────────────────────────

class _BranchCard extends StatelessWidget {
  final _BranchItem branch;
  final VoidCallback onTap;

  const _BranchCard({required this.branch, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: branch.isLive ? 1.0 : 0.55,
      child: GlassCard(
        onTap: onTap,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            // ── Branch icon ──────────────────────────────────────────────
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: branch.isLive
                    ? AppColors.blue.withOpacity(0.12)
                    : Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(14),
              ),
              child: Center(
                child: Text(branch.emoji,
                    style: const TextStyle(fontSize: 22)),
              ),
            ),
            const SizedBox(width: 14),

            // ── Name + subtitle ──────────────────────────────────────────
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        branch.shortName,
                        style: AppTextStyles.headingSmall,
                      ),
                      const SizedBox(width: 6),
                      Text(
                        '· ${branch.fullName}',
                        style: AppTextStyles.bodySmall.copyWith(fontSize: 10),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(branch.subtitle,
                      style: AppTextStyles.bodySmall,
                      overflow: TextOverflow.ellipsis),
                ],
              ),
            ),
            const SizedBox(width: 10),

            // ── Badge / arrow ────────────────────────────────────────────
            if (branch.isLive)
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                    decoration: BoxDecoration(
                      color: AppColors.blue.withOpacity(0.12),
                      borderRadius: BorderRadius.circular(50),
                      border: Border.all(color: AppColors.blue.withOpacity(0.25)),
                    ),
                    child: Text(
                      '✦ Live',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: AppColors.blue,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Icon(Icons.arrow_forward_ios_rounded,
                      size: 13, color: AppColors.blue),
                ],
              )
            else
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.text3.withOpacity(0.08),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Text(
                  'Soon',
                  style: TextStyle(
                    fontSize: 10,
                    fontWeight: FontWeight.w700,
                    color: AppColors.text3,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
