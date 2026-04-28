import 'package:bongocal/core/errors/failures.dart';
import 'package:bongocal/features/pro_interest/domain/entities/pro_interest_submission.dart';
import 'package:bongocal/features/pro_interest/presentation/pages/pro_interest_page.dart';
import 'package:bongocal/features/pro_interest/presentation/providers/pro_interest_provider.dart';
import 'package:bongocal/features/pro_interest/presentation/widgets/submit_button.dart';
import 'package:bongocal/shared/theme/theme.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_fakes/fake_pro_interest_repository.dart';

Future<FakeProInterestRepository> _pumpPage(
  WidgetTester tester, {
  Either<Failure, void>? submitResult,
}) async {
  await tester.binding.setSurfaceSize(const Size(414, 1400));
  addTearDown(() => tester.binding.setSurfaceSize(null));

  final FakeProInterestRepository repo =
      FakeProInterestRepository(nextResult: submitResult);

  await tester.pumpWidget(
    ProviderScope(
      overrides: <Override>[
        proInterestRepositoryProvider.overrideWithValue(repo),
      ],
      child: MaterialApp(
        theme: AppTheme.light(),
        debugShowCheckedModeBanner: false,
        home: const ProInterestPage(),
      ),
    ),
  );
  for (int i = 0; i < 4; i++) {
    await tester.pump(const Duration(milliseconds: 50));
  }
  return repo;
}

Future<void> _scrollTo(WidgetTester tester, Finder target) async {
  await tester.scrollUntilVisible(
    target,
    240,
    scrollable: find.byType(Scrollable).first,
  );
}

Future<void> _tapSubmit(WidgetTester tester) async {
  await _scrollTo(tester, find.byType(SubmitButton));
  await tester.tap(find.byType(SubmitButton));
  await tester.pump();
  await tester.pump(const Duration(milliseconds: 200));
}

/// Find the email TextField via its hint label (which sits inside the
/// TextField as part of the InputDecoration). `enterText` needs the
/// TextField, not the hint Text.
Finder _emailField() =>
    find.widgetWithText(TextField, 'you@example.com');

Future<void> _fillValidForm(WidgetTester tester) async {
  await _scrollTo(tester, _emailField());
  await tester.enterText(_emailField(), 'rahim@example.com');

  for (final String label in <String>[
    'প্রতিদিন',
    'কোনো বিজ্ঞাপন নেই',
    '৳৯৯ / মাস',
    'হ্যাঁ, আগ্রহী',
  ]) {
    await _scrollTo(tester, find.text(label));
    await tester.tap(find.text(label));
    await tester.pump();
  }
}

void main() {
  testWidgets('renders the hero copy', (WidgetTester tester) async {
    await _pumpPage(tester);

    expect(find.text('BongoCal Pro'), findsOneWidget);
    expect(find.text('আপনার মতামত জানান'), findsOneWidget);
    expect(find.text('শীঘ্রই আসছে · COMING SOON'), findsOneWidget);
    expect(find.text('মাত্র ১ মিনিট সময় দিন'), findsOneWidget);
  });

  testWidgets('submit while invalid does not call the repository',
      (WidgetTester tester) async {
    final FakeProInterestRepository repo = await _pumpPage(tester);

    await _tapSubmit(tester);

    expect(
      repo.callCount,
      0,
      reason: 'must not submit while required fields are empty',
    );
  });

  testWidgets('rejects an invalid email format',
      (WidgetTester tester) async {
    final FakeProInterestRepository repo = await _pumpPage(tester);

    await _scrollTo(tester, _emailField());
    await tester.enterText(_emailField(), 'not-an-email');

    await _tapSubmit(tester);

    expect(repo.callCount, 0);

    // Scroll back up to verify the inline email error rendered.
    await _scrollTo(tester, find.text('সঠিক ইমেইল ঠিকানা দিন'));
    expect(find.text('সঠিক ইমেইল ঠিকানা দিন'), findsOneWidget);
  });

  testWidgets('valid form submits + shows the success state',
      (WidgetTester tester) async {
    final FakeProInterestRepository repo = await _pumpPage(tester);
    await _fillValidForm(tester);
    await _tapSubmit(tester);

    expect(repo.callCount, 1);
    final ProInterestSubmission submitted = repo.lastSubmission!;
    expect(submitted.email, 'rahim@example.com');

    expect(find.text('ধন্যবাদ!'), findsOneWidget);
  });

  testWidgets('shows the error banner on a network failure',
      (WidgetTester tester) async {
    await _pumpPage(
      tester,
      submitResult:
          const Left<Failure, void>(NetworkFailure(message: 'offline')),
    );
    await _fillValidForm(tester);
    await _tapSubmit(tester);

    expect(find.text('ধন্যবাদ!'), findsNothing);
    expect(find.textContaining('জমা দেওয়া যায়নি'), findsOneWidget);
  });
}
