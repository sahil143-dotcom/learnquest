import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/constants/routes.dart';
import '../../../shared/widgets/glass_card.dart';
import '../../../providers/user_provider.dart';
import '../data/career_data.dart';
import '../models/career_model.dart';
import '../widgets/career_bottom_sheet.dart';

// ─── SpecializationScreen ─────────────────────────────────────────────────────
// Shows a grid of career specializations under Engineering > CSE.
// Tapping a card opens the CareerBottomSheet.
// Cards animate in with a staggered entrance on first load.

class SpecializationScreen extends ConsumerStatefulWidget {
  const SpecializationScreen({super.key});

  @override
  ConsumerState<SpecializationScreen> createState() => _SpecializationScreenState();
}

class _SpecializationScreenState extends ConsumerState<SpecializationScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late List<Animation<double>> _cardAnims;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    // Stagger each card 100ms apart
    _cardAnims = List.generate(careerList.length, (i) {
      final start = (i * 0.12).clamp(0.0, 0.7);
      return Tween<double>(begin: 0, end: 1).animate(
        CurvedAnimation(
          parent: _controller,
          curve: Interval(start, (start + 0.4).clamp(0, 1),
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

  void _openBottomSheet(BuildContext context, CareerModel career) {
    CareerBottomSheet.show(
      context,
      career,
      onChoosePath: () async {
        // Save to SharedPreferences (for auth screen display)
        final prefs = await SharedPreferences.getInstance();
        prefs.setString('selected_career_id', career.id);
        prefs.setString('selected_career_emoji', career.emoji);
        prefs.setString('selected_career_title', career.title);

        await ref.read(userProgressProvider.notifier).addCareer(career.id);

        if (context.mounted) {
          Navigator.pushReplacementNamed(
            context,
            AppRoutes.roadmapLoading,
            arguments: career.id,
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: GradientBackground(
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Back button
                GestureDetector(
                  onTap: () => Navigator.pop(context),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 14, vertical: 9),
                    decoration: BoxDecoration(
                      color: AppColors.glassWhite,
                      border: Border.all(
                          color: AppColors.glassBorder, width: 1.5),
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
                ScreenTag('Engineering → ${(ModalRoute.of(context)?.settings.arguments as String?) ?? 'CSE'}'),
                const SizedBox(height: 12),
                Text('Pick Your\nSpecialization 🔥',
                    style: AppTextStyles.displayMedium),
                const SizedBox(height: 8),
                Text(
                  'Tap any card to explore the field before committing.',
                  style: AppTextStyles.bodySmall,
                ),
                const SizedBox(height: 20),
                Expanded(
                  child: GridView.builder(
                    itemCount: careerList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      crossAxisSpacing: 12,
                      mainAxisSpacing: 12,
                      childAspectRatio: 0.95,
                    ),
                    itemBuilder: (context, i) {
                      final career = careerList[i];
                      return AnimatedBuilder(
                        animation: _cardAnims[i],
                        builder: (_, child) => Opacity(
                          opacity: _cardAnims[i].value,
                          child: Transform.translate(
                            offset:
                                Offset(0, 20 * (1 - _cardAnims[i].value)),
                            child: child,
                          ),
                        ),
                        child: _SpecCard(
                          career: career,
                          onTap: () => _openBottomSheet(context, career),
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

// ─── Career card in the grid ──────────────────────────────────────────────────

class _SpecCard extends StatelessWidget {
  final CareerModel career;
  final VoidCallback onTap;

  const _SpecCard({required this.career, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        decoration: BoxDecoration(
          color: AppColors.glassWhite,
          border: Border.all(color: AppColors.glassBorder, width: 1.5),
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: AppColors.blue.withOpacity(0.08),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Icon container
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: career.backgroundColor,
                  borderRadius: BorderRadius.circular(18),
                ),
                child: Center(
                  child: Text(career.emoji,
                      style: const TextStyle(fontSize: 28)),
                ),
              ),
              const SizedBox(height: 10),
              Text(
                career.title,
                textAlign: TextAlign.center,
                style: AppTextStyles.headingSmall,
                maxLines: 2,
              ),
              const SizedBox(height: 4),
              Text(
                career.subtitle,
                textAlign: TextAlign.center,
                style: AppTextStyles.bodySmall,
                maxLines: 2,
              ),
              const SizedBox(height: 10),
              // Badge pill (demand/interest label)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: career.backgroundColor,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                      color: career.accentColor.withOpacity(0.2)),
                ),
                child: Text(
                  career.badge,
                  style: TextStyle(
                    fontSize: 9,
                    fontWeight: FontWeight.w700,
                    color: career.accentColor,
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
