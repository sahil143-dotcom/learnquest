// ─── artifact_models.dart ─────────────────────────────────────────────────────
// Data models shared across all artifact screens.

// ── Artifact type enum ────────────────────────────────────────────────────────
enum ArtifactType { dashboard, community, quiz, visualizer, roadmap }

extension ArtifactTypeExt on ArtifactType {
  String get assetPath {
    switch (this) {
      case ArtifactType.dashboard:   return 'assets/artifacts/dashboard.html';
      case ArtifactType.community:   return 'assets/artifacts/community.html';
      case ArtifactType.quiz:        return 'assets/artifacts/quiz.html';
      case ArtifactType.visualizer:  return 'assets/artifacts/visualizer.html';
      case ArtifactType.roadmap:     return 'assets/artifacts/roadmap.html';
    }
  }

  String get title {
    switch (this) {
      case ArtifactType.dashboard:   return 'Daily Dashboard';
      case ArtifactType.community:   return 'Community Hub';
      case ArtifactType.quiz:        return 'Adaptive Quiz';
      case ArtifactType.visualizer:  return 'Concept Visualizer';
      case ArtifactType.roadmap:     return 'Career Roadmap';
    }
  }

  String get emoji {
    switch (this) {
      case ArtifactType.dashboard:   return '📊';
      case ArtifactType.community:   return '🌐';
      case ArtifactType.quiz:        return '🧠';
      case ArtifactType.visualizer:  return '🔭';
      case ArtifactType.roadmap:     return '🗺️';
    }
  }
}

// ── Community models ──────────────────────────────────────────────────────────

class LeaderboardEntry {
  final int rank;
  final String name;
  final int level;
  final int xp;
  final String avatarColor;
  final bool isCurrentUser;
  final String? badge;

  const LeaderboardEntry({
    required this.rank,
    required this.name,
    required this.level,
    required this.xp,
    required this.avatarColor,
    this.isCurrentUser = false,
    this.badge,
  });
}

class DiscussionPost {
  final String id;
  final String authorName;
  final String authorEmoji;
  final String timeAgo;
  final String title;
  final String preview;
  final int replies;
  final int likes;
  final bool isPinned;
  final String? tag; // 'HOT', 'NEW', etc.

  const DiscussionPost({
    required this.id,
    required this.authorName,
    required this.authorEmoji,
    required this.timeAgo,
    required this.title,
    required this.preview,
    required this.replies,
    required this.likes,
    this.isPinned = false,
    this.tag,
  });
}

class StudyGroup {
  final String id;
  final String emoji;
  final String name;
  final int members;
  final String description;
  final String lastActive;
  final List<String> memberAvatarColors;
  final bool isJoined;

  const StudyGroup({
    required this.id,
    required this.emoji,
    required this.name,
    required this.members,
    required this.description,
    required this.lastActive,
    required this.memberAvatarColors,
    this.isJoined = false,
  });
}

class CommunityProject {
  final String id;
  final String emoji;
  final String title;
  final String description;
  final double progress; // 0.0 – 1.0
  final bool isCompleted;
  final List<String> memberColors;

  const CommunityProject({
    required this.id,
    required this.emoji,
    required this.title,
    required this.description,
    required this.progress,
    required this.isCompleted,
    required this.memberColors,
  });
}

// ── Activity timeline models ──────────────────────────────────────────────────

class ActivityEntry {
  final String timeLabel;
  final String title;
  final String description;
  final bool isCompleted;

  const ActivityEntry({
    required this.timeLabel,
    required this.title,
    required this.description,
    required this.isCompleted,
  });
}
