import 'package:flutter/material.dart';
import '../models/career_model.dart';
import '../../../core/theme/app_theme.dart';

// ─── CareerBottomSheet ────────────────────────────────────────────────────────
// Reusable bottom sheet that explains any career in beginner-friendly language.
//
// HOW IT WORKS:
// Flutter's showModalBottomSheet() slides a widget up from the bottom of the
// screen, dims everything behind it, and removes it when dismissed.
//
// HOW DATA IS PASSED:
// You pass a CareerModel into the constructor. The widget just renders whatever
// is in that model — it has zero knowledge of which career it's showing.
//
// HOW TO REUSE IT:
// Call CareerBottomSheet.show(context, career, onChoosePath: ...) from anywhere.
// Adding a new career? Just add it to career_data.dart. Never touch this file.

class CareerBottomSheet extends StatelessWidget {
  final CareerModel career;
  final VoidCallback onChoosePath;

  const CareerBottomSheet({
    super.key,
    required this.career,
    required this.onChoosePath,
  });

  // ── Static helper ── call this instead of creating the widget manually ───
  static void show(
    BuildContext context,
    CareerModel career, {
    required VoidCallback onChoosePath,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,   // lets the sheet be taller than 50%
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withOpacity(0.45),
      builder: (_) => CareerBottomSheet(
        career: career,
        onChoosePath: onChoosePath,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    // DraggableScrollableSheet allows the user to drag the sheet
    // up or down. It starts at 85% screen height.
    return DraggableScrollableSheet(
      initialChildSize: 0.85,
      maxChildSize: 0.95,
      minChildSize: 0.5,
      builder: (_, scrollController) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          child: Column(
            children: [
              _SheetHandle(),
              Expanded(
                child: SingleChildScrollView(
                  controller: scrollController,
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _SheetHeader(career: career),
                      const SizedBox(height: 16),
                      _SheetDescription(text: career.description),
                      const SizedBox(height: 20),
                      _SheetSection(
                        label: 'Real-world examples',
                        child: _BulletList(
                          items: career.realWorldExamples,
                          dotColor: career.accentColor,
                        ),
                      ),
                      _SheetSection(
                        label: 'Skills you\'ll learn',
                        child: _SkillChips(
                          skills: career.skills,
                          accentColor: career.accentColor,
                          bgColor: career.backgroundColor,
                        ),
                      ),
                      _SheetSection(
                        label: 'Who is it for?',
                        child: _WhoBox(
                          text: career.whoIsItFor,
                          accentColor: career.accentColor,
                          bgColor: career.backgroundColor,
                        ),
                      ),
                      const SizedBox(height: 24),
                    ],
                  ),
                ),
              ),
              _CTAButton(career: career, onChoosePath: onChoosePath),
            ],
          ),
        );
      },
    );
  }
}

// ─── Private sub-widgets ──────────────────────────────────────────────────────
// Each piece of the sheet is its own widget.
// Pros: easy to test, easy to find, easy to change.

class _SheetHandle extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 12),
      width: 40,
      height: 4,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(2),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  final CareerModel career;
  const _SheetHeader({required this.career});

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Emoji icon in a rounded box
        Container(
          width: 56,
          height: 56,
          decoration: BoxDecoration(
            color: career.backgroundColor,
            borderRadius: BorderRadius.circular(18),
          ),
          child: Center(
            child: Text(career.emoji, style: const TextStyle(fontSize: 28)),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(career.title, style: AppTextStyles.headingMedium),
              const SizedBox(height: 5),
              // Badge pill
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: career.backgroundColor,
                  borderRadius: BorderRadius.circular(50),
                  border: Border.all(
                    color: career.accentColor.withOpacity(0.2),
                  ),
                ),
                child: Text(
                  career.badge,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: career.accentColor,
                  ),
                ),
              ),
            ],
          ),
        ),
        // Close button
        GestureDetector(
          onTap: () => Navigator.pop(context),
          child: Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(50),
            ),
            child: Icon(Icons.close_rounded,
                size: 18, color: Colors.grey.shade500),
          ),
        ),
      ],
    );
  }
}

class _SheetDescription extends StatelessWidget {
  final String text;
  const _SheetDescription({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: AppTextStyles.bodyMedium);
  }
}

// Section = label + content, keeps spacing consistent
class _SheetSection extends StatelessWidget {
  final String label;
  final Widget child;
  const _SheetSection({required this.label, required this.child});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label.toUpperCase(), style: AppTextStyles.label),
        const SizedBox(height: 10),
        child,
        const SizedBox(height: 20),
      ],
    );
  }
}

class _BulletList extends StatelessWidget {
  final List<String> items;
  final Color dotColor;
  const _BulletList({required this.items, required this.dotColor});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: items.map((item) {
        return Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 6),
                child: CircleAvatar(radius: 3, backgroundColor: dotColor),
              ),
              const SizedBox(width: 10),
              Expanded(child: Text(item, style: AppTextStyles.bodyMedium)),
            ],
          ),
        );
      }).toList(),
    );
  }
}

class _SkillChips extends StatelessWidget {
  final List<String> skills;
  final Color accentColor;
  final Color bgColor;
  const _SkillChips({
    required this.skills,
    required this.accentColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: skills.map((skill) {
        return Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: bgColor,
            border: Border.all(color: accentColor.withOpacity(0.25)),
            borderRadius: BorderRadius.circular(50),
          ),
          child: Text(
            skill,
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: accentColor,
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _WhoBox extends StatelessWidget {
  final String text;
  final Color accentColor;
  final Color bgColor;

  const _WhoBox({
    required this.text,
    required this.accentColor,
    required this.bgColor,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: accentColor.withOpacity(0.25)),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text('💡', style: const TextStyle(fontSize: 16)),
          const SizedBox(width: 10),
          Expanded(child: Text(text, style: AppTextStyles.bodyMedium)),
        ],
      ),
    );
  }
}

class _CTAButton extends StatelessWidget {
  final CareerModel career;
  final VoidCallback onChoosePath;
  const _CTAButton({required this.career, required this.onChoosePath});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // close sheet first
            onChoosePath();         // then fire the callback
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: career.accentColor,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(14),
            ),
            elevation: 0,
          ),
          child: const Text(
            'Choose this path →',
            style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
          ),
        ),
      ),
    );
  }
}
