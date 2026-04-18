// ─── community_screen.dart ────────────────────────────────────────────────────
// Community Learning Hub — pure Flutter, matches the reference images exactly.
// Tabs: Leaderboard | Discussions | Study Groups | Projects

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/artifact_models.dart';
import '../providers/artifact_provider.dart';
import '../providers/user_provider.dart';

class CommunityScreen extends ConsumerStatefulWidget {
  final VoidCallback? onBack;
  const CommunityScreen({super.key, this.onBack});

  @override
  ConsumerState<CommunityScreen> createState() => _CommunityScreenState();
}

class _CommunityScreenState extends ConsumerState<CommunityScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;

  final _tabs = const [
    _TabItem(icon: '🏆', label: 'Leaderboard'),
    _TabItem(icon: '💬', label: 'Discussions'),
    _TabItem(icon: '👥', label: 'Study\nGroups'),
    _TabItem(icon: '🚀', label: 'Projects'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _tabController.addListener(() {
      final map = [
        CommunityTab.leaderboard,
        CommunityTab.discussions,
        CommunityTab.studyGroups,
        CommunityTab.projects,
      ];
      ref.read(communityTabProvider.notifier).state =
          map[_tabController.index];
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF4F6FF),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── Header ────────────────────────────────────────────────────
            Container(
              color: Colors.white,
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Back + title row
                  Row(
                    children: [
                      GestureDetector(
                        onTap: () => widget.onBack != null ? widget.onBack!() : Navigator.pop(context),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F6FF),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: const Icon(Icons.arrow_back_ios_new_rounded,
                              size: 16, color: Color(0xFF2D3748)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      const _HubLogo(),
                      const SizedBox(width: 10),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Community Learning Hub',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF2D3748),
                            ),
                          ),
                          Text(
                            'Connect, collaborate, and grow',
                            style: TextStyle(
                              fontSize: 11,
                              color: Colors.grey[600],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),

                  // ── Tab bar ─────────────────────────────────────────────
                  TabBar(
                    controller: _tabController,
                    isScrollable: false,
                    indicatorColor: const Color(0xFF6C63FF),
                    indicatorWeight: 2.5,
                    labelColor: const Color(0xFF6C63FF),
                    unselectedLabelColor: Colors.grey[500],
                    labelPadding: EdgeInsets.zero,
                    tabs: _tabs
                        .map((t) => Tab(
                              height: 52,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(t.icon,
                                      style: const TextStyle(fontSize: 18)),
                                  const SizedBox(height: 2),
                                  Text(
                                    t.label,
                                    textAlign: TextAlign.center,
                                    style: const TextStyle(
                                        fontSize: 10,
                                        fontWeight: FontWeight.w600),
                                  ),
                                ],
                              ),
                            ))
                        .toList(),
                  ),
                ],
              ),
            ),

            // ── Tab content ───────────────────────────────────────────────
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _LeaderboardTab(),
                  _DiscussionsTab(),
                  _StudyGroupsTab(),
                  _ProjectsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Tab data ─────────────────────────────────────────────────────────────────
class _TabItem {
  final String icon;
  final String label;
  const _TabItem({required this.icon, required this.label});
}

// ─── Hub logo ─────────────────────────────────────────────────────────────────
class _HubLogo extends StatelessWidget {
  const _HubLogo();

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [Color(0xFF6C63FF), Color(0xFF4ECDC4)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// LEADERBOARD TAB
// ═══════════════════════════════════════════════════════════════════════════════
class _LeaderboardTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final entries = ref.watch(leaderboardProvider);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 8,
                  offset: const Offset(0, 2)),
            ],
          ),
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Global Ranking',
                style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF2D3748)),
              ),
              const SizedBox(height: 8),
              ...entries.map((e) => _RankRow(entry: e)),
            ],
          ),
        ),
      ],
    );
  }
}

class _RankRow extends StatelessWidget {
  final LeaderboardEntry entry;
  const _RankRow({required this.entry});

