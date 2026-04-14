// ─── artifact_loader.dart ─────────────────────────────────────────────────────
// Loading shimmer widget used while HTML artifacts are loading in WebView.

import 'package:flutter/material.dart';
import '../core/theme/app_theme.dart';

class ArtifactLoader extends StatefulWidget {
  final String title;
  final String emoji;
  const ArtifactLoader({super.key, required this.title, required this.emoji});

  @override
  State<ArtifactLoader> createState() => _ArtifactLoaderState();
}

class _ArtifactLoaderState extends State<ArtifactLoader>
    with SingleTickerProviderStateMixin {
  late AnimationController _anim;

  @override
  void initState() {
    super.initState();
    _anim = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _anim.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ScaleTransition(
            scale: Tween(begin: 0.85, end: 1.1).animate(
              CurvedAnimation(parent: _anim, curve: Curves.easeInOut),
            ),
            child: Text(widget.emoji,
                style: const TextStyle(fontSize: 52)),
          ),
          const SizedBox(height: 20),
          Text('Loading ${widget.title}…',
              style: AppTextStyles.headingSmall),
          const SizedBox(height: 8),
          const SizedBox(
            width: 160,
            child: LinearProgressIndicator(
              color: AppColors.blue,
              backgroundColor: Color(0x20000000),
            ),
          ),
        ],
      ),
    );
  }
}
