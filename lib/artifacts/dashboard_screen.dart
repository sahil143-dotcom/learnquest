// ─── dashboard_screen.dart ────────────────────────────────────────────────────
// Daily Dashboard — loads dashboard.html via WebView.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../models/artifact_models.dart';
import '../providers/user_provider.dart';
import '../shared/widgets/glass_card.dart';
import '../widgets/webview_wrapper.dart';

class DashboardScreen extends ConsumerWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProgressProvider);

    return Scaffold(
      body: GradientBackground(
        colors: const [Color(0xFFE4F2F8), Color(0xFFD4EADF), Color(0xFFE8F5EE)],
        child: SafeArea(
          child: Column(
            children: [
              // ── App bar ────────────────────────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    GestureDetector(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 14, vertical: 9),
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
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Daily Dashboard 📊',
                              style: AppTextStyles.headingSmall),
                          Text('Level ${user.level} · ${user.xpDisplay} XP',
                              style: AppTextStyles.bodySmall),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              // ── WebView content ─────────────────────────────────────────
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: WebViewWrapper(
                    type: ArtifactType.dashboard,
                    injectedData: {
                      'userName': user.name,
                      'level': user.level,
                      'xp': user.xp,
                    },
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
