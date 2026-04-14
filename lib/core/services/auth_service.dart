// ─── auth_service.dart ────────────────────────────────────────────────────────
// Handles all Firebase Authentication operations.
// Provides: email/password sign-up & login, Google Sign-In, sign-out,
//           and authStateChanges stream for listening to auth state.
//
// The Riverpod provider at the bottom exposes this as a singleton.

import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final GoogleSignIn _googleSignIn = GoogleSignIn();

  // ── Stream ─────────────────────────────────────────────────────────────────
  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ── Current user ───────────────────────────────────────────────────────────
  User? get currentUser => _auth.currentUser;

  // ── Email / Password Sign Up ───────────────────────────────────────────────
  Future<UserCredential> signUpWithEmail({
    required String name,
    required String email,
    required String password,
  }) async {
    final credential = await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );

    // Update display name
    await credential.user?.updateDisplayName(name.trim());

    // Create user document in Firestore
    await _createUserDoc(credential.user!, name: name.trim());

    return credential;
  }

  // ── Email / Password Login ─────────────────────────────────────────────────
  Future<UserCredential> loginWithEmail({
    required String email,
    required String password,
  }) async {
    return _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password,
    );
  }

  // ── Google Sign-In ─────────────────────────────────────────────────────────
  Future<UserCredential?> signInWithGoogle() async {
    final googleUser = await _googleSignIn.signIn();
    if (googleUser == null) return null; // user cancelled

    final googleAuth = await googleUser.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    final userCred = await _auth.signInWithCredential(credential);

    // Create user doc if new user
    if (userCred.additionalUserInfo?.isNewUser ?? false) {
      await _createUserDoc(userCred.user!);
    }

    return userCred;
  }

  // ── Password Reset ─────────────────────────────────────────────────────────
  Future<void> sendPasswordReset(String email) async {
    await _auth.sendPasswordResetEmail(email: email.trim());
  }

  // ── Sign Out ───────────────────────────────────────────────────────────────
  Future<void> signOut() async {
    await _googleSignIn.signOut();
    await _auth.signOut();
  }

  // ── Private: create Firestore user document ────────────────────────────────
  Future<void> _createUserDoc(User user, {String? name}) async {
    final ref = _db.collection('users').doc(user.uid);
    final snapshot = await ref.get();

    if (!snapshot.exists) {
      await ref.set({
        'uid': user.uid,
        'email': user.email,
        'name': name ?? user.displayName ?? '',
        'photoUrl': user.photoURL ?? '',
        'createdAt': FieldValue.serverTimestamp(),
        'selectedCareer': null,
        'completedMilestones': [],
        'xpPoints': 0,
        'level': 1,
      });
    }
  }
}

// ── Riverpod provider ──────────────────────────────────────────────────────────
final authServiceProvider = Provider<AuthService>((ref) => AuthService());

final authStateProvider = StreamProvider<User?>((ref) {
  return ref.watch(authServiceProvider).authStateChanges;
});
