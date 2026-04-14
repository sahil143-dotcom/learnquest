// ─── user_provider.dart ───────────────────────────────────────────────────────
// Riverpod state for UserProgress. Reads from Firestore on init.

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/user_progress.dart';

class UserProgressNotifier extends StateNotifier<UserProgress> {
  UserProgressNotifier() : super(UserProgress.empty()) {
    _load();
  }

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
        final xp = (data['xpPoints'] as num?)?.toInt() ?? 0;
        final level = (data['level'] as num?)?.toInt() ?? 1;
        final milestones = List<String>.from(data['completedMilestones'] ?? []);
        final groups = List<String>.from(data['joinedGroups'] ?? []);

        state = UserProgress(
          uid: user.uid,
          name: data['name'] as String? ?? user.displayName ?? 'You',
          level: level,
          xp: xp,
          selectedCareer: data['selectedCareer'] as String?,
          completedMilestones: milestones,
          joinedGroups: groups,
        );
      }
    } catch (_) {
      // Offline – keep empty state
    }
  }

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

  Future<void> addXP(int amount) async {
    final uid = FirebaseAuth.instance.currentUser?.uid;
    if (uid == null) return;

    final newXp = state.xp + amount;
    final newLevel = (newXp ~/ 500) + 1;
    state = state.copyWith(xp: newXp, level: newLevel);

    await FirebaseFirestore.instance.collection('users').doc(uid).update({
      'xpPoints': newXp,
      'level': newLevel,
    });
  }
}

final userProgressProvider =
    StateNotifierProvider<UserProgressNotifier, UserProgress>(
  (ref) => UserProgressNotifier(),
);
