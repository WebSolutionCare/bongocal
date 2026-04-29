import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../features/festival_overlay/presentation/widgets/festival_overlay_wrapper.dart';
import '../features/notifications/presentation/providers/notification_scheduler_provider.dart';
import '../features/settings/presentation/providers/settings_provider.dart';
import '../shared/theme/theme.dart';
import 'router.dart';

/// Root widget. Wires the [appRouter], light + dark theme, and the
/// user-selected locale. `themeMode` and `locale` are read live from
/// [settingsProvider] so toggling them in Settings rebuilds MaterialApp
/// and propagates the new theme + locale through the whole tree.
class BongoCalApp extends ConsumerWidget {
  const BongoCalApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Activates the holiday-reminder orchestrator. Watching it here keeps
    // the provider alive for the app lifetime; it self-reschedules
    // whenever settings or the upcoming-holiday list change.
    ref.watch(notificationOrchestratorProvider);

    final ThemeMode themeMode = ref.watch(themeModeProvider);
    final Locale locale = ref.watch(localeProvider);

    return MaterialApp.router(
      title: 'BongoCal',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      darkTheme: AppTheme.dark(),
      themeMode: themeMode,
      routerConfig: appRouter,
      // Wraps every routed page so the festival greeting can paint on
      // top of the home / month / settings views without each one
      // having to opt in.
      builder: (BuildContext context, Widget? child) =>
          FestivalOverlayWrapper(child: child ?? const SizedBox.shrink()),
      localizationsDelegates: const <LocalizationsDelegate<dynamic>>[
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const <Locale>[
        Locale('bn', 'BD'),
        Locale('en', 'US'),
      ],
      locale: locale,
    );
  }
}
