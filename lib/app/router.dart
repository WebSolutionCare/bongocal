import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../features/calendar/presentation/pages/home_page.dart';
import '../features/calendar/presentation/pages/month_view_page.dart';
import '../features/events/presentation/pages/events_list_page.dart';
import '../features/holidays/presentation/pages/holiday_detail_page.dart';
import '../features/holidays/presentation/pages/holidays_list_page.dart';
import '../features/pro_interest/presentation/pages/pro_interest_page.dart';
import '../features/settings/presentation/pages/settings_page.dart';
import '../shared/theme/theme.dart';

class AppRoutes {
  const AppRoutes._();

  static const String home = '/';
  static const String month = '/month';
  static const String holidays = '/holidays';
  static const String holidayDetail = '/holidays/:id';
  static const String events = '/events';
  static const String newEvent = '/events/new';
  static const String eventDetail = '/events/:id';
  static const String addEvent = newEvent;
  static const String settings = '/settings';
  static const String pro = '/pro';
  static const String proInterest = '/pro-interest';
}

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
          const HolidaysListPage(),
      routes: <RouteBase>[
        GoRoute(
          path: ':id',
          builder: (BuildContext context, GoRouterState state) =>
              HolidayDetailPage(id: state.pathParameters['id']!),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.events,
      builder: (BuildContext context, GoRouterState state) =>
          const EventsListPage(),
      routes: <RouteBase>[
        // /events/new — list page + create sheet auto-opened.
        GoRoute(
          path: 'new',
          builder: (BuildContext context, GoRouterState state) =>
              const EventsListPage(autoOpenNew: true),
        ),
        // /events/:id — list page + edit sheet auto-opened for that id.
        GoRoute(
          path: ':id',
          builder: (BuildContext context, GoRouterState state) =>
              EventsListPage(autoOpenEditId: state.pathParameters['id']),
        ),
      ],
    ),
    GoRoute(
      path: AppRoutes.settings,
      builder: (BuildContext context, GoRouterState state) =>
          const SettingsPage(),
    ),
    GoRoute(
      path: AppRoutes.pro,
      builder: (BuildContext context, GoRouterState state) =>
          const _PlaceholderPage(title: 'প্রো'),
    ),
    GoRoute(
      path: AppRoutes.proInterest,
      builder: (BuildContext context, GoRouterState state) =>
          const ProInterestPage(),
    ),
  ],
);

class _PlaceholderPage extends StatelessWidget {
  const _PlaceholderPage({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          child: Text(
            'এই স্ক্রিনটি পরবর্তীতে যুক্ত হবে।',
            style: AppTypography.bodyBn().copyWith(color: roles.fgSecondary),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
