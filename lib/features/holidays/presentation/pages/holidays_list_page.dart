import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/utils/bangla_numerals.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/bottom_nav.dart';
import '../../../calendar/data/datasources/bangla_calendar_local.dart';
import '../../../calendar/domain/entities/bangla_date.dart';
import '../../../calendar/presentation/providers/calendar_provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../domain/entities/holiday.dart';
import '../../domain/entities/holiday_type.dart';
import '../providers/filter_provider.dart';
import '../providers/holidays_provider.dart';
import '../widgets/featured_upcoming_card.dart';
import '../widgets/filter_chips.dart';
import '../widgets/holiday_card.dart';
import '../widgets/month_section_header.dart';

/// Holidays list page — top bar, filter chips, featured "next up" card,
/// and a vertical scroll of month-grouped holiday cards. Mirrors the
/// `BongoCal Holidays List.html` mockup.
class HolidaysListPage extends ConsumerWidget {
  const HolidaysListPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final int year = ref.watch(selectedHolidayYearProvider);
    final HolidayType? filter = ref.watch(holidayTypeFilterProvider);
    final AsyncValue<List<Holiday>> filteredAsync =
        ref.watch(filteredHolidaysProvider);
    final AsyncValue<int> totalCountAsync = ref.watch(
      holidaysForYearProvider.select(
        (AsyncValue<List<Holiday>> v) => v.whenData((List<Holiday> l) => l.length),
      ),
    );
    final AsyncValue<Map<HolidayType, int>> countsAsync =
        ref.watch(holidayCountsProvider);

    final double bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: roles.bgCanvas,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            _TopBar(year: year),
            FilterChips(
              totalCount: totalCountAsync.value ?? 0,
              counts: countsAsync.value ?? const <HolidayType, int>{},
              selected: filter,
              onSelect: (HolidayType? t) =>
                  ref.read(holidayTypeFilterProvider.notifier).state = t,
            ),
            const SizedBox(height: 4),
            Expanded(
              child: filteredAsync.when(
                data: (List<Holiday> holidays) => _Body(
                  holidays: holidays,
                  bottomPadding: AppSpacing.bottomNavHeight +
                      bottomInset +
                      AppSpacing.s6,
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (Object e, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.gutter),
                    child: Text(
                      'লোড করা যায়নি · $e',
                      textAlign: TextAlign.center,
                      style: AppTypography.bodyBn().copyWith(
                        color: roles.fgSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 2,
        onTap: (int i) => _navigate(context, i),
        items: const <BottomNavItem>[
          BottomNavItem(icon: Icons.home_outlined, label: 'হোম'),
          BottomNavItem(
            icon: Icons.calendar_today_outlined,
            label: 'ক্যালেন্ডার',
          ),
          BottomNavItem(icon: Icons.star_outline, label: 'ছুটি'),
          BottomNavItem(icon: Icons.event_note_outlined, label: 'ইভেন্ট'),
          BottomNavItem(icon: Icons.settings_outlined, label: 'সেটিংস'),
        ],
      ),
    );
  }

  static void _navigate(BuildContext context, int index) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
      case 1:
        context.go(AppRoutes.month);
      case 2:
        return;
      case 3:
        context.go(AppRoutes.addEvent);
      case 4:
        context.go(AppRoutes.settings);
    }
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({required this.year});

  final int year;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 12, 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'ছুটির দিন',
                  style: AppTypography.h1Bn().copyWith(
                    fontSize: 24,
                    fontWeight: FontWeight.w700,
                    color: roles.fgPrimary,
                    letterSpacing: -0.12,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'HOLIDAYS · $year',
                  style: AppTypography.captionEn().copyWith(
                    color: roles.fgTertiary,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
          _YearPill(year: year),
        ],
      ),
    );
  }
}

class _YearPill extends StatelessWidget {
  const _YearPill({required this.year});

  final int year;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Material(
      color: roles.bgSurface2,
      borderRadius: AppRadii.pillBorder,
      child: InkWell(
        onTap: () {}, // year-switch sheet ships in a follow-up
        borderRadius: AppRadii.pillBorder,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                '$year',
                style: AppTypography.bodySmEn().copyWith(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: roles.fgPrimary,
                ),
              ),
              const SizedBox(width: 4),
              Icon(
                Icons.keyboard_arrow_down,
                size: 18,
                color: roles.fgPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Body extends ConsumerWidget {
  const _Body({required this.holidays, required this.bottomPadding});

  final List<Holiday> holidays;
  final double bottomPadding;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    if (holidays.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.gutter),
          child: Text(
            'এই ফিল্টারে কোনো ছুটি নেই।',
            style: AppTypography.bodyBn().copyWith(
              color: roles.fgTertiary,
            ),
          ),
        ),
      );
    }

