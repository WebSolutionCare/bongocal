import 'package:bongocal/app/app.dart';
import 'package:bongocal/features/events/presentation/providers/events_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../../events/_fakes/fake_event_repository.dart';

void main() {
  testWidgets('Holidays list shows top bar, chips, and a holiday card',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(414, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          eventRepositoryProvider.overrideWithValue(FakeEventRepository()),
        ],
        child: const BongoCalApp(),
      ),
    );
    for (int i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    // From the home, navigate to the holidays tab via the bottom nav
    // (we look for "ছুটি" which is the Holidays tab label).
    final Finder holidaysTab = find.text('ছুটি');
    expect(holidaysTab, findsOneWidget);
    await tester.tap(holidaysTab);
    for (int i = 0; i < 8; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    // Page title.
    expect(find.text('ছুটির দিন'), findsOneWidget);
    expect(find.text('HOLIDAYS · 2026'), findsOneWidget);

    // Filter chips — `সব` is unique (only on the chip), `সরকারি` appears on
    // both the chip and on each government-type card pill, so we just need
    // any number ≥ 1.
    expect(find.text('সব'), findsOneWidget);
    expect(find.text('সরকারি'), findsWidgets);

    // Featured card eyebrow.
    expect(find.text('পরবর্তী ছুটি · NEXT UP'), findsOneWidget);

    // The featured card surfaces the next holiday from April 27 — May Day.
    expect(find.text('মে দিবস'), findsWidgets);
  });
}
