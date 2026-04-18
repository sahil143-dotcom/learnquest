// ─── user_progress.dart ───────────────────────────────────────────────────────
// Lightweight user progress model used across artifact screens.

class UserProgress {
  final String uid;
  final String name;
  final int level;
  final int xp;
  final String? selectedCareer;
  final List<String> selectedCareers;
  final List<String> completedMilestones;
  final List<String> joinedGroups;

  // ── Streak tracking ──────────────────────────────────────────────────────────
  final int streakDays;          // Current active streak count
  final DateTime? lastActivityDate; // Last day the user opened the app
  final int longestStreak;       // Personal best streak ever

  const UserProgress({
    required this.uid,
    required this.name,
    required this.level,
    required this.xp,
    this.selectedCareer,
    this.selectedCareers = const [],
    this.completedMilestones = const [],
    this.joinedGroups = const [],
    this.streakDays = 0,
    this.lastActivityDate,
    this.longestStreak = 0,
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
    List<String>? selectedCareers,
    List<String>? completedMilestones,
    List<String>? joinedGroups,
    int? streakDays,
    DateTime? lastActivityDate,
    int? longestStreak,
  }) {
    return UserProgress(
      uid: uid ?? this.uid,
      name: name ?? this.name,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      selectedCareer: selectedCareer ?? this.selectedCareer,
      selectedCareers: selectedCareers ?? this.selectedCareers,
      completedMilestones: completedMilestones ?? this.completedMilestones,
      joinedGroups: joinedGroups ?? this.joinedGroups,
      streakDays: streakDays ?? this.streakDays,
      lastActivityDate: lastActivityDate ?? this.lastActivityDate,
      longestStreak: longestStreak ?? this.longestStreak,
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

  /// Returns a short human-readable streak label e.g. "12-day streak"
  String get streakLabel =>
      streakDays == 0 ? 'No streak yet' : '$streakDays-day streak';
}
