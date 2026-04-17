// ─── artifact_provider.dart ───────────────────────────────────────────────────
// Tracks which community tab is active and study group join state.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/artifact_models.dart';

// ── Community tab state ───────────────────────────────────────────────────────
enum CommunityTab { leaderboard, discussions, studyGroups, projects }

final communityTabProvider = StateProvider<CommunityTab>(
  (ref) => CommunityTab.leaderboard,
);

// ── Joined groups set ─────────────────────────────────────────────────────────
final joinedGroupsProvider = StateProvider<Set<String>>(
  (ref) => {},
);

// ── Sample data providers (replace with Firestore in production) ───────────────

final leaderboardProvider = Provider<List<LeaderboardEntry>>((ref) => [
      const LeaderboardEntry(
        rank: 1, name: 'Alex Chen', level: 25, xp: 12450,
        avatarColor: '#FF9500', badge: '👑', streakDays: 42,
      ),
      const LeaderboardEntry(
        rank: 2, name: 'Sarah Johnson', level: 23, xp: 11200,
        avatarColor: '#8E8E93', streakDays: 30,
      ),
      const LeaderboardEntry(
        rank: 3, name: 'Mike Davis', level: 21, xp: 10100,
        avatarColor: '#A2845E', streakDays: 21,
      ),
      const LeaderboardEntry(
        rank: 4, name: 'You', level: 5, xp: 720,
        avatarColor: '#6C63FF', isCurrentUser: true, streakDays: 7,
      ),
      const LeaderboardEntry(
        rank: 5, name: 'Emma Wilson', level: 4, xp: 650,
        avatarColor: '#34C759', streakDays: 5,
      ),
      const LeaderboardEntry(
        rank: 6, name: 'Rahul Sharma', level: 4, xp: 580,
        avatarColor: '#FF3B30', streakDays: 3,
      ),
      const LeaderboardEntry(
        rank: 7, name: 'Priya Mehta', level: 3, xp: 420,
        avatarColor: '#5856D6', streakDays: 1,
      ),
    ]);

final discussionsProvider = Provider<List<DiscussionPost>>((ref) => [
      const DiscussionPost(
        id: 'd1',
        authorName: 'Arjun Kumar',
        authorEmoji: '🧑',
        timeAgo: '2 hours ago',
        title: 'How do you approach complexity analysis?',
        preview:
            'I\'m struggling to understand Big O notation intuitively. Does anyone have a good mental model for thinking about it?',
        replies: 12,
        likes: 34,
        isPinned: true,
      ),
      const DiscussionPost(
        id: 'd2',
        authorName: 'Nina Gupta',
        authorEmoji: '👩',
        timeAgo: '4 hours ago',
        title: 'Best resources for learning DSA?',
        preview:
            'I\'d like to recommend some resources that really helped me understand data structures. LeetCode has been great for practice...',
        replies: 28,
        likes: 89,
      ),
      const DiscussionPost(
        id: 'd3',
        authorName: 'Ravi Singh',
        authorEmoji: '🧔',
        timeAgo: '1 day ago',
        title: 'Interview prep tips for big tech companies',
        preview:
            'After getting offers from Google and Amazon, here are the things that helped me prepare...',
        replies: 45,
        likes: 156,
        tag: 'HOT',
      ),
      const DiscussionPost(
        id: 'd4',
        authorName: 'Pooja Nair',
        authorEmoji: '👩‍💻',
        timeAgo: '2 days ago',
        title: 'System Design resources for beginners',
        preview:
            'Starting system design from scratch? Here is a curated list of what actually worked for me...',
        replies: 19,
        likes: 67,
        tag: 'NEW',
      ),
    ]);

final studyGroupsProvider = Provider<List<StudyGroup>>((ref) => [
      const StudyGroup(
        id: 'g1',
        emoji: '🐍',
        name: 'Python Fundamentals',
        members: 142,
        description: 'Learn Python basics together. Active discussions and code reviews.',
        lastActive: '30 min ago',
        memberAvatarColors: ['#6C63FF', '#34C759', '#FF9500', '#FF3B30'],
      ),
      const StudyGroup(
        id: 'g2',
        emoji: '📊',
        name: 'DSA Mastery',
        members: 89,
        description: 'Master data structures and algorithms together. Daily coding challenges.',
        lastActive: '5 min ago',
        memberAvatarColors: ['#FF6B6B', '#4ECDC4', '#45B7D1', '#96CEB4'],
      ),
      const StudyGroup(
        id: 'g3',
        emoji: '⚛️',
        name: 'React & Frontend',
        members: 215,
        description: 'Build modern UIs with React. Weekly project showcases.',
        lastActive: '1 hour ago',
        memberAvatarColors: ['#A29BFE', '#FD79A8', '#6C5CE7', '#00B894'],
      ),
      const StudyGroup(
        id: 'g4',
        emoji: '☁️',
        name: 'Cloud & DevOps',
        members: 67,
        description: 'AWS, Docker, Kubernetes. Real-world infrastructure practice.',
        lastActive: '2 hours ago',
        memberAvatarColors: ['#0984E3', '#00CEC9', '#FDCB6E', '#E17055'],
      ),
    ]);

final projectsProvider = Provider<List<CommunityProject>>((ref) => [
      const CommunityProject(
        id: 'p1',
        emoji: '🎮',
        title: 'Mini Game Engine',
        description: 'Building a simple 2D game engine from scratch using Python. Learn OOP and game development basics.',
        progress: 0.65,
        isCompleted: false,
        memberColors: ['#FFCC00', '#FF6B6B', '#6C63FF', '#34C759'],
      ),
      const CommunityProject(
        id: 'p2',
        emoji: '💬',
        title: 'Chat Application',
        description: 'Real-time chat built with Socket.io and Express. Learned WebSockets and real-time communication.',
        progress: 1.0,
        isCompleted: true,
        memberColors: ['#6C63FF', '#FF9500', '#34C759'],
      ),
      const CommunityProject(
        id: 'p3',
        emoji: '🛒',
        title: 'E-Commerce Platform',
        description: 'Full-stack store with React, Node.js, and MongoDB. Payment gateway integration in progress.',
        progress: 0.40,
        isCompleted: false,
        memberColors: ['#FF3B30', '#5856D6', '#A2845E'],
      ),
    ]);

final activityProvider = Provider<List<ActivityEntry>>((ref) => [
      const ActivityEntry(
        timeLabel: '2 days ago',
        title: 'Started Python Basics',
        description: 'Learned about variables and data types. Completed first 2 concepts.',
        isCompleted: true,
      ),
      const ActivityEntry(
        timeLabel: 'Today, 10:30 AM',
        title: 'Mastered Data Structures',
        description: 'Learned lists, tuples, and dictionaries. Scored 95% on quiz.',
        isCompleted: true,
      ),
      const ActivityEntry(
        timeLabel: 'Today, 2:00 PM',
        title: 'Learning Control Flow',
        description: 'Currently working on if/elif/else and loops. 45% progress.',
        isCompleted: false,
      ),
    ]);
