import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/bottom_nav.dart';
import '../../domain/entities/month_data.dart';
import '../providers/calendar_provider.dart';
import '../providers/month_provider.dart';
import '../widgets/month_grid.dart';
import '../widgets/month_header.dart';

/// Month view page — calendar grid with prev/next navigation, weekday header,
/// and a selected-day panel. Mirrors design_system/BongoCal Month View.html.
class MonthViewPage extends ConsumerWidget {
  const MonthViewPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final AsyncValue<MonthData> month = ref.watch(monthDataProvider);
    final AsyncValue<String> subtitle = ref.watch(monthSubtitleProvider);
    final DateTime? selected = ref.watch(selectedDateProvider);
    final CurrentMonth current = ref.watch(currentMonthProvider);

    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return Scaffold(
      backgroundColor: roles.bgCanvas,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            MonthHeader(
              year: current.year,
              month: current.month,
              subtitle: subtitle.value ?? '',
              onPrevious: () =>
                  ref.read(currentMonthProvider.notifier).goToPrevious(),
              onNext: () =>
                  ref.read(currentMonthProvider.notifier).goToNext(),
              onToday: () =>
                  ref.read(currentMonthProvider.notifier).goToToday(),
            ),
            Expanded(
              child: month.when(
                data: (MonthData data) => ListView(
                  physics: const BouncingScrollPhysics(),
                  padding: EdgeInsets.only(
                    bottom: AppSpacing.bottomNavHeight +
                        bottomInset +
                        AppSpacing.s6,
                  ),
                  children: <Widget>[
                    MonthGrid(
                      data: data,
                      selectedDate: selected,
                      onSelect: (DateTime d) => ref
                          .read(selectedDateProvider.notifier)
                          .state = d,
                    ),
                    if (selected != null) _SelectedDayPanel(date: selected),
                  ],
                ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (Object e, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.gutter),
                    child: Text(
                      'লোড করা যায়নি · $e',
                      style: AppTypography.bodyBn().copyWith(
                        color: roles.fgSecondary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 1,
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
        return;
      case 2:
        context.go(AppRoutes.holidays);
      case 3:
        context.go(AppRoutes.addEvent);
      case 4:
        context.go(AppRoutes.settings);
    }
  }
}

class _SelectedDayPanel extends ConsumerWidget {
  const _SelectedDayPanel({required this.date});

  final DateTime date;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    final AsyncValue<MonthData> monthAsync = ref.watch(monthDataProvider);

    return monthAsync.maybeWhen(
      data: (MonthData data) {
        final CalendarDayCell? cell = data.cellFor(date);
        if (cell == null) return const SizedBox.shrink();
        return Padding(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Container(
            decoration: BoxDecoration(
              color: roles.bgSurface,
              border: Border.all(color: roles.borderSubtle),
              borderRadius: BorderRadius.circular(20),
              boxShadow: isDark ? AppShadows.smDark : AppShadows.smLight,
            ),
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  crossAxisAlignment: CrossAxisAlignment.baseline,
                  textBaseline: TextBaseline.alphabetic,
                  children: <Widget>[
                    Text(
                      cell.date.formatGregorianLong(),
                      style: AppTypography.h2En().copyWith(
                        color: roles.fgPrimary,
                        fontSize: 22,
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.22,
                      ),
                    ),
                    const Spacer(),
                    Text(
                      cell.date.banglaWeekday,
                      style: AppTypography.bodySmBn().copyWith(
                        color: roles.fgTertiary,
                        fontSize: 13,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Container(height: 1, color: roles.borderSubtle),
                const SizedBox(height: 10),
                IntrinsicHeight(
                  child: Row(
                    children: <Widget>[
                      Expanded(
                        child: _AltCol(
                          label: 'বাংলা',
                          value: cell.date.bangla.formatFullBn(),
                        ),
                      ),
                      Container(width: 1, color: roles.borderSubtle),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(left: 16),
                          child: _AltCol(
                            label: 'হিজরি',
                            value: cell.date.hijri.formatFullBn(),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (cell.holidayLabelBn != null) ...<Widget>[
                  const SizedBox(height: 12),
                  Text(
                    cell.holidayLabelBn!,
                    style: AppTypography.h3Bn().copyWith(
                      color: cell.isFestival
                          ? AppColors.brandGold700
                          : AppColors.brandRed,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  if (cell.holidayLabelEn != null)
                    Text(
                      cell.holidayLabelEn!,
                      style: AppTypography.bodySmEn().copyWith(
                        color: roles.fgTertiary,
                      ),
                    ),
                ],
              ],
            ),
          ),
        );
      },
      orElse: () => const SizedBox.shrink(),
    );
  }
}

class _AltCol extends StatelessWidget {
  const _AltCol({required this.label, required this.value});

  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          label.toUpperCase(),
          style: AppTypography.captionEn().copyWith(
            color: roles.fgTertiary,
            fontSize: 9,
            fontWeight: FontWeight.w700,
            letterSpacing: 1.4,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: AppTypography.bodyBn().copyWith(
            color: roles.fgPrimary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
