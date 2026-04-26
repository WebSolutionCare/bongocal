# BongoCal

> তিন ক্যালেন্ডার, এক জায়গায় — *Three calendars, one place.*

A premium Bangla calendar for Bangladesh. Bengali (বঙ্গাব্দ), Gregorian, and
Hijri unified in one beautifully designed surface, with first-class support
for Bangladeshi holidays, prayer times, festivals, and personal events.

## Project status

**Phase 1 — Foundation in progress.** This commit lays down the project
skeleton: design tokens, core infrastructure, shared widgets, routing, and a
placeholder home screen that verifies the theme/font wiring. Feature
implementations land in subsequent PRs.

See `CLAUDE.md` for the architecture rules and `design_system/` for the
visual spec (the canonical source for tokens is
`design_system/colors_and_type.css`).

## Prerequisites

- Flutter `>=3.22.0` (Dart `>=3.4.0`) — install via [flutter.dev](https://docs.flutter.dev/get-started/install)
- Xcode (iOS) and/or Android Studio (Android) for device targets
- A working `flutter doctor`

## Getting started

```bash
# 1. Install dependencies
flutter pub get

# 2. (When generated providers are added) run code generation in watch mode
dart run build_runner watch --delete-conflicting-outputs

# 3. Run the app
flutter run
```

You should see the splash placeholder, then the home screen showing
**BongoCal** in Bangladesh-flag emerald (`#006A4E`) with **Hind Siliguri**
for Bangla and **Inter** for Latin.

## Verification

```bash
flutter pub get          # resolves all Phase 1 deps
flutter analyze          # must report 0 issues
flutter test             # runs widget + utility tests
flutter run              # opens placeholder home
```

> **Note:** Because Flutter is not installed in the environment that scaffolded
> this project, the commands above need to be run on a workstation with the
> Flutter SDK on `PATH`.

## Project structure

```
lib/
├── app/                    # Root: app.dart, router.dart
├── core/                   # Cross-feature primitives
│   ├── constants/          # App-wide constants
│   ├── errors/             # Failure + Exception types
│   ├── storage/            # HiveService wrapper
│   ├── notifications/      # Local notifications scaffolding
│   └── utils/              # bangla_numerals, date_extensions
├── shared/                 # Feature-agnostic UI building blocks
│   ├── theme/              # Design tokens (colors, type, spacing, …)
│   ├── widgets/            # AppButton, AppCard, DateCell, BottomNav
│   └── extensions/
└── features/               # Feature-first slices (data / domain / presentation)
    ├── calendar/
    ├── holidays/
    ├── events/
    ├── prayer_times/
    ├── weather/
    ├── notifications/
    ├── settings/
    └── widget_home/
assets/
├── icons/  images/  data/  fonts/
test/                       # Mirrors lib/
design_system/              # Visual spec, HTML targets, CSS tokens
```

### Architecture rules (sacred)

1. Never put feature-specific code in `/shared` or `/core`.
2. Each feature owns `data/`, `domain/`, `presentation/` layers.
3. Domain layer never depends on data or presentation.
4. All async operations return `Either<Failure, T>` (`dartz`).
5. All state is managed through Riverpod providers.
6. All widgets in `/shared` are feature-agnostic.

See `CLAUDE.md` for the long-form rules and the *Adding a New Feature*
recipe.

## Design tokens

All visual tokens live under `lib/shared/theme/`:

| File             | What's inside                                   |
|------------------|-------------------------------------------------|
| `colors.dart`    | Brand, neutral, semantic, festival; light/dark roles via `AppColorRoles` |
| `typography.dart`| Hind Siliguri (Bangla) + Inter (Latin) text styles per scale |
| `spacing.dart`   | 4 / 8 / 12 / 16 / 24 / 32 / 48 / 64 + layout helpers |
| `radii.dart`     | 4 / 8 / 12 / 16 / 20 / 999 + `BorderRadius` constants |
| `shadows.dart`   | Warm-tinted xs / sm / md / lg, light + dark variants |
| `app_theme.dart` | Material 3 `ThemeData` for light + dark         |

**Never hardcode** colors, sizes, or fonts in feature code. Always pull from
`AppColors`, `AppTypography`, `AppSpacing`, `AppRadii`, `AppShadows`, or the
`AppColorRoles` theme extension.

## Bangla language rules

1. Always use **আপনি** form, never **তুমি**.
2. Sentence case — never ALL CAPS.
3. Bangla numerals (০ ১ ২) when surrounding text is Bangla — use
   `BanglaNumerals.fromInt(...)` from `core/utils/bangla_numerals.dart`.
4. No emoji in product UI.
5. Bengali date format: `১৪ বৈশাখ ১৪৩২`. English: `27 April 2026`. Hijri:
   `৯ যিলক্বদ ১৪৪৭`. Helpers in `core/utils/date_extensions.dart`.

## Phase roadmap

- **Phase 1** *(current)* — Calendar, Holidays, Events, Prayer Times, Weather,
  Notifications, Home Widget.
- **Phase 2** — Ramadan timer, Daily Quote, Tithi, Moon sighting.
- **Phase 3** — Family sharing, Photo memories, Pro tier.

When implementing Phase 2 / 3, create a new feature folder. Don't modify
Phase 1 features unless necessary.
