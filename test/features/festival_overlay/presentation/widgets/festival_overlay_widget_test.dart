import 'package:bongocal/features/festival_overlay/presentation/widgets/festival_overlay_widget.dart';
import 'package:bongocal/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_fakes/festival_fixtures.dart';

Future<void> _pumpOverlay(
  WidgetTester tester, {
  required VoidCallback onDismiss,
  Duration autoDismissAfter = const Duration(seconds: 5),
}) async {
  await tester.binding.setSurfaceSize(const Size(414, 900));
  addTearDown(() => tester.binding.setSurfaceSize(null));
  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      home: Scaffold(
        body: FestivalOverlayWidget(
          greeting: eidGreeting(),
          today: DateTime(2026, 3, 21),
          onDismiss: onDismiss,
          autoDismissAfter: autoDismissAfter,
        ),
      ),
    ),
  );
  // Drain entry animation (1.2 s).
  for (int i = 0; i < 30; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  testWidgets('renders Bangla heading + Skip + Start CTA',
      (WidgetTester tester) async {
    await _pumpOverlay(tester, onDismiss: () {});
    expect(find.text('ঈদ মোবারক'), findsOneWidget);
    expect(find.text('Eid Mubarak'), findsOneWidget);
    expect(find.text('শুরু করুন'), findsOneWidget);
    expect(find.text('এড়িয়ে যান'), findsOneWidget);
  });

  testWidgets('tapping "শুরু করুন" calls onDismiss',
      (WidgetTester tester) async {
    int dismissCalls = 0;
    await _pumpOverlay(tester, onDismiss: () => dismissCalls++);
    await tester.tap(find.text('শুরু করুন'));
    await tester.pump();
    expect(dismissCalls, 1);
  });

  testWidgets('auto-dismisses after the configured timer',
      (WidgetTester tester) async {
    int dismissCalls = 0;
    await _pumpOverlay(
      tester,
      onDismiss: () => dismissCalls++,
      autoDismissAfter: const Duration(milliseconds: 200),
    );
    // Past 200ms — the timer should have fired during pump-drain.
    expect(dismissCalls, greaterThanOrEqualTo(1));
  });
}
