import 'package:bongocal/features/calendar/domain/entities/bangla_date.dart';
import 'package:bongocal/features/settings/domain/entities/app_settings.dart';
import 'package:bongocal/features/settings/presentation/providers/settings_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../_fakes/fake_settings_repository.dart';

/// End-to-end regression: flipping `showBanglaNumerals` in settings flips
/// the digits rendered by every date-aware widget. The probe pumps
/// `BanglaDate.formatFullBn(useBanglaNumerals: …)` reactively — same code
/// path the real widgets use, just isolated for the assertion.
void main() {
  testWidgets('numeralFormatterProvider flips digit script reactively',
      (WidgetTester tester) async {
    final FakeSettingsRepository settings = FakeSettingsRepository();
    addTearDown(settings.dispose);

    await tester.pumpWidget(
      ProviderScope(
        overrides: <Override>[
          settingsRepositoryProvider.overrideWithValue(settings),
        ],
        child: const _Probe(),
      ),
    );

    // Drain the settings StreamProvider.
    for (int i = 0; i < 4; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    // Default: Bangla numerals on.
    expect(find.text('১৪ বৈশাখ ১৪৩৩'), findsOneWidget);

    // Flip the toggle.
    await settings.updateSettings(
      AppSettings.defaults().copyWith(showBanglaNumerals: false),
    );
    for (int i = 0; i < 4; i++) {
      await tester.pump(const Duration(milliseconds: 50));
    }

    // Latin digits, Bangla month name preserved.
    expect(find.text('14 বৈশাখ 1433'), findsOneWidget);
    expect(find.text('১৪ বৈশাখ ১৪৩৩'), findsNothing);
  });
}

class _Probe extends ConsumerWidget {
  const _Probe();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppSettings s = ref.watch(currentSettingsProvider);
    // April 27, 2026 → Boishakh 14, 1433. Format reactively.
    const BanglaDate today =
        BanglaDate(day: 14, monthIndex: 0, year: 1433);
    return MaterialApp(
      home: Scaffold(
        body: Center(
          child: Text(
            today.formatFullBn(useBanglaNumerals: s.showBanglaNumerals),
          ),
        ),
      ),
    );
  }
}
