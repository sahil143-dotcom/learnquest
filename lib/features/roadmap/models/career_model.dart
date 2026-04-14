import 'package:flutter/material.dart';
import '../../../core/theme/app_theme.dart';

// ─── CareerModel ─────────────────────────────────────────────────────────────
// Pure data class. No logic, no UI.
// Add a field here → it shows up in the bottom sheet automatically.

class CareerModel {
  final String id;
  final String emoji;
  final String title;
  final String subtitle;
  final String badge;
  final Color accentColor;
  final Color backgroundColor;
  final String description;
  final List<String> realWorldExamples;
  final List<String> skills;
  final String whoIsItFor;
  final List<RoadmapLevel> roadmapLevels;

  const CareerModel({
    required this.id,
    required this.emoji,
    required this.title,
    required this.subtitle,
    required this.badge,
    required this.accentColor,
    required this.backgroundColor,
    required this.description,
    required this.realWorldExamples,
    required this.skills,
    required this.whoIsItFor,
    required this.roadmapLevels,
  });
}

// ─── Roadmap data structures ──────────────────────────────────────────────────

enum LevelTier { beginner, intermediate, advanced, placementReady }

class RoadmapLevel {
  final LevelTier tier;
  final List<Milestone> milestones;

  const RoadmapLevel({required this.tier, required this.milestones});

  String get tierLabel {
    switch (tier) {
      case LevelTier.beginner:       return 'Beginner';
      case LevelTier.intermediate:   return 'Intermediate';
      case LevelTier.advanced:       return 'Advanced';
      case LevelTier.placementReady: return 'Placement Ready';
    }
  }

  Color get tierColor {
    switch (tier) {
      case LevelTier.beginner:       return AppColors.blue;
      case LevelTier.intermediate:   return AppColors.green;
      case LevelTier.advanced:       return AppColors.purple;
      case LevelTier.placementReady: return AppColors.coral;
    }
  }
}

class Milestone {
  final int number;
  final String title;
  final String description;
  final int taskCount;
  final int resourceCount;
  final bool isActive;    // "You are here"
  final bool isLocked;

  /// Specific topics/fundamentals covered in this milestone
  final List<String> topics;

  /// Tools & technologies used
  final List<String> tools;

  /// What the learner will be able to do after completing this milestone
  final String outcome;

  const Milestone({
    required this.number,
    required this.title,
    required this.description,
    required this.taskCount,
    required this.resourceCount,
    this.isActive = false,
    this.isLocked = true,
    this.topics = const [],
    this.tools = const [],
    this.outcome = '',
  });
}