  Color _rankColor(int rank) {
    switch (rank) {
      case 1: return const Color(0xFFFF9500);
      case 2: return const Color(0xFF8E8E93);
      case 3: return const Color(0xFFA2845E);
      default: return const Color(0xFF6C63FF);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isYou = entry.isCurrentUser;
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 4),
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: isYou
            ? const Color(0xFF6C63FF).withOpacity(0.06)
            : Colors.transparent,
        borderRadius: BorderRadius.circular(10),
        border: isYou
            ? Border.all(
                color: const Color(0xFF6C63FF).withOpacity(0.2))
            : null,
      ),
      child: Row(
        children: [
          // Rank
          SizedBox(
            width: 22,
            child: Text(
              '${entry.rank}',
              style: TextStyle(
                fontWeight: FontWeight.w700,
                fontSize: 13,
                color: _rankColor(entry.rank),
              ),
            ),
          ),
          // Avatar
          Container(
            width: 36,
            height: 36,
            margin: const EdgeInsets.only(right: 10),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: _hexColor(entry.avatarColor),
            ),
            child: Center(
              child: Text(
                entry.name[0],
                style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 14),
              ),
            ),
          ),
          // Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Flexible(
                      child: Text(
                        isYou ? 'You (${entry.name})' : entry.name,
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                          color: isYou
                              ? const Color(0xFF6C63FF)
                              : const Color(0xFF2D3748),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    if (entry.badge != null) ...[
                      const SizedBox(width: 4),
                      Text(entry.badge!),
                    ],
                  ],
                ),
                Text(
                  'Level ${entry.level} • ${entry.xp} XP',
                  style: TextStyle(fontSize: 11, color: Colors.grey[500]),
                ),
              ],
            ),
          ),
          // XP
          Text(
            entry.xp >= 1000
                ? '${(entry.xp / 1000).toStringAsFixed(1)}K'
                : '${entry.xp}',
            style: TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: isYou
                  ? const Color(0xFF6C63FF)
                  : const Color(0xFF2D3748),
            ),
          ),
        ],
      ),
    );
  }

  Color _hexColor(String hex) {
    try {
      return Color(int.parse(hex.replaceFirst('#', '0xFF')));
    } catch (_) {
      return const Color(0xFF6C63FF);
    }
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// DISCUSSIONS TAB
// ═══════════════════════════════════════════════════════════════════════════════
class _DiscussionsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final posts = ref.watch(discussionsProvider);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: posts.map((p) => _PostCard(post: p)).toList(),
    );
  }
}

class _PostCard extends StatelessWidget {
  final DiscussionPost post;
  const _PostCard({required this.post});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 6,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Author row
          Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: const BoxDecoration(
                  shape: BoxShape.circle,
                  color: Color(0xFF6C63FF),
                ),
                child: Center(
                  child: Text(post.authorEmoji,
                      style: const TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(post.authorName,
                        style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                            color: Color(0xFF2D3748))),
                    Text(post.timeAgo,
                        style: TextStyle(fontSize: 11, color: Colors.grey[500])),
                  ],
                ),
              ),
              if (post.tag != null)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                  decoration: BoxDecoration(
                    color: post.tag == 'HOT'
                        ? const Color(0xFFFFF3E0)
                        : const Color(0xFFE8F5E9),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    post.tag!,
                    style: TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w700,
                      color: post.tag == 'HOT'
                          ? const Color(0xFFE65100)
                          : const Color(0xFF2E7D32),
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 10),
          Text(post.title,
              style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: Color(0xFF1A202C))),
          const SizedBox(height: 4),
          Text(post.preview,
              style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.5),
              maxLines: 3,
              overflow: TextOverflow.ellipsis),
          const SizedBox(height: 10),
          // Stats row
          Row(
            children: [
              _StatChip(icon: '💬', label: '${post.replies} replies'),
              const SizedBox(width: 12),
              _StatChip(icon: '❤️', label: '${post.likes} likes'),
              if (post.isPinned) ...[
                const SizedBox(width: 12),
                _StatChip(icon: '📌', label: 'Pinned'),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Case 3: Mini streak badge for Leaderboard rows ──────────────────────────
// A compact 🔥 + number pill that appears inline next to the user's name.
// Signals social status — high streak = dedicated learner.

class _MiniStreakBadge extends StatelessWidget {
  final int days;
  const _MiniStreakBadge({required this.days});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFE8593C).withOpacity(0.10),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFFE8593C).withOpacity(0.22),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Text('🔥', style: TextStyle(fontSize: 9)),
          const SizedBox(width: 2),
          Text(
            '$days',
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w700,
              color: Color(0xFFE8593C),
            ),
          ),
        ],
      ),
    );
  }
}

