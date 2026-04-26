import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/calendar/presentation/pages/home_page.dart';
import '../features/calendar/presentation/pages/month_view_page.dart';
import '../shared/theme/theme.dart';

/// Routes (kept as constants so feature code can `go(AppRoutes.holidays)`
/// without leaking string literals).
class AppRoutes {
  const AppRoutes._();

  static const String home = '/';
  static const String month = '/month';
  static const String holidays = '/holidays';
  static const String holidayDetail = '/holidays/:id';
  static const String addEvent = '/event/new';
  static const String settings = '/settings';
  static const String pro = '/pro';
}

/// Application router. Phase 1 features replace each [_PlaceholderPage] with
/// their real screens.
final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.home,
  routes: <RouteBase>[
    GoRoute(
      path: AppRoutes.home,
      builder: (BuildContext context, GoRouterState state) => const HomePage(),
    ),
    GoRoute(
      path: AppRoutes.month,
      builder: (BuildContext context, GoRouterState state) =>
          const MonthViewPage(),
    ),
    GoRoute(
      path: AppRoutes.holidays,
      builder: (BuildContext context, GoRouterState state) =>
          const _PlaceholderPage(title: 'ছুটির দিন'),
      routes: <RouteBase>[
        GoRoute(
          path: ':id',
          builder: (BuildContext context, GoRouterState state) =>
              _PlaceholderPage(
            title: 'ছুটির দিনের বিবরণ',
            subtitle: state.pathParameters['id'],
          ),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.addEvent,
      builder: (BuildContext context, GoRouterState state) =>
          const _PlaceholderPage(title: 'নতুন অনুষ্ঠান'),
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (BuildContext context, GoRouterState state) =>
          const _PlaceholderPage(title: 'সেটিংস'),
    ),
    GoRoute(
      path: AppRoutes.pro,
      builder: (BuildContext context, GoRouterState state) =>
          const _PlaceholderPage(title: 'প্রো'),
    ),
  ],
);

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title, this.subtitle});

  final String title;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    final roles = Theme.of(context).extension<AppColorRoles>()!;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          child: Text(
            subtitle ?? 'এই স্ক্রিনটি পরবর্তীতে যুক্ত হবে।',
            style: AppTypography.bodyBn().copyWith(color: roles.fgSecondary),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
