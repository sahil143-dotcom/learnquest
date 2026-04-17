// ─── roadmap_screen.dart (artifact) ─────────────────────────────────────────
// Career Roadmap Artifact — loads roadmap.html via WebView.
// This is an OPTIONAL artifact wrapper; the existing native roadmap_screen.dart
// in features/roadmap is untouched.

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../core/theme/app_theme.dart';
import '../models/artifact_models.dart';
import '../providers/user_provider.dart';
import '../shared/widgets/glass_card.dart';
import '../widgets/webview_wrapper.dart';

class RoadmapArtifactScreen extends ConsumerWidget {
  const RoadmapArtifactScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(userProgressProvider);

    return Scaffold(
      body: GradientBackground(
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
                        Text('Career Roadmap 🗺️',
                            style: AppTextStyles.headingSmall),
                        Text(user.selectedCareer ?? 'Your path forward',
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
                    type: ArtifactType.roadmap,
                    injectedData: {
                      'career': user.selectedCareer ?? 'general',
                      'completedMilestones':
                          user.completedMilestones.join(','),
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
