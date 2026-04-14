# Firebase Setup Guide for LearnQuest

## Step 1 — Create Firebase project

1. Go to https://console.firebase.google.com
2. Click "Add project" → name it "learnquest"
3. Disable Google Analytics (optional for MVP)
4. Click "Create project"

## Step 2 — Add Android app

1. In Firebase Console → click Android icon
2. Package name: `com.learnquest.app`
3. App nickname: LearnQuest
4. Download `google-services.json`
5. Place it at: `android/app/google-services.json`

## Step 3 — FlutterFire CLI (easiest way)

```bash
# Install FlutterFire CLI
dart pub global activate flutterfire_cli

# In your project root:
flutterfire configure --project=YOUR_PROJECT_ID
```

This generates `lib/firebase_options.dart` automatically.

## Step 4 — Uncomment Firebase in main.dart

```dart
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';

// In main():
await Firebase.initializeApp(
  options: DefaultFirebaseOptions.currentPlatform,
);
```

## Step 5 — Enable Auth methods in Firebase Console

1. Go to Authentication → Sign-in method
2. Enable "Email/Password"
3. Enable "Google"

## Step 6 — Wire up auth in auth_screen.dart

Replace the TODO comments with:

```dart
// Email/password sign up
await FirebaseAuth.instance.createUserWithEmailAndPassword(
  email: _emailController.text.trim(),
  password: _passwordController.text,
);

// Google sign in
final googleUser = await GoogleSignIn().signIn();
final googleAuth = await googleUser!.authentication;
final credential = GoogleAuthProvider.credential(
  accessToken: googleAuth.accessToken,
  idToken: googleAuth.idToken,
);
await FirebaseAuth.instance.signInWithCredential(credential);
```

## Step 7 — Save user data to Firestore

After successful auth, save the user's career choice:

```dart
await FirebaseFirestore.instance
    .collection('users')
    .doc(FirebaseAuth.instance.currentUser!.uid)
    .set({
  'careerId': selectedCareerId,
  'createdAt': FieldValue.serverTimestamp(),
});
```

## Firestore data structure

```
users/
  {userId}/
    careerId: "ai"
    createdAt: timestamp
    progress: 15
```
