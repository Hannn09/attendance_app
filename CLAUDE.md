# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

This is a Flutter attendance application named "Pinus Attendance" that uses CNN-based face recognition for employee check-in/check-out functionality. The app follows a feature-based folder structure with clean architecture principles.

## Development Commands

### Running the Application
```bash
flutter run                    # Run the app in debug mode
flutter run --release         # Run in release mode
```

### Building
```bash
flutter build apk             # Build Android APK
flutter build ios             # Build iOS app
flutter build web             # Build web version
```

### Testing & Quality
```bash
flutter test                  # Run all tests
flutter analyze               # Run static analysis
flutter test test/widget_test.dart  # Run specific test file
```

### Dependencies
```bash
flutter pub get               # Install dependencies
flutter pub upgrade           # Upgrade dependencies
flutter pub outdated          # Check for outdated dependencies
```

## Architecture

### Directory Structure
```
lib/
├── features/                 # Feature-based modules
│   ├── authentication/      # Login & auth flows
│   └── user/                # User-facing features
│       ├── main/            # Main navigation container with bottom nav
│       ├── home/            # Home screen with attendance summary
│       └── attendance/      # Attendance check-in/out screen
├── utils/
│   ├── routes.dart          # GoRouter configuration
│   └── themes.dart          # Centralized theming (colors, text styles)
├── widget/                  # Shared/reusable widgets
│   └── labeled_text_field.dart
└── main.dart                # App entry point
```

### Key Architectural Patterns

**Routing**: Uses `go_router` for declarative routing. Routes are defined in `lib/utils/routes.dart`:
- `/` - Login screen
- `/home` - Home screen (within StatefulShellRoute for bottom nav)
- `/attendance` - Attendance check-in/out screen

**State Management**: Uses `flutter_riverpod` for state management (currently set up but not extensively implemented in existing screens).

**Navigation**: Bottom navigation is implemented using `StatefulShellRoute.indexedStack` which preserves state between tabs. The `MainUserScreen` wraps the navigation shell and provides the bottom navigation bar.

**Theming**: Centralized in `lib/utils/themes.dart` using Google Fonts (Plus Jakarta Sans). All colors, text styles, and component decorations are defined as constants.

### Key Dependencies
- `go_router: ^17.1.0` - Declarative routing
- `flutter_riverpod: ^3.3.1` - State management
- `dio: ^5.9.2` - HTTP client (likely for future API integration)
- `flutter_secure_storage: ^10.0.0` - Secure storage for tokens/credentials
- `google_fonts: ^8.0.2` - Typography
- `fpdart: ^1.2.0` - Functional programming utilities (Option, Either types)

### Code Conventions
- Uses cascading operators extensively (e.g., `.copyWith()`)
- prefers `EdgeInsetsGeometry` shorthand (e.g., `EdgeInsetsGeometry.symmetric()`)
- Widget builders use private methods with `_build` prefix for organization
- All text styles are sourced from `themes.dart` constants

## Feature Architecture

### Authentication Flow
Located in `lib/features/authentication/presentation/`, currently contains `LoginScreen`. The login screen includes:
- Email and password validation
- Password visibility toggle
- Navigates to `/home` on successful login (currently hardcoded)

### User Features
All user features are under `lib/features/user/`:

**MainUserScreen**: Container for bottom navigation with 3 tabs (Home, History, Profile). Uses `StatefulNavigationShell` to manage tab state.

**HomeScreen**: Displays user profile header, attendance summary card (`CardInformationCheckin`), and monthly statistics. The attendance card has a camera button that navigates to `/attendance`.

**AttendanceScreen**: Standalone screen for check-in/out functionality. Displays current date/time, check-in/out times with a circular action button, and work status cards.

### Shared Components
- `LabeledTextField`: Reusable form field with label, validation, and optional password visibility
- `CardInformationCheckin`: Widget showing today's attendance status with check-in/out times and work hour progress

## Asset Management
Assets are stored in the `assets/` directory and referenced directly in Image.asset() calls. The app uses custom icons for navigation (`ic_home.png`, `ic_history.png`, `ic_profile.png`) and UI elements.
