// ─── main.dart ────────────────────────────────────────────────────────────────
// App entry point.  Firebase is initialised here before runApp.
// Riverpod wraps the entire widget tree via ProviderScope.

import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/firebase_options.dart';
import 'core/theme/app_theme.dart';
import 'core/constants/routes.dart';
import 'features/onboarding/onboarding_screen.dart';
import 'features/auth/auth_screen.dart';
import 'features/domain_select/domain_select_screen.dart';
import 'features/roadmap/screens/specialization_screen.dart';
import 'features/roadmap/screens/roadmap_screen.dart';
import 'artifacts/artifact_screen.dart';
import 'models/artifact_models.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ── Firebase init ──────────────────────────────────────────────────────────
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // ── Check onboarding state ─────────────────────────────────────────────────
  final prefs = await SharedPreferences.getInstance();
  final onboardingDone = prefs.getBool('onboarding_done') ?? false;

  runApp(
    // Riverpod scope wraps everything
    ProviderScope(
      child: LearnQuestApp(
        startRoute: onboardingDone ? AppRoutes.login : AppRoutes.onboarding,
      ),
    ),
  );
}

class LearnQuestApp extends StatelessWidget {
  final String startRoute;
  const LearnQuestApp({super.key, required this.startRoute});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LearnQuest',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.theme,
      initialRoute: startRoute,

      // ── Named routes ────────────────────────────────────────────────────────
      onGenerateRoute: (settings) {
        Widget page;

        switch (settings.name) {
          case AppRoutes.onboarding:
            page = const OnboardingScreen();
          case AppRoutes.login:
            page = const AuthScreen();
          case AppRoutes.domainSelect:
            page = const DomainSelectScreen();
          case AppRoutes.specialization:
            page = const SpecializationScreen();
          case AppRoutes.roadmapLoading:
            page = const RoadmapLoadingScreen();
          case AppRoutes.roadmap:
            page = const RoadmapScreen();
          case AppRoutes.artifacts:
            final initialArtifact = settings.arguments is ArtifactType
                ? settings.arguments as ArtifactType
                : ArtifactType.dashboard;
            page = ArtifactScreen(initialArtifact: initialArtifact);
          default:
            page = const OnboardingScreen();
        }

        return PageRouteBuilder(
          settings: settings,
          pageBuilder: (_, __, ___) => page,
          transitionsBuilder: (_, animation, __, child) {
            return SlideTransition(
              position: Tween<Offset>(
                begin: const Offset(1.0, 0.0),
                end: Offset.zero,
              ).animate(CurvedAnimation(
                parent: animation,
                curve: Curves.easeOutCubic,
              )),
              child: FadeTransition(opacity: animation, child: child),
            );
          },
          transitionDuration: const Duration(milliseconds: 350),
        );
      },
    );
  }
}
