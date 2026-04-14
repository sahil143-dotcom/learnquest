// ─── visualizer_screen.dart ─────────────────────────────────────────────────
// Concept Visualizer — loads visualizer.html via WebView.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../models/artifact_models.dart';
import '../providers/user_provider.dart';
import '../shared/widgets/glass_card.dart';
import '../widgets/webview_wrapper.dart';

class VisualizerScreen extends ConsumerWidget {
  const VisualizerScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProgressProvider);

    return Scaffold(
      body: GradientBackground(
        colors: const [Color(0xFFEDE7F6), Color(0xFFE3F2FD), Color(0xFFE8F5EE)],
        child: SafeArea(
          child: Column(
            children: [
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
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Concept Visualizer 🔭',
                            style: AppTextStyles.headingSmall),
                        Text('Visual learning mode',
                            style: AppTextStyles.bodySmall),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ClipRRect(
                  borderRadius:
                      const BorderRadius.vertical(top: Radius.circular(20)),
                  child: WebViewWrapper(
                    type: ArtifactType.visualizer,
                    injectedData: {
                      'career': user.selectedCareer ?? 'general',
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
