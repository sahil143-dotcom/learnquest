import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/routes.dart';
import '../../../shared/widgets/glass_card.dart';
import '../data/career_data.dart';
import '../models/career_model.dart';

// ─── RoadmapLoadingScreen ─────────────────────────────────────────────────────

class RoadmapLoadingScreen extends StatefulWidget {
  const RoadmapLoadingScreen({super.key});

  @override
  State<RoadmapLoadingScreen> createState() => _RoadmapLoadingScreenState();
}

class _RoadmapLoadingScreenState extends State<RoadmapLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulse;

  @override
  void initState() {
    super.initState();
    _pulse = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    )..repeat(reverse: true);

    Future.delayed(const Duration(milliseconds: 2500), () {
      if (!mounted) return;
      final careerId = ModalRoute.of(context)!.settings.arguments as String;
      Navigator.pushReplacementNamed(
        context,
        AppRoutes.roadmap,
        arguments: careerId,
      );
    });
  }

  @override
  void dispose() {
    _pulse.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ScaleTransition(
                scale: Tween(begin: 0.9, end: 1.1).animate(
                  CurvedAnimation(parent: _pulse, curve: Curves.easeInOut),
                ),
                child: const Text('💪', style: TextStyle(fontSize: 60)),
              ),
              const SizedBox(height: 28),
              Text('Generating Your\nRoadmap...',
                  textAlign: TextAlign.center,
                  style: AppTextStyles.headingLarge),
              const SizedBox(height: 10),
              Text('Building the perfect path for you',
                  style: AppTextStyles.bodySmall),
              const SizedBox(height: 36),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(3, (i) {
                  return _AnimatedDot(
                    delay: Duration(milliseconds: i * 200),
                    color: [AppColors.blue, AppColors.green, AppColors.purple][i],
                  );
                }),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AnimatedDot extends StatefulWidget {
  final Duration delay;
  final Color color;
  const _AnimatedDot({required this.delay, required this.color});

  @override
  State<_AnimatedDot> createState() => _AnimatedDotState();
}

class _AnimatedDotState extends State<_AnimatedDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _c;

  @override
  void initState() {
    super.initState();
    _c = AnimationController(vsync: this,
        duration: const Duration(milliseconds: 900));
    Future.delayed(widget.delay, () {
      if (mounted) _c.repeat(reverse: true);
    });
  }

  @override
  void dispose() { _c.dispose(); super.dispose(); }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: ScaleTransition(
        scale: Tween(begin: 0.5, end: 1.0).animate(
            CurvedAnimation(parent: _c, curve: Curves.easeInOut)),
        child: FadeTransition(
          opacity: Tween(begin: 0.3, end: 1.0).animate(_c),
          child: CircleAvatar(radius: 6, backgroundColor: widget.color),
        ),
      ),
    );
  }
}

// ─── RoadmapScreen ────────────────────────────────────────────────────────────

class RoadmapScreen extends StatelessWidget {
  const RoadmapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final careerId = ModalRoute.of(context)!.settings.arguments as String;
    final career = findCareerById(careerId);

    int totalMilestones = 0;
    int completedOrActive = 0;
    for (final level in career.roadmapLevels) {
      for (final m in level.milestones) {
        totalMilestones++;
        if (m.isActive) completedOrActive++;
      }
    }
    final progress =
        totalMilestones > 0 ? completedOrActive / totalMilestones : 0.0;

