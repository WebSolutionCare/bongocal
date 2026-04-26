import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../shared/theme/theme.dart';
import 'router.dart';

/// Root widget. Wires the [appRouter], light + dark theme, and Bangla as
/// the default locale (English available via in-app toggle later).
class BongoCalApp extends ConsumerWidget {
  const BongoCalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: 'BongoCal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: ThemeMode.system,
      routerConfig: appRouter,
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('bn', 'BD'),
        Locale('en', 'US'),
      ],
      locale: const Locale('bn', 'BD'),
    );
  }
}