class _StatChip extends StatelessWidget {
  final String icon;
  final String label;
  const _StatChip({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Text(icon, style: const TextStyle(fontSize: 12)),
        const SizedBox(width: 4),
        Text(label,
            style: TextStyle(fontSize: 11, color: Colors.grey[600])),
      ],
    );
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// STUDY GROUPS TAB
// ═══════════════════════════════════════════════════════════════════════════════
class _StudyGroupsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final groups = ref.watch(studyGroupsProvider);
    final userProgress = ref.watch(userProgressProvider);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: groups
          .map((g) => _GroupCard(
                group: g,
                isJoined: userProgress.joinedGroups.contains(g.id),
              ))
          .toList(),
    );
  }
}

class _GroupCard extends ConsumerWidget {
  final StudyGroup group;
  final bool isJoined;
  const _GroupCard({required this.group, required this.isJoined});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: isJoined
            ? Border.all(color: const Color(0xFF6C63FF).withOpacity(0.3))
            : null,
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Title row
          Row(
            children: [
              Text(group.emoji,
                  style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(group.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xFF2D3748))),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF4F6FF),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '${group.members} members',
                  style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF6C63FF)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(group.description,
              style: TextStyle(fontSize: 12, color: Colors.grey[600], height: 1.5)),
          const SizedBox(height: 10),
          // Avatar row
          Row(
            children: [
              ..._buildAvatars(group.memberAvatarColors, group.members),
              const Spacer(),
              Text('Last active: ${group.lastActive}',
                  style: TextStyle(fontSize: 11, color: Colors.grey[500])),
            ],
          ),
          const SizedBox(height: 12),
          // Join button
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                ref.read(userProgressProvider.notifier).toggleGroup(group.id);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: isJoined
                    ? const Color(0xFF6C63FF)
                    : const Color(0xFF6C63FF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10)),
                elevation: 0,
              ),
              child: Text(
                isJoined ? '✓ Joined' : 'Join Group',
                style: const TextStyle(
                    fontWeight: FontWeight.w700, fontSize: 13),
              ),
            ),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAvatars(List<String> colors, int total) {
    final show = colors.take(4).toList();
    final extra = total - show.length;
    return [
      ...show.map((c) {
        Color col;
        try {
          col = Color(int.parse(c.replaceFirst('#', '0xFF')));
        } catch (_) {
          col = const Color(0xFF6C63FF);
        }
        return Container(
          width: 28,
          height: 28,
          margin: const EdgeInsets.only(right: 4),
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: col,
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          child: Center(
            child: Text(
              _letter(c),
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 11,
                  fontWeight: FontWeight.w700),
            ),
          ),
        );
      }),
      if (extra > 0)
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: const Color(0xFF6C63FF),
            border: Border.all(color: Colors.white, width: 1.5),
          ),
          child: Center(
            child: Text(
              '+$extra',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 9,
                  fontWeight: FontWeight.w700),
            ),
          ),
        ),
    ];
  }

  String _letter(String hex) {
    // Use first char of hex as an avatar initial placeholder
    final letters = ['A', 'S', 'M', 'P', 'J', 'K', 'R'];
    return letters[hex.hashCode.abs() % letters.length];
  }
}

// ═══════════════════════════════════════════════════════════════════════════════
// PROJECTS TAB
// ═══════════════════════════════════════════════════════════════════════════════
class _ProjectsTab extends ConsumerWidget {
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final projects = ref.watch(projectsProvider);
    final activity = ref.watch(activityProvider);
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        ...projects.map((p) => _ProjectCard(project: p)),
        const SizedBox(height: 16),
        const Text(
          'Your Activity',
          style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: Color(0xFF2D3748)),
        ),
        const SizedBox(height: 12),
        _ActivityTimeline(entries: activity),
      ],
    );
  }
}