    return Scaffold(
      body: GradientBackground(
        colors: const [
          Color(0xFFE4F2F8),
          Color(0xFFD4EADF),
          Color(0xFFE8F5EE),
        ],
        child: SafeArea(
          child: Column(
            children: [
              // ── Header ────────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        _NavButton(
                          onTap: () => Navigator.pop(context),
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
                        const Spacer(),
                        _NavButton(
                          onTap: () => Navigator.pushNamed(
                              context, AppRoutes.artifacts),
                          child: const Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text('🧠',
                                  style: TextStyle(fontSize: 14)),
                              SizedBox(width: 6),
                              Text('Artifacts',
                                  style: TextStyle(
                                      fontSize: 13,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.text2)),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 14),

                    // Career identity row
                    Row(
                      children: [
                        Container(
                          width: 44,
                          height: 44,
                          decoration: BoxDecoration(
                            color: AppColors.glassWhite,
                            border: Border.all(
                                color: AppColors.glassBorder, width: 1.5),
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Center(
                            child: Text(career.emoji,
                                style: const TextStyle(fontSize: 22)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(career.title,
                                style: AppTextStyles.headingMedium),
                            Text('Beginner → Placement Ready',
                                style: AppTextStyles.bodySmall),
                          ],
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    // Progress bar
                    _ProgressBar(
                      progress: progress,
                      completed: completedOrActive,
                      total: totalMilestones,
                    ),
                    const SizedBox(height: 6),
                  ],
                ),
              ),

              // ── Roadmap list ──────────────────────────────────────────────
              Expanded(
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 36),
                  children: career.roadmapLevels.map((level) {
                    return _LevelSection(level: level);
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Reusable nav button ──────────────────────────────────────────────────────

class _NavButton extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;
  const _NavButton({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 9),
        decoration: BoxDecoration(
          color: AppColors.glassWhite,
          border: Border.all(color: AppColors.glassBorder, width: 1.5),
          borderRadius: BorderRadius.circular(12),
        ),
        child: child,
      ),
    );
  }
}

// ─── Progress bar ─────────────────────────────────────────────────────────────

class _ProgressBar extends StatelessWidget {
  final double progress;
  final int completed;
  final int total;

  const _ProgressBar({
    required this.progress,
    required this.completed,
    required this.total,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(50),
          child: Stack(
            children: [
              Container(
                height: 10,
                decoration: BoxDecoration(
                  color: AppColors.glassWhite,
                  border: Border.all(color: AppColors.glassBorder, width: 1),
                  borderRadius: BorderRadius.circular(50),
                ),
              ),
              LayoutBuilder(builder: (ctx, constraints) {
                final w = (constraints.maxWidth * progress)
                    .clamp(0.0, constraints.maxWidth);
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 1000),
                  curve: Curves.easeOutCubic,
                  height: 10,
                  width: w,
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                        colors: [AppColors.blue, AppColors.green]),
                    borderRadius: BorderRadius.circular(50),
                  ),
                );
              }),
            ],
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('$completed of $total milestones done',
                style: AppTextStyles.label.copyWith(fontSize: 10)),
            Text('${(progress * 100).round()}% complete',
                style: AppTextStyles.label
                    .copyWith(fontSize: 10, color: AppColors.blue)),
          ],
        ),
      ],
    );
  }
}

// ─── Level section header ─────────────────────────────────────────────────────

class _LevelSection extends StatelessWidget {
  final RoadmapLevel level;
  const _LevelSection({required this.level});

  // Tier-specific emoji
  String get _tierEmoji {
    switch (level.tier) {
      case LevelTier.beginner:       return '🌱';
      case LevelTier.intermediate:   return '⚡';
      case LevelTier.advanced:       return '🔥';
      case LevelTier.placementReady: return '🏆';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 22),

        // ── Tier header pill ─────────────────────────────────────────
        Container(
          padding:
              const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
          decoration: BoxDecoration(
            color: level.tierColor.withOpacity(0.12),
            borderRadius: BorderRadius.circular(50),
            border:
                Border.all(color: level.tierColor.withOpacity(0.25)),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(_tierEmoji,
                  style: const TextStyle(fontSize: 14)),
              const SizedBox(width: 8),
              Text(
                level.tierLabel.toUpperCase(),
                style: AppTextStyles.label.copyWith(
                  color: level.tierColor,
                  fontSize: 11,
                  letterSpacing: 1.2,
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 12),

        // ── Milestones with timeline connector ───────────────────────
        ...List.generate(level.milestones.length, (i) {
          final m = level.milestones[i];
          final isLast = i == level.milestones.length - 1;
          return _TimelineItem(
            milestone: m,
            tierColor: level.tierColor,
            isLast: isLast,
          );
        }),
      ],
    );
  }
}

// ─── Timeline item: connector line + milestone card ───────────────────────────

class _TimelineItem extends StatelessWidget {
  final Milestone milestone;
  final Color tierColor;
  final bool isLast;

