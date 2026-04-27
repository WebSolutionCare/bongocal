import 'package:bongocal/features/settings/domain/entities/app_settings.dart';
import 'package:bongocal/features/settings/domain/entities/theme_preference.dart';
import 'package:bongocal/features/settings/presentation/pages/settings_page.dart';
import 'package:bongocal/features/settings/presentation/providers/settings_provider.dart';
import 'package:bongocal/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_fakes/fake_settings_repository.dart';

Future<FakeSettingsRepository> _pumpSettings(
  WidgetTester tester, {
  AppSettings? initial,
}) async {
  await tester.binding.setSurfaceSize(const Size(414, 1300));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final FakeSettingsRepository repo =
      FakeSettingsRepository(initial: initial);
  addTearDown(repo.dispose);

  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        settingsRepositoryProvider.overrideWithValue(repo),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        darkTheme: AppTheme.dark(),
        debugShowCheckedModeBanner: false,
        home: const SettingsPage(),
      ),
    ),
  );

  for (int i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  return repo;
}

void main() {
  testWidgets('renders all top-level sections', (WidgetTester tester) async {
    await _pumpSettings(tester);

    // 'সেটিংস' appears twice: page title + bottom-nav tab label.
    expect(find.text('সেটিংস'), findsWidgets);
    // Section headers render uppercased: e.g. 'চেহারা · APPEARANCE'.
    // We only assert above-the-fold sections — About/Account are lazily
    // built by ListView and require scrolling to surface.
    expect(find.textContaining('APPEARANCE'), findsOneWidget);
    expect(find.textContaining('CALENDAR'), findsOneWidget);
    expect(find.textContaining('NOTIFICATIONS'), findsOneWidget);
  });

  testWidgets('flipping the theme segment writes through to the repo',
      (WidgetTester tester) async {
    final FakeSettingsRepository repo =
        await _pumpSettings(tester);

    expect(repo.currentForTest.themeMode, ThemePreference.system);

    // The Theme row's segmented control exposes Light/Dark/System buttons.
    await tester.tap(find.text('Dark'));
    await tester.pump();

    expect(repo.currentForTest.themeMode, ThemePreference.dark);
  });

  testWidgets('Bangla numerals toggle writes through to the repo',
      (WidgetTester tester) async {
    final FakeSettingsRepository repo =
        await _pumpSettings(tester);

    expect(repo.currentForTest.showBanglaNumerals, true);

    await tester.tap(find.text('বাংলা সংখ্যা দেখান'));
    await tester.pump(const Duration(milliseconds: 50));

    expect(repo.currentForTest.showBanglaNumerals, false);
  });
}
