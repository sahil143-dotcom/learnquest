# LearnQuest — MVP Codebase

> Gamified career guidance for ambitious students.

## Quick Start

```bash
flutter pub get
flutter run
```

## Project Structure

```
lib/
├── core/
│   ├── theme/
│   │   └── app_theme.dart          ← ALL colors, fonts, button styles
│   └── constants/
│       └── routes.dart             ← ALL route names (never hardcode strings)
│
├── features/
│   ├── onboarding/
│   │   └── onboarding_screen.dart  ← First launch screen with animations
│   │
│   ├── auth/
│   │   └── auth_screen.dart        ← Login + Sign-up with social buttons
│   │
│   ├── domain_select/
│   │   └── domain_select_screen.dart ← Engineering / Law / Business / Creative
│   │
│   └── roadmap/
│       ├── models/
│       │   └── career_model.dart   ← Data shapes (CareerModel, Milestone, etc.)
│       ├── data/
│       │   └── career_data.dart    ← ALL hardcoded career content (edit here!)
│       ├── widgets/
│       │   └── career_bottom_sheet.dart ← ⭐ The reusable bottom sheet
│       └── screens/
│           ├── specialization_screen.dart ← Grid of career cards
│           ├── roadmap_screen.dart         ← Gamified roadmap with levels
│           └── roadmap_loading_screen.dart ← "Generating..." animation
│
├── shared/
│   └── widgets/
│       └── glass_card.dart         ← GlassCard, GradientBackground, ScreenTag
│
└── main.dart                       ← Entry point + all route definitions
```

## User Flow

```
Onboarding → Auth → Domain Select → Specialization
    ↓ (tap career card)
Career Bottom Sheet  →  "Choose this path"
    ↓
Roadmap Loading  →  Roadmap Screen
```

## Adding a new career

1. Open `lib/features/roadmap/data/career_data.dart`
2. Add a new `CareerModel(...)` to `careerList`
3. Done — it appears in the grid and bottom sheet automatically

## Design system

All design tokens live in `lib/core/theme/app_theme.dart`:
- `AppColors` — every color used in the app
- `AppTextStyles` — every text style
- `AppTheme.theme` — the MaterialApp theme

Never hardcode colors or font sizes in widgets — always use these.

## Firebase

See `FIREBASE_SETUP.md` for step-by-step Firebase integration.
