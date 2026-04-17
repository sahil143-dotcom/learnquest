import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/artifact_models.dart';
import '../models/user_progress.dart';
import '../providers/user_provider.dart';
import 'community_screen.dart';
import 'dashboard_screen.dart';
import 'placement_prep_screen.dart';
import 'quiz_screen.dart';

// Removed: RoadmapArtifactScreen (WebView placeholder)
// Removed: VisualizerScreen (WebView with 4 hardcoded bullet points)

class ArtifactScreen extends ConsumerStatefulWidget {
  final ArtifactType initialArtifact;

  const ArtifactScreen({
    super.key,
    this.initialArtifact = ArtifactType.dashboard,
  });

  @override
  ConsumerState<ArtifactScreen> createState() => _ArtifactScreenState();
}

class _ArtifactScreenState extends ConsumerState<ArtifactScreen> {
  late ArtifactType _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialArtifact;
  }

  @override
  Widget build(BuildContext context) {
    final userProgress = ref.watch(userProgressProvider);

    return Scaffold(
      // ── Body: IndexedStack with floating HUD overlay ─────────────────────
      body: Stack(
        children: [
          IndexedStack(
            index: ArtifactType.values.indexOf(_current),
            children: const [
              DashboardScreen(),
              CommunityScreen(),
              QuizScreen(),
              PlacementPrepScreen(),
            ],
          ),

          // ── Floating Streak HUD pill (Case 2) ────────────────────────────
          Positioned(
            top: MediaQuery.of(context).padding.top + 10,
            right: 16,
            child: _ArtifactHUD(progress: userProgress),
          ),
        ],
      ),

      // ── Bottom navigation — 4 clean tabs ────────────────────────────────
      bottomNavigationBar: NavigationBar(
        selectedIndex: ArtifactType.values.indexOf(_current),
        onDestinationSelected: (index) {
          setState(() => _current = ArtifactType.values[index]);
        },
        backgroundColor: Colors.white,
        indicatorColor: const Color(0xFF6C63FF).withValues(alpha: 0.15),
        destinations: const [
          NavigationDestination(icon: Text('📊'), label: 'Dashboard'),
          NavigationDestination(icon: Text('🌐'), label: 'Community'),
          NavigationDestination(icon: Text('🧠'), label: 'Quiz'),
          NavigationDestination(icon: Text('🎯'), label: 'Prep'),
        ],
      ),
    );
  }
}

// ─── Floating HUD (streak · level · XP) ──────────────────────────────────────

class _ArtifactHUD extends StatelessWidget {
  final UserProgress progress;
  const _ArtifactHUD({required this.progress});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.96),
        borderRadius: BorderRadius.circular(30),
        border: Border.all(color: Colors.white.withOpacity(0.8), width: 1.2),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.09),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _HUDItem(emoji: '🔥', value: '${progress.streakDays}',
              label: 'streak', valueColor: const Color(0xFFE8593C)),
          _HUDDivider(),
          _HUDItem(emoji: '⚡', value: 'Lv${progress.level}',
              label: 'level', valueColor: const Color(0xFF4A90B8)),
          _HUDDivider(),
          _HUDItem(emoji: '✨', value: progress.xpDisplay,
              label: 'xp', valueColor: const Color(0xFF7C6FD0)),
        ],
      ),
    );
  }
}

class _HUDItem extends StatelessWidget {
  final String emoji;
  final String value;
  final String label;
  final Color valueColor;

  const _HUDItem({
    required this.emoji, required this.value,
    required this.label, required this.valueColor,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(emoji, style: const TextStyle(fontSize: 12)),
            const SizedBox(width: 3),
            Text(value,
                style: TextStyle(
                    fontSize: 12, fontWeight: FontWeight.w800,
                    color: valueColor)),
          ],
        ),
        const SizedBox(height: 1),
        Text(label,
            style: const TextStyle(
                fontSize: 9, color: Color(0xFF6B8A82),
                fontWeight: FontWeight.w500, letterSpacing: 0.3)),
      ],
    );
  }
}

class _HUDDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1, height: 26,
      margin: const EdgeInsets.symmetric(horizontal: 9),
      color: const Color(0xFFE0E6E4),
    );
  }
}
