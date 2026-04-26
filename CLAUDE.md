# BongoCal — Claude Code Instructions

## Project Overview
BongoCal is a premium Bangla Calendar app for Bangladesh. Three calendars 
(Bengali, English, Hijri) unified in one beautifully designed surface, with 
holidays, prayer times, festivals, and personal events.

**Target audience:** Bangladeshi users 18-55, bilingual.
**Quality bar:** Apple-grade premium feel with Bangladeshi soul.

## Architecture: Clean Feature-First

We follow Clean Architecture with feature-first folder organization.

**Sacred rules:**
1. **Never put feature-specific code in /shared or /core**
2. **Each feature has data/domain/presentation layers**
3. **Domain layer never depends on data or presentation**
4. **All async operations return Either<Failure, T>**
5. **All state managed through Riverpod providers**
6. **All widgets in /shared must be feature-agnostic**

## File Naming Conventions
- snake_case for files: `home_page.dart`
- PascalCase for classes: `HomePage`
- camelCase for variables: `currentDate`
- Private members: prefix `_`
- Test files: `*_test.dart`

## Code Style
- Run `dart format .` before committing
- Run `flutter analyze` — zero warnings
- Strict linter rules in analysis_options.yaml
- Comment WHY not WHAT
- Prefer composition over inheritance
- Max function length: 30 lines (extract if longer)

## Design System
**Reference:** /design_system/ folder contains the complete design system.
**Tokens:** All colors, typography, spacing in /lib/shared/theme/
**Never hardcode** colors, sizes, or fonts. Always use theme tokens.

### Color Tokens (CRITICAL):
- `AppColors.primary` = #006A4E (BD flag green)
- `AppColors.accentRed` = #F42A41
- `AppColors.gold` = #D4AF37
- See /lib/shared/theme/colors.dart

### Typography:
- Bangla: Hind Siliguri (Google Fonts)
- English: Inter
- See /lib/shared/theme/typography.dart

## Bangla Language Rules
1. Always use **আপনি** form (polite), never তুমি
2. Sentence case (never ALL CAPS)
3. Bangla numerals (০ ১ ২) when surrounding text is Bangla
4. No emoji in product UI
5. Never machine-translate; both languages first-class
6. Date format Bangla: "১৪ বৈশাখ ১৪৩২"
7. Date format English: "27 April 2026"

## State Management
Use Riverpod 2.x with code generation:
- `@riverpod` annotation for providers
- Run `dart run build_runner watch` during development

## Error Handling Pattern
```dart
Future<Either<Failure, Data>> someOperation() async {
  try {
    final result = await dataSource.fetch();
    return Right(result);
  } on ServerException {
    return Left(ServerFailure());
  }
}
```

## Testing Requirements
- Unit tests for all use cases (domain layer)
- Widget tests for critical UI
- Integration test for happy path
- Min 70% coverage for new code

## Phase Roadmap
**Phase 1 (Current):** Calendar, Holidays, Events, Prayer Times, Weather, Notifications, Widget
**Phase 2:** Ramadan timer, Daily Quote, Tithi, Moon sighting
**Phase 3:** Family sharing, Photo memories, Pro tier

When implementing Phase 2/3, create new feature folder. Don't modify Phase 1 features unless necessary.

## Adding a New Feature (Recipe)
1. Create `/lib/features/feature_name/`
2. Set up data/domain/presentation subfolders
3. Define domain entities and repository interface FIRST
4. Implement data layer (datasource → repository impl)
5. Implement use cases
6. Build presentation (provider → page → widgets)
7. Register route in /lib/app/router.dart
8. Add to bottom nav if needed
9. Write tests in /test/features/feature_name/

## Performance Standards
- App startup < 2 seconds
- Screen transitions < 300ms
- 60fps scrolling
- APK size < 30MB
- Memory usage < 150MB

## Do Not
- ❌ Use BuildContext after async gap
- ❌ Use setState (we use Riverpod)
- ❌ Hardcode strings (use AppLocalizations)
- ❌ Import from another feature directly (use shared layer)
- ❌ Use deprecated APIs
- ❌ Add packages without discussion

## Privacy & Security
- All user data local-first
- No analytics PII
- Firebase only for opt-in features (Phase 2+)
- bKash/SSLCommerz integration only for Pro purchasesss