import 'package:bongocal/app/app.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('Home renders BongoCal wordmark in brand emerald',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(child: BongoCalApp()),
    );

    // Wait one frame for fonts to settle.
    await tester.pump();

    expect(find.text('BongoCal'), findsOneWidget);
    expect(find.text('বঙ্গক্যাল'), findsOneWidget);

    final wordmark = tester.widget<Text>(find.text('BongoCal'));
    expect(wordmark.style?.color, const Color(0xFF006A4E));
  });
}
