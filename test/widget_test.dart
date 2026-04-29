import 'package:bongocal/app/app.dart';
import 'package:bongocal/core/clock_provider.dart';
import 'package:bongocal/features/events/presentation/providers/events_provider.dart';
import 'package:bongocal/features/onboarding/presentation/providers/onboarding_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import 'features/events/_fakes/fake_event_repository.dart';

void main() {
  testWidgets('Home renders today across three calendars',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(414, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          eventRepositoryProvider.overrideWithValue(FakeEventRepository()),
          // Pretend onboarding's already done so the splash routes
          // straight to home.
          hasCompletedOnboardingProvider.overrideWith((_) async => true),
          splashMinDurationProvider.overrideWithValue(Duration.zero),
          // Pin "today" so the asserted date strings stay stable now
          // that the production clock is `DateTime.now()`.
          clockProvider.overrideWithValue(() => DateTime(2026, 4, 27)),
        ],
        child: const BongoCalApp(),
      ),
    );

    // Drain splash → home transition + the chain of FutureProviders. We
    // can't `pumpAndSettle` because of the today-dot's infinite pulse.
    for (int i = 0; i < 12; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    // Top-bar wordmark.
    expect(find.text('BongoCal'), findsOneWidget);

    // Hero: today's Gregorian day, month, year.
    expect(find.text('27'), findsWidgets); // hero + week strip
    expect(find.text('April'), findsOneWidget);
    expect(find.text('2026'), findsOneWidget);

    // Hero: today in Bangla calendar (Boishakh 14, 1433 BS).
    expect(find.text('১৪ বৈশাখ'), findsOneWidget);
    expect(find.text('১৪৩৩'), findsOneWidget);

    // Section headers in Bangla.
    expect(find.text('পরবর্তী ছুটি'), findsOneWidget);
    expect(find.text('এই সপ্তাহ'), findsOneWidget);

    // Scroll down so the quick-actions section enters the layout-built range
    // (ListView builds children lazily — items below the cache extent are
    // not constructed until they're scrolled near).
    final Finder list = find.byType(ListView).first;
    await tester.dragUntilVisible(
      find.text('দ্রুত অ্যাকশন'),
      list,
      const Offset(0, -200),
    );
    await tester.pump();

    expect(find.text('দ্রুত অ্যাকশন'), findsOneWidget);
    expect(find.text('মাসিক ভিউ'), findsOneWidget);

    // Bottom nav.
    expect(find.text('হোম'), findsOneWidget);
    expect(find.text('ক্যালেন্ডার'), findsOneWidget);
  });
}
