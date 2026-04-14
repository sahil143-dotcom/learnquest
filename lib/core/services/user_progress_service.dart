// ─── user_progress_service.dart ───────────────────────────────────────────────
// Reads and writes user career progress to Firestore.
// Structure: users/{uid}/milestones/{careerId}/{milestoneNumber}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class UserProgressService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  String? get _uid => _auth.currentUser?.uid;

  // ── Save selected career ───────────────────────────────────────────────────
  Future<void> saveSelectedCareer(String careerId) async {
    if (_uid == null) return;
    await _db.collection('users').doc(_uid).update({
      'selectedCareer': careerId,
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Mark milestone complete ────────────────────────────────────────────────
  Future<void> completeMilestone(String careerId, int milestoneNumber) async {
    if (_uid == null) return;
    final key = '${careerId}_$milestoneNumber';
    await _db.collection('users').doc(_uid).update({
      'completedMilestones': FieldValue.arrayUnion([key]),
      'xpPoints': FieldValue.increment(100),
      'updatedAt': FieldValue.serverTimestamp(),
    });
  }

  // ── Get user document ──────────────────────────────────────────────────────
  Stream<DocumentSnapshot<Map<String, dynamic>>> get userDocStream {
    if (_uid == null) throw Exception('No user signed in');
    return _db.collection('users').doc(_uid).snapshots();
  }

  // ── Get user data once ─────────────────────────────────────────────────────
  Future<Map<String, dynamic>?> getUserData() async {
    if (_uid == null) return null;
    final doc = await _db.collection('users').doc(_uid).get();
    return doc.data();
  }
}

// ── Riverpod provider ──────────────────────────────────────────────────────────
final userProgressServiceProvider =
    Provider<UserProgressService>((ref) => UserProgressService());
