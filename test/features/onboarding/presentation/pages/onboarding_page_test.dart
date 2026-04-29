import 'package:bongocal/features/onboarding/presentation/pages/onboarding_page.dart';
import 'package:bongocal/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:bongocal/features/settings/domain/entities/primary_calendar_preference.dart';
import 'package:bongocal/features/settings/domain/repositories/settings_repository.dart';
import 'package:bongocal/features/settings/presentation/providers/settings_provider.dart';
import 'package:bongocal/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';

import '../../../settings/_fakes/fake_settings_repository.dart';
import '../../_fakes/fake_onboarding_repository.dart';

Future<void> _pumpOnboarding(
  WidgetTester tester, {
  required FakeOnboardingRepository onboardingRepo,
  required SettingsRepository settingsRepo,
}) async {
  await tester.binding.setSurfaceSize(const Size(414, 1200));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  // Wrap in a real GoRouter so `context.go('/home')` from `_complete` has
  // a valid target. The /home route is intentionally minimal — we only
  // need a destination for navigation, not its full UI.
  final GoRouter router = GoRouter(
    initialLocation: '/onboarding',
    routes: <RouteBase>[
      GoRoute(
        path: '/onboarding',
        builder: (BuildContext _, GoRouterState __) => const OnboardingPage(),
      ),
      GoRoute(
        path: '/home',
        builder: (BuildContext _, GoRouterState __) =>
            const Scaffold(body: Center(child: Text('STUB_HOME'))),
      ),
    ],
  );

  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        onboardingRepositoryProvider.overrideWithValue(onboardingRepo),
        settingsRepositoryProvider.overrideWithValue(settingsRepo),
      ],
      child: MaterialApp.router(
        theme: AppTheme.light(),
        debugShowCheckedModeBanner: false,
        routerConfig: router,
      ),
    ),
  );
  for (int i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  late FakeSettingsRepository settingsRepo;

  setUp(() {
    settingsRepo = FakeSettingsRepository();
  });

  tearDown(() async {
    await settingsRepo.dispose();
  });

  testWidgets('renders the welcome screen first', (WidgetTester tester) async {
    await _pumpOnboarding(
      tester,
      onboardingRepo: FakeOnboardingRepository(),
      settingsRepo: settingsRepo,
    );

    expect(find.text('শুরু করুন'), findsOneWidget);
    expect(find.text('এড়িয়ে যান'), findsOneWidget);
    // Welcome heading uses Text.rich with `স্বাগতম BongoCal-এ`.
    expect(find.textContaining('স্বাগতম'), findsOneWidget);
  });

  testWidgets('Skip jumps to the permission screen',
      (WidgetTester tester) async {
    await _pumpOnboarding(
      tester,
      onboardingRepo: FakeOnboardingRepository(),
      settingsRepo: settingsRepo,
    );
    await tester.tap(find.text('এড়িয়ে যান').first);
    for (int i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }
    expect(find.text('Allow notifications'), findsOneWidget);
    expect(find.text('পরে করব'), findsOneWidget);
  });

  testWidgets('completing via "পরে করব" marks onboarding done + persists '
      'the calendar choice', (WidgetTester tester) async {
    final FakeOnboardingRepository onb = FakeOnboardingRepository();
    await _pumpOnboarding(
      tester,
      onboardingRepo: onb,
      settingsRepo: settingsRepo,
    );

    Future<void> drainPageTransition() async {
      // PageView animateToPage runs ~320ms; pump generously past it.
      for (int i = 0; i < 12; i++) {
        await tester.pump(const Duration(milliseconds: 50));
      }
    }

    await tester.tap(find.text('শুরু করুন'));
    await drainPageTransition();
    await tester.tap(find.text('পরবর্তী'));
    await drainPageTransition();
    // On the calendar choice screen, tap বাংলা.
    await tester.tap(find.text('বাংলা (বঙ্গাব্দ)'));
    await tester.pump();
    await tester.tap(find.text('পরবর্তী'));
    await drainPageTransition();
    expect(find.text('Allow notifications'), findsOneWidget);

    await tester.tap(find.text('পরে করব'));
    await drainPageTransition();

    expect(onb.completed, isTrue);
    expect(
      settingsRepo.currentForTest.primaryCalendar,
      PrimaryCalendarPreference.bangla,
    );
  });
}
