// ─── user_progress.dart ───────────────────────────────────────────────────────
// Lightweight user progress model used across artifact screens.

class UserProgress {
  final String uid;
  final String name;
  final int level;
  final int xp;
  final String? selectedCareer;
  final List<String> completedMilestones;
  final List<String> joinedGroups;

  const UserProgress({
    required this.uid,
    required this.name,
    required this.level,
    required this.xp,
    this.selectedCareer,
    this.completedMilestones = const [],
    this.joinedGroups = const [],
  });

  factory UserProgress.empty() => const UserProgress(
        uid: '',
        name: 'You',
        level: 1,
        xp: 0,
      );

  UserProgress copyWith({
    String? uid,
    String? name,
    int? level,
    int? xp,
    String? selectedCareer,
    List<String>? completedMilestones,
    List<String>? joinedGroups,
  }) {
    return UserProgress(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      selectedCareer: selectedCareer ?? this.selectedCareer,
      completedMilestones: completedMilestones ?? this.completedMilestones,
      joinedGroups: joinedGroups ?? this.joinedGroups,
    );
  }

  // XP needed to reach next level
  int get xpToNextLevel => (level * 500);

  // Progress fraction within current level
  double get levelProgress => (xp % xpToNextLevel) / xpToNextLevel;

  String get xpDisplay {
    if (xp >= 1000) return '${(xp / 1000).toStringAsFixed(1)}K';
    return '$xp';
  }
}