class _ProjectCard extends StatelessWidget {
  final CommunityProject project;
  const _ProjectCard({required this.project});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 8,
              offset: const Offset(0, 2)),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Status badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: project.isCompleted
                  ? const Color(0xFFE8F5E9)
                  : const Color(0xFFE3F2FD),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              project.isCompleted ? 'COMPLETED' : 'IN PROGRESS',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: project.isCompleted
                    ? const Color(0xFF2E7D32)
                    : const Color(0xFF1565C0),
              ),
            ),
          ),
          const SizedBox(height: 10),
          Row(
            children: [
              Text(project.emoji,
                  style: const TextStyle(fontSize: 22)),
              const SizedBox(width: 8),
              Expanded(
                child: Text(project.title,
                    style: const TextStyle(
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                        color: Color(0xFF1A202C))),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Text(project.description,
              style: TextStyle(
                  fontSize: 12, color: Colors.grey[600], height: 1.5)),
          if (!project.isCompleted) ...[
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Progress',
                    style: TextStyle(fontSize: 12, color: Color(0xFF4A5568))),
                Text(
                  '${(project.progress * 100).round()}%',
                  style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF6C63FF)),
                ),
              ],
            ),
            const SizedBox(height: 6),
            ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: LinearProgressIndicator(
                value: project.progress,
                minHeight: 7,
                backgroundColor: const Color(0xFFF4F6FF),
                valueColor: const AlwaysStoppedAnimation(Color(0xFF6C63FF)),
              ),
            ),
          ],
          const SizedBox(height: 10),
          // Member dots
          Row(
            children: _buildAvatars(project.memberColors),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildAvatars(List<String> colors) {
    return colors.map((c) {
      Color col;
      try {
        col = Color(int.parse(c.replaceFirst('#', '0xFF')));
      } catch (_) {
        col = const Color(0xFF6C63FF);
      }
      return Container(
        width: 26,
        height: 26,
        margin: const EdgeInsets.only(right: 4),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: col,
          border: Border.all(color: Colors.white, width: 1.5),
        ),
      );
    }).toList();
  }
}

// ─── Activity Timeline ────────────────────────────────────────────────────────
class _ActivityTimeline extends StatelessWidget {
  final List<ActivityEntry> entries;
  const _ActivityTimeline({required this.entries});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: entries.asMap().entries.map((e) {
        final i = e.key;
        final entry = e.value;
        final isLast = i == entries.length - 1;
        return _TimelineItem(
            entry: entry, isLast: isLast);
      }).toList(),
    );
  }
}

class _TimelineItem extends StatelessWidget {
  final ActivityEntry entry;
  final bool isLast;
  const _TimelineItem({required this.entry, required this.isLast});

  @override
  Widget build(BuildContext context) {
    const dotColor = Color(0xFF6C63FF);
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline line + dot
          SizedBox(
            width: 24,
            child: Column(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  margin: const EdgeInsets.only(top: 4),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: entry.isCompleted
                        ? dotColor
                        : Colors.transparent,
                    border: Border.all(
                        color: dotColor,
                        width: entry.isCompleted ? 0 : 2),
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      margin: const EdgeInsets.symmetric(vertical: 2),
                      decoration: const BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [dotColor, Color(0xFFB8C0FF)],
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 12),
          // Content card
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                      color: Colors.black.withOpacity(0.04),
                      blurRadius: 6,
                      offset: const Offset(0, 2)),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    entry.timeLabel,
                    style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF6C63FF)),
                  ),
                  const SizedBox(height: 4),
                  Text(entry.title,
                      style: const TextStyle(
                          fontWeight: FontWeight.w700,
                          fontSize: 13,
                          color: Color(0xFF2D3748))),
                  const SizedBox(height: 3),
                  Text(entry.description,
                      style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey[600],
                          height: 1.4)),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
