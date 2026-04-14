import 'package:flutter/material.dart';
import '../models/artifact_models.dart';
import 'community_screen.dart';
import 'dashboard_screen.dart';
import 'quiz_screen.dart';
import 'roadmap_screen.dart';
import 'visualizer_screen.dart';

class ArtifactScreen extends StatefulWidget {
  final ArtifactType initialArtifact;

  const ArtifactScreen({
    super.key,
    this.initialArtifact = ArtifactType.dashboard,
  });

  @override
  State<ArtifactScreen> createState() => _ArtifactScreenState();
}

class _ArtifactScreenState extends State<ArtifactScreen> {
  late ArtifactType _current;

  @override
  void initState() {
    super.initState();
    _current = widget.initialArtifact;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: ArtifactType.values.indexOf(_current),
        children: const [
          DashboardScreen(),
          CommunityScreen(),
          QuizScreen(),
          VisualizerScreen(),
          RoadmapArtifactScreen(),
        ],
      ),
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
          NavigationDestination(icon: Text('🔭'), label: 'Visualizer'),
          NavigationDestination(icon: Text('🗺️'), label: 'Roadmap'),
        ],
      ),
    );
  }
}
