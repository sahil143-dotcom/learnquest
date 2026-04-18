import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
import '../../core/constants/routes.dart';
import '../../shared/widgets/glass_card.dart';

// ─── DomainSelectScreen ───────────────────────────────────────────────────────
// User picks a top-level domain (Engineering, Law, Business, Creative).
// Only Engineering is live for the MVP — others show "Coming soon".
// Cards animate in with a staggered entrance.

class DomainSelectScreen extends StatefulWidget {
  const DomainSelectScreen({super.key});

  @override
  State<DomainSelectScreen> createState() => _DomainSelectScreenState();
}

class _DomainSelectScreenState extends State<DomainSelectScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _anims;

  static const _cardCount = 4;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _anims = List.generate(_cardCount, (i) {
      final start = i * 0.14;
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

  @override
  Widget build(BuildContext context) {
    final domains = [
      _DomainItem(
        emoji: '💻',
        title: 'Engineering',
        subtitle: 'CSE, ECE, Mechanical & more',
        badge: '✦ Live',
        badgeColor: AppColors.blue,
        isActive: true,
        onTap: () => Navigator.pushReplacementNamed(context, AppRoutes.branchSelect),
      ),
      _DomainItem(
        emoji: '⚖️',
        title: 'Law',
        subtitle: 'Legal studies & practice',
        badge: 'Coming Soon',
        badgeColor: AppColors.text3,
        isActive: false,
      ),
      _DomainItem(
        emoji: '📊',
        title: 'Business',
        subtitle: 'MBA, Finance & Startups',
        badge: 'Coming Soon',
        badgeColor: AppColors.text3,
        isActive: false,
      ),
      _DomainItem(
        emoji: '🎨',
        title: 'Creative',
        subtitle: 'Design, Content & Media',
        badge: 'Coming Soon',
        badgeColor: AppColors.text3,
        isActive: false,
      ),
    ];

    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 52, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Choose Your\nDomain 🎯',
                    style: AppTextStyles.displayMedium),
                const SizedBox(height: 8),
                Text(
                  'Select the field you want to build your career in.',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 28),
                Expanded(
                  child: ListView.separated(
                    itemCount: domains.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final d = domains[i];
                      return AnimatedBuilder(
                        animation: _anims[i],
                        builder: (_, child) => Opacity(
                          opacity: _anims[i].value,
                          child: Transform.translate(
                            offset: Offset(
                                24 * (1 - _anims[i].value), 0),
                            child: child,
                          ),
                        ),
                        child: _DomainCard(item: d),
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

// ─── Data ─────────────────────────────────────────────────────────────────────

class _DomainItem {
  final String emoji;
  final String title;
  final String subtitle;
  final String badge;
  final Color badgeColor;
  final bool isActive;
  final VoidCallback? onTap;

  const _DomainItem({
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.badgeColor,
    required this.isActive,
    this.onTap,
  });
}

// ─── Card widget ──────────────────────────────────────────────────────────────

class _DomainCard extends StatelessWidget {
  final _DomainItem item;
  const _DomainCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: item.isActive ? 1.0 : 0.52,
      child: GlassCard(
        onTap: item.isActive ? item.onTap : null,
        padding: const EdgeInsets.all(18),
        child: Row(
          children: [
            // Emoji icon
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: item.isActive
                    ? AppColors.blue.withOpacity(0.10)
                    : Colors.white.withOpacity(0.4),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Center(
                child: Text(item.emoji,
                    style: const TextStyle(fontSize: 26)),
              ),
            ),
            const SizedBox(width: 16),
            // Title + subtitle
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title, style: AppTextStyles.headingSmall),
                  const SizedBox(height: 3),
                  Text(item.subtitle, style: AppTextStyles.bodySmall),
                ],
              ),
            ),
            // Badge pill
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: item.badgeColor.withOpacity(0.12),
                borderRadius: BorderRadius.circular(50),
                border: Border.all(
                    color: item.badgeColor.withOpacity(0.25)),
              ),
              child: Text(
                item.badge,
                style: TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: item.badgeColor,
                ),
              ),
            ),
            if (item.isActive) ...[
              const SizedBox(width: 10),
              Icon(Icons.arrow_forward_ios_rounded,
                  size: 14, color: AppColors.blue),
            ],
          ],
        ),
      ),
    );
  }
}
