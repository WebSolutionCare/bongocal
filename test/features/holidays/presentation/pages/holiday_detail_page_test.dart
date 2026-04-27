import 'package:bongocal/core/clock_provider.dart';
import 'package:bongocal/features/holidays/presentation/pages/holiday_detail_page.dart';
import 'package:bongocal/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('past holiday: countdown card fully visible (regression)',
      (WidgetTester tester) async {
    await tester.binding.setSurfaceSize(const Size(414, 1200));
    addTearDown(() => tester.binding.setSurfaceSize(null));

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          clockProvider.overrideWithValue(() => DateTime(2026, 4, 27)),
        ],
        child: MaterialApp(
          theme: AppTheme.light(),
          debugShowCheckedModeBanner: false,
          home: const HolidayDetailPage(id: 'shab_e_barat'),
        ),
      ),
    );

    for (int i = 0; i < 10; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    // Hero shows the holiday name.
    expect(find.text('শবে বরাত'), findsWidgets);

    // Both halves of the countdown card must be present — the bug was
    // that the headline ("X দিন আগে") was hidden behind the hero gradient
    // because of a paint-only `Transform.translate(-36)` overlap.
    expect(find.textContaining('দিন আগে'), findsOneWidget);
    expect(find.text('এ বছরের ছুটি অতীত'), findsOneWidget);

    // Action row labels — confirms layout reaches below the countdown card.
    expect(find.text('রিমাইন্ডার'), findsOneWidget);
    expect(find.text('শেয়ার'), findsOneWidget);
    expect(find.text('সংরক্ষণ'), findsOneWidget);

    // No layout overflow exceptions captured during the pump cycles.
    expect(tester.takeException(), isNull);
  });
}
