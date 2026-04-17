import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';

// ─── GlassCard ────────────────────────────────────────────────────────────────
// The signature glassmorphism card used throughout LearnQuest.
// Wrap any content in this to get consistent glass styling.

class GlassCard extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final double borderRadius;
  final Color? borderColor;
  final VoidCallback? onTap;

  const GlassCard({
    super.key,
    required this.child,
    this.padding,
    this.borderRadius = 20,
    this.borderColor,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: padding ?? const EdgeInsets.all(18),
        decoration: BoxDecoration(
          color: AppColors.glassWhite,
          border: Border.all(
            color: borderColor ?? AppColors.glassBorder,
            width: 1.5,
          ),
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}

// ─── GradientBackground ───────────────────────────────────────────────────────
// The pastel gradient background used on every screen.

class GradientBackground extends StatelessWidget {
  final Widget child;
  final List<Color>? colors;

  const GradientBackground({super.key, required this.child, this.colors});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: colors ?? const [
            AppColors.gradientStart,
            AppColors.gradientMid,
            AppColors.gradientEnd,
          ],
          stops: const [0.0, 0.45, 1.0],
        ),
      ),
      child: child,
    );
  }
}

// ─── ScreenTag ─────────────────────────────────────────────────────────────────
// The small pill label like "Step 2 of 3" shown above headings.

class ScreenTag extends StatelessWidget {
  final String label;

  const ScreenTag(this.label, {super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
      decoration: BoxDecoration(
        color: AppColors.glassWhite,
        border: Border.all(color: AppColors.glassBorder),
        borderRadius: BorderRadius.circular(50),
      ),
      child: Text(
        label.toUpperCase(),
        style: AppTextStyles.label.copyWith(color: AppColors.green),
      ),
    );
  }
}

// ─── PrimaryButton ────────────────────────────────────────────────────────────

class PrimaryButton extends StatelessWidget {
  final String label;
  final VoidCallback onPressed;
  final bool fullWidth;

  const PrimaryButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fullWidth = true,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: fullWidth ? double.infinity : null,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(label),
      ),
    );
  }
}