  const _TimelineItem({
    required this.milestone,
    required this.tierColor,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // ── Left timeline ────────────────────────────────────────
          SizedBox(
            width: 28,
            child: Column(
              children: [
                // Node circle
                Container(
                  width: 20,
                  height: 20,
                  decoration: BoxDecoration(
                    color: milestone.isActive
                        ? tierColor
                        : milestone.isLocked
                            ? AppColors.text3.withOpacity(0.2)
                            : tierColor.withOpacity(0.25),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: milestone.isActive
                          ? tierColor
                          : AppColors.glassBorder,
                      width: 2,
                    ),
                  ),
                  child: milestone.isActive
                      ? const Icon(Icons.play_arrow_rounded,
                          size: 10, color: Colors.white)
                      : milestone.isLocked
                          ? Icon(Icons.lock_rounded,
                              size: 9,
                              color: AppColors.text3.withOpacity(0.5))
                          : null,
                ),
                // Connector line (hidden for last item)
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 3),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            tierColor.withOpacity(0.4),
                            tierColor.withOpacity(0.1),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(1),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 10),

          // ── Milestone card ───────────────────────────────────────
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(bottom: isLast ? 0 : 12),
              child: _MilestoneCard(
                milestone: milestone,
                tierColor: tierColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Milestone card (expandable) ─────────────────────────────────────────────

class _MilestoneCard extends StatefulWidget {
  final Milestone milestone;
  final Color tierColor;

  const _MilestoneCard({required this.milestone, required this.tierColor});

  @override
  State<_MilestoneCard> createState() => _MilestoneCardState();
}

class _MilestoneCardState extends State<_MilestoneCard> {
  late bool _expanded;

  @override
  void initState() {
    super.initState();
    // Active milestone is expanded by default; others collapsed
    _expanded = widget.milestone.isActive;
  }

  bool get _isLocked =>
      widget.milestone.isLocked && !widget.milestone.isActive;

  @override
  Widget build(BuildContext context) {
    final m = widget.milestone;
    final tc = widget.tierColor;

    return Opacity(
      opacity: _isLocked ? 0.55 : 1.0,
      child: GestureDetector(
        onTap: _isLocked ? null : () => setState(() => _expanded = !_expanded),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          decoration: BoxDecoration(
            color: m.isActive
                ? Colors.white.withOpacity(0.9)
                : AppColors.glassWhite,
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: m.isActive ? tc.withOpacity(0.4) : AppColors.glassBorder,
              width: 1.5,
            ),
            boxShadow: m.isActive
                ? [
                    BoxShadow(
                      color: tc.withOpacity(0.15),
                      blurRadius: 18,
                      offset: const Offset(0, 4),
                    )
                  ]
                : null,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Card header (always visible) ──────────────────────
              Padding(
                padding: const EdgeInsets.all(14),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Step number badge
                    Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: _isLocked
                            ? AppColors.text3.withOpacity(0.08)
                            : tc.withOpacity(0.14),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Center(
                        child: _isLocked
                            ? Icon(Icons.lock_rounded,
                                size: 14, color: AppColors.text3)
                            : Text('${m.number}',
                                style: TextStyle(
                                    fontSize: 13,
                                    fontWeight: FontWeight.w800,
                                    color: tc)),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(m.title,
                              style: AppTextStyles.headingSmall),
                          const SizedBox(height: 3),
                          Text(m.description,
                              style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                    // Expand / collapse chevron
                    if (!_isLocked)
                      AnimatedRotation(
                        turns: _expanded ? 0.5 : 0,
                        duration: const Duration(milliseconds: 250),
                        child: Icon(Icons.keyboard_arrow_down_rounded,
                            size: 20, color: AppColors.text3),
                      ),
                  ],
                ),
              ),

              // ── Status tags (always visible) ──────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 0, 14, 12),
                child: Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    if (m.isActive)
                      _Tag('📍 Current',
                          bgColor: tc.withOpacity(0.12), textColor: tc),
                    if (_isLocked)
                      _Tag('Locked',
                          bgColor: AppColors.text3.withOpacity(0.08),
                          textColor: AppColors.text3),
                    _Tag('${m.taskCount} Tasks',
                        bgColor: AppColors.green.withOpacity(0.1),
                        textColor: AppColors.green),
                    _Tag('${m.resourceCount} Resources',
                        bgColor: AppColors.purple.withOpacity(0.1),
                        textColor: AppColors.purple),
                  ],
                ),
              ),

              // ── Expanded detail section ───────────────────────────
              if (_expanded) ...[
                Divider(
                    height: 1,
                    thickness: 1,
                    color: tc.withOpacity(0.12)),

                Padding(
                  padding: const EdgeInsets.all(14),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Topics
                      if (m.topics.isNotEmpty) ...[
                        _SectionLabel('WHAT YOU\'LL LEARN', tc),
                        const SizedBox(height: 8),
                        ...m.topics.map((topic) => _TopicRow(
                              topic: topic,
                              color: tc,
                            )),
                        const SizedBox(height: 14),
                      ],

                      // Tools
                      if (m.tools.isNotEmpty) ...[
                        _SectionLabel('TOOLS & TECH', tc),
                        const SizedBox(height: 8),
                        Wrap(
                          spacing: 6,
                          runSpacing: 6,
                          children: m.tools
                              .map((t) => _ToolChip(label: t, color: tc))
                              .toList(),
                        ),
                        const SizedBox(height: 14),
                      ],

                      // Outcome
                      if (m.outcome.isNotEmpty) ...[
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: tc.withOpacity(0.07),
                            borderRadius: BorderRadius.circular(12),
                            border:
                                Border.all(color: tc.withOpacity(0.2)),
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text('🎯',
                                  style:
                                      const TextStyle(fontSize: 15)),
                              const SizedBox(width: 10),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    Text('OUTCOME',
                                        style: AppTextStyles.label
                                            .copyWith(
                                                color: tc,
                                                fontSize: 9)),
                                    const SizedBox(height: 4),
                                    Text(m.outcome,
                                        style: AppTextStyles.bodyMedium
                                            .copyWith(
                                                fontWeight:
                                                    FontWeight.w500)),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],

                      // Start Learning CTA on active milestone
                      if (m.isActive) ...[
                        const SizedBox(height: 14),
                        SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: tc,
                              foregroundColor: Colors.white,
                              padding: const EdgeInsets.symmetric(
                                  vertical: 14),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                              elevation: 0,
                              textStyle: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700),
                            ),
                            child:
                                const Text('Start Learning  →'),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// ─── Sub-widgets ──────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  final Color color;
  const _SectionLabel(this.text, this.color);

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: AppTextStyles.label.copyWith(
          color: color, fontSize: 10, letterSpacing: 1.2),
    );
  }
}

class _TopicRow extends StatelessWidget {
  final String topic;
  final Color color;
  const _TopicRow({required this.topic, required this.color});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 5),
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color.withOpacity(0.6),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(topic,
                style: AppTextStyles.bodyMedium
                    .copyWith(height: 1.4)),
          ),
        ],
      ),
    );
  }
}

class _ToolChip extends StatelessWidget {
  final String label;
  final Color color;
  const _ToolChip({required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.7),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withOpacity(0.25)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 6,
            height: 6,
            decoration: BoxDecoration(
              color: color.withOpacity(0.7),
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(label,
              style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.w600,
                  color: AppColors.text2)),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  final String label;
  final Color bgColor;
  final Color textColor;
  const _Tag(this.label, {required this.bgColor, required this.textColor});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 4),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(50),
        border: Border.all(color: textColor.withOpacity(0.2)),
      ),
      child: Text(label,
          style: TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: textColor)),
    );
  }
}
