import 'package:bongocal/core/clock_provider.dart';
import 'package:bongocal/features/events/domain/entities/personal_event.dart';
import 'package:bongocal/features/events/presentation/pages/events_list_page.dart';
import 'package:bongocal/features/events/presentation/providers/events_provider.dart';
import 'package:bongocal/shared/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_fakes/fake_event_repository.dart';

Future<void> _pumpPage(
  WidgetTester tester, {
  required List<PersonalEvent> seed,
  DateTime? today,
}) async {
  final DateTime now = today ?? DateTime(2026, 4, 27);
  await tester.binding.setSurfaceSize(const Size(414, 1200));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        clockProvider.overrideWithValue(() => now),
        eventRepositoryProvider.overrideWithValue(
          FakeEventRepository(now: () => now, seed: seed),
        ),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        debugShowCheckedModeBanner: false,
        home: const EventsListPage(),
      ),
    ),
  );

  for (int i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
}

void main() {
  testWidgets('empty state shows the no-events copy',
      (WidgetTester tester) async {
    await _pumpPage(tester, seed: const <PersonalEvent>[]);

    expect(find.text('অনুষ্ঠান'), findsOneWidget);
    expect(find.text('কোনো আসন্ন অনুষ্ঠান নেই'), findsOneWidget);
    expect(find.text('+ চাপ দিয়ে নতুন ইভেন্ট যোগ করুন'), findsOneWidget);
  });

  testWidgets('renders a card for a seeded event',
      (WidgetTester tester) async {
    final PersonalEvent e = makeEvent(
      id: 'birthday',
      date: DateTime(2026, 4, 28),
      title: 'আম্মার জন্মদিন',
    );
    await _pumpPage(tester, seed: <PersonalEvent>[e]);

    expect(find.text('আম্মার জন্মদিন'), findsOneWidget);
    expect(find.text('APR'), findsOneWidget);
  });
}
