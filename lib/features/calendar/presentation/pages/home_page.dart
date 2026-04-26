import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/bottom_nav.dart';
import '../../domain/entities/calendar_date.dart';
import '../../domain/entities/upcoming_holiday.dart';
import '../providers/calendar_provider.dart';
import '../widgets/quick_action_grid.dart';
import '../widgets/today_card.dart';
import '../widgets/upcoming_holiday_card.dart';
import '../widgets/week_strip.dart';

/// Home / Today screen. Composes the hero today card, upcoming holiday card,
/// week strip, quick actions, and bottom navigation.
///
/// Mirrors design_system/BongoCal Home Screen.html. The personal events list
/// at the bottom of the mockup is owned by the events feature and renders
/// once that feature lands.
class HomePage extends ConsumerWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final AsyncValue<CalendarDate> todayAsync = ref.watch(todayProvider);

    return Scaffold(
      backgroundColor: roles.bgCanvas,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            const _TopBar(),
            Expanded(
              child: todayAsync.when(
                data: (CalendarDate today) => _HomeBody(today: today),
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
        currentIndex: 0,
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
        return; // already on home
      case 1:
        context.go(AppRoutes.month);
      case 2:
        context.go(AppRoutes.holidays);
      case 3:
        context.go(AppRoutes.addEvent);
      case 4:
        context.go(AppRoutes.settings);
    }
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 8, 12, 12),
      child: Row(
        children: <Widget>[
          // Wordmark with brand-emerald dot.
          Row(
            children: <Widget>[
              Container(
                width: 8,
                height: 8,
                decoration: const BoxDecoration(
                  color: AppColors.brandEmerald,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                'BongoCal',
                style: AppTypography.h3En().copyWith(
                  color: roles.fgPrimary,
                  fontSize: 20,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.4,
                ),
              ),
            ],
          ),
          const Spacer(),
          _IconButton(icon: Icons.search, onTap: () {}),
          _IconButton(
            icon: Icons.notifications_none_outlined,
            onTap: () {},
            badged: true,
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    required this.icon,
    required this.onTap,
    this.badged = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool badged;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Material(
      color: Colors.transparent,
      shape: const CircleBorder(),
      child: InkWell(
        onTap: onTap,
        customBorder: const CircleBorder(),
        child: SizedBox(
          width: 38,
          height: 38,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              Icon(icon, size: 22, color: roles.fgPrimary),
              if (badged)
                Positioned(
                  top: 9,
                  right: 9,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      color: AppColors.brandRed,
                      shape: BoxShape.circle,
                      border: Border.all(color: roles.bgCanvas, width: 2),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HomeBody extends ConsumerWidget {
  const _HomeBody({required this.today});

  final CalendarDate today;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;

    final AsyncValue<UpcomingHoliday?> nextHoliday =
        ref.watch(nextHolidayProvider);
    final AsyncValue<List<CalendarDate>> weekStrip =
        ref.watch(weekStripProvider);

    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return ListView(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.only(
        bottom: AppSpacing.bottomNavHeight + bottomInset + AppSpacing.s6,
      ),
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
          child: TodayCard(today: today),
        ),
        const SizedBox(height: 28),

        // ---- Next holiday ----
        _SectionHeader(
          title: 'পরবর্তী ছুটি',
          actionLabel: 'সব দেখুন',
          onAction: () => _go(context, AppRoutes.holidays),
        ),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: nextHoliday.when(
            data: (UpcomingHoliday? h) => h == null
                ? _EmptySectionPlaceholder(
                    text: 'কোনো ছুটি কাছাকাছি নেই।',
                    color: roles.fgTertiary,
                  )
                : UpcomingHolidayCard(
                    holiday: h,
                    onTap: () => _go(context, '${AppRoutes.holidays}/${h.id}'),
                  ),
            loading: () => const _SectionLoading(height: 88),
            error: (_, __) => const _SectionError(),
          ),
        ),
        const SizedBox(height: 28),

        // ---- Week strip ----
        _SectionHeader(
          title: 'এই সপ্তাহ',
          actionLabel: '${today.englishMonthName} ${today.gregorian.year}',
          onAction: () => _go(context, AppRoutes.month),
        ),
        const SizedBox(height: 8),
        weekStrip.when(
          data: (List<CalendarDate> days) => WeekStrip(
            days: days,
            todayIndex: today.weekdayIndexSatFirst,
          ),
          loading: () => const _SectionLoading(height: 76),
          error: (_, __) => const _SectionError(),
        ),
        const SizedBox(height: 28),

        // ---- Quick actions ----
        const _SectionHeader(title: 'দ্রুত অ্যাকশন'),
        const SizedBox(height: 12),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: QuickActionGrid(
            actions: <QuickAction>[
              QuickAction(
                bnLabel: 'মাসিক ভিউ',
                enLabel: 'Monthly View',
                icon: Icons.calendar_month_outlined,
                tone: QuickActionTone.emerald,
                onTap: () => _go(context, AppRoutes.month),
              ),
              QuickAction(
                bnLabel: 'সব ছুটি',
                enLabel: 'All Holidays',
                icon: Icons.star_outline,
                tone: QuickActionTone.red,
                onTap: () => _go(context, AppRoutes.holidays),
              ),
              QuickAction(
                bnLabel: 'ইভেন্ট যোগ',
                enLabel: 'Add Event',
                icon: Icons.add,
                tone: QuickActionTone.gray,
                onTap: () => _go(context, AppRoutes.addEvent),
              ),
              QuickAction(
                bnLabel: 'নামাজের সময়',
                enLabel: 'Prayer Times',
                icon: Icons.mosque_outlined,
                tone: QuickActionTone.gold,
                onTap: () {}, // wires to prayer-times feature
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _go(BuildContext context, String path) => context.go(path);
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({
    required this.title,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 22),
      child: Row(
        children: <Widget>[
          Text(
            title,
            style: AppTypography.h3Bn().copyWith(
              color: roles.fgPrimary,
              fontSize: 16,
            ),
          ),
          const Spacer(),
          if (actionLabel != null && onAction != null)
            TextButton(
              onPressed: onAction,
              style: TextButton.styleFrom(
                padding: EdgeInsets.zero,
                minimumSize: const Size(0, 0),
                tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              ),
              child: Text(
                actionLabel!,
                style: AppTypography.bodySmEn().copyWith(
                  color: AppColors.brandEmerald,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _SectionLoading extends StatelessWidget {
  const _SectionLoading({required this.height});

  final double height;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      child: const Center(
        child: SizedBox(
          width: 16,
          height: 16,
          child: CircularProgressIndicator(strokeWidth: 2),
        ),
      ),
    );
  }
}

class _SectionError extends StatelessWidget {
  const _SectionError();

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Text(
        'লোড করা যায়নি।',
        style: AppTypography.bodySmBn().copyWith(color: roles.fgTertiary),
      ),
    );
  }
}

class _EmptySectionPlaceholder extends StatelessWidget {
  const _EmptySectionPlaceholder({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Text(
        text,
        style: AppTypography.bodySmBn().copyWith(color: color),
      ),
    );
  }
}
