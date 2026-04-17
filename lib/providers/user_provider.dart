// ─── user_provider.dart ───────────────────────────────────────────────────────
// Riverpod state for UserProgress. Reads from Firestore on init.
// Also manages daily streak logic — called automatically on every app open.

import 'dart:math';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_progress.dart';

class UserProgressNotifier extends StateNotifier<UserProgress> {
  UserProgressNotifier() : super(UserProgress.empty()) {
    _load();
  }

  // ── Load from Firestore ────────────────────────────────────────────────────
  Future<void> _load() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) return;

    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (doc.exists) {
        final data = doc.data()!;

        final xp       = (data['xpPoints'] as num?)?.toInt() ?? 0;
        final level    = (data['level'] as num?)?.toInt() ?? 1;
        final milestones = List<String>.from(data['completedMilestones'] ?? []);
        final groups   = List<String>.from(data['joinedGroups'] ?? []);

        // ── Streak fields ──────────────────────────────────────────────────
        final streakDays    = (data['streakDays'] as num?)?.toInt() ?? 0;
        final longestStreak = (data['longestStreak'] as num?)?.toInt() ?? 0;
        DateTime? lastActivityDate;
        final ts = data['lastActivityDate'];
        if (ts is Timestamp) lastActivityDate = ts.toDate();

        state = UserProgress(
          uid: user.uid,
          name: data['name'] as String? ?? user.displayName ?? 'You',
          level: level,
          xp: xp,
          selectedCareer: data['selectedCareer'] as String?,
          completedMilestones: milestones,
          joinedGroups: groups,
          streakDays: streakDays,
          lastActivityDate: lastActivityDate,
          longestStreak: longestStreak,
        );

        // Always recalculate streak on app open
        await _updateStreak();
      }
    } catch (_) {
      // Offline – keep empty state
    }
  }

  // ── Daily streak logic ─────────────────────────────────────────────────────
  // Called every time the app loads. Handles three cases:
  //   • First ever open  → streak = 1
  //   • Opened yesterday → streak++  (consecutive day)
  //   • Missed a day     → streak resets to 1
  //   • Opened today already → no change (idempotent)
  Future<void> _updateStreak() async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final now   = DateTime.now();
    final today = DateTime(now.year, now.month, now.day); // midnight-normalised

    final lastDate = state.lastActivityDate;

    int newStreak    = state.streakDays;
    int newLongest   = state.longestStreak;
    bool shouldWrite = false;

    if (lastDate == null) {
      // ── First time ever ──────────────────────────────────────────────────
      newStreak  = 1;
      newLongest = 1;
      shouldWrite = true;
    } else {
      final lastDay = DateTime(lastDate.year, lastDate.month, lastDate.day);
      final diff    = today.difference(lastDay).inDays;

      if (diff == 0) {
        // Already counted today — nothing to do
        return;
      } else if (diff == 1) {
        // ── Consecutive day  ─────────────────────────────────────────────
        newStreak   = state.streakDays + 1;
        newLongest  = max(newStreak, state.longestStreak);
        shouldWrite = true;
      } else {
        // ── Streak broken  ───────────────────────────────────────────────
        newStreak   = 1;   // reset to 1 (today counts)
        shouldWrite = true;
      }
    }

    if (!shouldWrite) return;

    // Update local state immediately so UI reacts
    state = state.copyWith(
      streakDays: newStreak,
      lastActivityDate: today,
      longestStreak: newLongest,
    );

    // Persist to Firestore
    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'streakDays':        newStreak,
      'lastActivityDate':  Timestamp.fromDate(today),
      'longestStreak':     newLongest,
    });
  }

  // ── XP ─────────────────────────────────────────────────────────────────────
  Future<void> addXP(int amount) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final newXp    = state.xp + amount;
    final newLevel = (newXp ~/ 500) + 1;
    state = state.copyWith(xp: newXp, level: newLevel);

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'xpPoints': newXp,
      'level':    newLevel,
    });
  }

  // ── Study groups ───────────────────────────────────────────────────────────
  Future<void> toggleGroup(String groupId) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final joined = List<String>.from(state.joinedGroups);
    if (joined.contains(groupId)) {
      joined.remove(groupId);
    } else {
      joined.add(groupId);
    }
    state = state.copyWith(joinedGroups: joined);

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'joinedGroups': joined,
    });
  }
}

final userProgressProvider =
    StateNotifierProvider<UserProgressNotifier, UserProgress>(
  (ref) => UserProgressNotifier(),
);