    final DateTime today = ref.watch(clockProvider)();
    final AsyncValue<Holiday?> nextAsync = ref.watch(nextHolidayProvider);
    final HolidayType? filter = ref.watch(holidayTypeFilterProvider);
    final bool useBn = ref.watch(useBanglaNumeralsProvider);

    // Group by Gregorian month.
    final Map<int, List<Holiday>> byMonth = <int, List<Holiday>>{};
    for (final Holiday h in holidays) {
      byMonth.putIfAbsent(h.date.month, () => <Holiday>[]).add(h);
    }
    final List<int> sortedMonths = byMonth.keys.toList()..sort();

    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(bottom: bottomPadding),
      children: <Widget>[
        // Featured next-up card — only visible on the "all" filter.
        if (filter == null)
          nextAsync.when(
            data: (Holiday? h) => h == null
                ? const SizedBox.shrink()
                : Padding(
                    padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
                    child: _FeaturedUpcoming(holiday: h, today: today),
                  ),
            loading: () => const SizedBox(
              height: 180,
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (_, __) => const SizedBox.shrink(),
          ),
        for (final int month in sortedMonths) ...<Widget>[
          MonthSectionHeader(
            monthLabelEn: MonthSectionHeader.formatEn(holidays.first.date.year, month),
            monthLabelBn: _banglaMonthLabel(holidays.first.date.year, month, useBn),
            count: byMonth[month]!.length,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: <Widget>[
                for (final Holiday h in byMonth[month]!) ...<Widget>[
                  HolidayCard(
                    holiday: h,
                    daysFromToday:
                        h.date.difference(_startOf(today)).inDays,
                    banglaDayLabel: _banglaDayLabel(h.date, useBn),
                    onTap: () => context.go('${AppRoutes.holidays}/${h.id}'),
                  ),
                  const SizedBox(height: 10),
                ],
              ],
            ),
          ),
        ],
      ],
    );
  }

  static DateTime _startOf(DateTime d) => DateTime(d.year, d.month, d.day);

  /// Render `১২ চৈত্র` (or `12 চৈত্র` when [useBn] is false). Pure helper —
  /// the calendar conversion is deterministic and we keep month names in
  /// Bangla either way; only digits flip.
  static String _banglaDayLabel(DateTime date, bool useBn) {
    final BanglaDate bs = _bangla.convert(date);
    return '${useBn ? BanglaNumerals.fromInt(bs.day) : bs.day} ${bs.monthNameBn}';
  }

  String _banglaMonthLabel(int year, int month, bool useBn) {
    final DateTime first = DateTime(year, month, 1);
    final DateTime last = DateTime(year, month + 1, 0);
    final BanglaDate bsFirst = _bangla.convert(first);
    final BanglaDate bsLast = _bangla.convert(last);
    String fmt(int n) => useBn ? BanglaNumerals.fromInt(n) : '$n';
    if (bsFirst.monthIndex == bsLast.monthIndex &&
        bsFirst.year == bsLast.year) {
      return '${bsFirst.monthNameBn} ${fmt(bsFirst.year)}';
    }
    return '${bsFirst.monthNameBn}–${bsLast.monthNameBn} ${fmt(bsLast.year)}';
  }
}

const BanglaCalendarLocal _bangla = BanglaCalendarLocal();

class _FeaturedUpcoming extends ConsumerWidget {
  const _FeaturedUpcoming({required this.holiday, required this.today});

  final Holiday holiday;
  final DateTime today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final int days = holiday.date.difference(_startOf(today)).inDays;
    final BanglaDate bs = _bangla.convert(holiday.date);
    final bool useBn = ref.watch(useBanglaNumeralsProvider);
    return FeaturedUpcomingCard(
      holiday: holiday,
      daysAway: days,
      banglaFullDate: bs.formatFullBn(useBanglaNumerals: useBn),
      hijriFullDate: '',
      onShare: () {},
      onTap: () =>
          context.go('${AppRoutes.holidays}/${holiday.id}'),
    );
  }

  static DateTime _startOf(DateTime d) => DateTime(d.year, d.month, d.day);
}
