import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../shared/theme/theme.dart';
import '../../../calendar/data/datasources/bangla_calendar_local.dart';
import '../../../calendar/data/datasources/hijri_calendar_local.dart';
import '../../../calendar/domain/entities/bangla_date.dart';
import '../../../calendar/domain/entities/hijri_date.dart';
import '../../../calendar/presentation/providers/calendar_provider.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../domain/entities/holiday.dart';
import '../../domain/entities/holiday_type.dart';
import '../providers/holidays_provider.dart';
import '../widgets/holiday_hero.dart';

const BanglaCalendarLocal _bangla = BanglaCalendarLocal();
const HijriCalendarLocal _hijri = HijriCalendarLocal();

/// Magazine-style detail page for a single holiday: hero, countdown card,
/// 3-up actions, drop-cap article, info matrix. Mirrors
/// `BongoCal Holiday Detail.html`.
class HolidayDetailPage extends ConsumerWidget {
  const HolidayDetailPage({required this.id, super.key});

  final String id;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final AsyncValue<Holiday?> holidayAsync =
        ref.watch(holidayByIdProvider(id));

    return Scaffold(
      backgroundColor: roles.bgCanvas,
      body: holidayAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
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
        data: (Holiday? h) {
          if (h == null) {
            return Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Text(
                    'ছুটি খুঁজে পাওয়া যায়নি।',
                    style: AppTypography.bodyBn().copyWith(
                      color: roles.fgSecondary,
                    ),
                  ),
                  const SizedBox(height: 12),
                  TextButton(
                    onPressed: () => context.go(AppRoutes.holidays),
                    child: const Text('সকল ছুটি দেখুন'),
                  ),
                ],
              ),
            );
          }
          return _DetailBody(holiday: h);
        },
      ),
    );
  }
}

class _DetailBody extends ConsumerWidget {
  const _DetailBody({required this.holiday});

  final Holiday holiday;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final DateTime today = ref.watch(clockProvider)();
    final bool useBn = ref.watch(useBanglaNumeralsProvider);
    final BanglaDate bn = _bangla.convert(holiday.date);
    final HijriDate hi = _hijri.convert(holiday.date);
    final int days =
        holiday.date.difference(DateTime(today.year, today.month, today.day))
            .inDays;
    final String banglaShort = bn.formatFullBn(useBanglaNumerals: useBn);
    final String weekdayEn = _englishWeekday(holiday.date);

    final double bottomInset = MediaQuery.of(context).padding.bottom;
    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: <Widget>[
        SliverToBoxAdapter(
          child: HolidayHero(
            holiday: holiday,
            banglaShort: banglaShort,
            weekdayEn: weekdayEn,
            onBack: () {
              if (context.canPop()) {
                context.pop();
              } else {
                context.go(AppRoutes.holidays);
              }
            },
          ),
        ),
        SliverPadding(
          padding: EdgeInsets.fromLTRB(16, 20, 16, bottomInset + 32),
          sliver: SliverList(
            delegate: SliverChildListDelegate(<Widget>[
              _CountdownCard(holiday: holiday, daysAway: days),
              const SizedBox(height: 12),
              _ActionsRow(holiday: holiday),
              const SizedBox(height: 28),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _SectionTitle(
                  title: 'এই দিন সম্পর্কে',
                  accent: _accentColor(holiday.type),
                ),
              ),
              if (holiday.descriptionBn.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: _DropCapParagraph(
                    text: holiday.descriptionBn,
                    accent: _accentColor(holiday.type),
                    bodyColor: roles.fgPrimary,
                  ),
                ),
              if (holiday.descriptionEn.isNotEmpty) ...<Widget>[
                const SizedBox(height: 8),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6),
                  child: Text(
                    holiday.descriptionEn,
                    style: AppTypography.bodyEn().copyWith(
                      fontSize: 14,
                      height: 1.6,
                      color: roles.fgSecondary,
                    ),
                  ),
                ),
              ],
              const SizedBox(height: 24),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 6),
                child: _SectionTitle(
                  title: 'প্রয়োজনীয় তথ্য',
                  accent: _accentColor(holiday.type),
                ),
              ),
              _InfoCard(holiday: holiday, bn: bn, hi: hi),
            ]),
          ),
        ),
      ],
    );
  }

  static String _englishWeekday(DateTime d) {
    const List<String> names = <String>[
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return names[d.weekday - 1];
  }

  static Color _accentColor(HolidayType type) {
    switch (type) {
      case HolidayType.religious:
        return AppColors.brandGold;
      case HolidayType.governmentNational:
        return AppColors.brandRed;
      case HolidayType.international:
        return AppColors.brandEmerald;
      case HolidayType.optional:
      case HolidayType.observance:
        return AppColors.gray400;
    }
  }
}

class _CountdownCard extends ConsumerWidget {
  const _CountdownCard({required this.holiday, required this.daysAway});

  final Holiday holiday;
  final int daysAway;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final String Function(int) digits =
        ref.watch(numeralFormatterProvider);
    final bool isPast = daysAway < 0;
    final bool isToday = daysAway == 0;
    final String headline;
    if (isToday) {
      headline = 'আজ';
    } else if (isPast) {
      headline = '${digits(daysAway.abs())} দিন আগে';
    } else {
      headline = '${digits(daysAway)} দিন বাকি';
    }

    return Container(
      decoration: BoxDecoration(
        color: roles.bgSurface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: roles.borderSubtle),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            offset: const Offset(0, 12),
            blurRadius: 32,
          ),
        ],
      ),
      padding: const EdgeInsets.fromLTRB(18, 16, 18, 16),
      child: Row(
        children: <Widget>[
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: AppColors.brandRed50,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.access_time,
              size: 22,
              color: AppColors.brandRed,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  headline,
                  style: AppTypography.h2Bn().copyWith(
                    fontSize: 22,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.22,
                    color: roles.fgPrimary,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  isToday
                      ? 'আজকের ছুটির দিন'
                      : isPast
                          ? 'এ বছরের ছুটি অতীত'
                          : 'উৎসবের জন্য প্রস্তুত হন',
                  style: AppTypography.bodySmBn().copyWith(
                    fontSize: 12,
                    color: roles.fgTertiary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ActionsRow extends StatelessWidget {
  const _ActionsRow({required this.holiday});

  final Holiday holiday;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(
          child: _ActionTile(
            icon: Icons.notifications_active_outlined,
            label: 'রিমাইন্ডার',
            isPrimary: true,
            onTap: () {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionTile(
            icon: Icons.ios_share,
            label: 'শেয়ার',
            onTap: () {},
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionTile(
            icon: Icons.bookmark_border_outlined,
            label: 'সংরক্ষণ',
            onTap: () {},
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.isPrimary = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool isPrimary;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final Color bg =
        isPrimary ? AppColors.brandEmerald50 : roles.bgSurface;
    final Color iconBg =
        isPrimary ? AppColors.brandEmerald : roles.bgSurface2;
    final Color iconFg = isPrimary ? Colors.white : roles.fgSecondary;
    return Material(
      color: bg,
      borderRadius: AppRadii.lgBorder,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.lgBorder,
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(
              color: isPrimary ? Colors.transparent : roles.borderSubtle,
            ),
            borderRadius: AppRadii.lgBorder,
          ),
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBg,
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 16, color: iconFg),
              ),
              const SizedBox(height: 6),
              Text(
                label,
                style: AppTypography.bodySmBn().copyWith(
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                  color: roles.fgPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title, required this.accent});

  final String title;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: <Widget>[
          Container(
            width: 3,
            height: 16,
            decoration: BoxDecoration(
              color: accent,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Text(
            title,
            style: AppTypography.h3Bn().copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.09,
              color: roles.fgPrimary,
            ),
          ),
        ],
      ),
    );
  }
}

class _DropCapParagraph extends StatelessWidget {
  const _DropCapParagraph({
    required this.text,
    required this.accent,
    required this.bodyColor,
  });

  final String text;
  final Color accent;
  final Color bodyColor;

  @override
  Widget build(BuildContext context) {
    if (text.isEmpty) return const SizedBox.shrink();
    final String first = text.characters.first;
    final String rest = text.substring(first.length);

    final TextStyle bodyStyle = AppTypography.bodyBn().copyWith(
      fontSize: 16,
      height: 1.7,
      color: bodyColor,
    );
    final TextStyle dropStyle = AppTypography.h1Bn().copyWith(
      fontSize: 44,
      fontWeight: FontWeight.w700,
      height: 1,
      color: accent,
    );

    return Text.rich(
      TextSpan(
        children: <InlineSpan>[
          WidgetSpan(
            alignment: PlaceholderAlignment.top,
            child: Padding(
              padding: const EdgeInsets.only(right: 8, top: 4),
              child: Text(first, style: dropStyle),
            ),
          ),
          TextSpan(text: rest, style: bodyStyle),
        ],
      ),
    );
  }
}

class _InfoCard extends ConsumerWidget {
  const _InfoCard({
    required this.holiday,
    required this.bn,
    required this.hi,
  });

  final Holiday holiday;
  final BanglaDate bn;
  final HijriDate hi;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final bool useBn = ref.watch(useBanglaNumeralsProvider);
    final List<_InfoRowData> rows = <_InfoRowData>[
      _InfoRowData(
        icon: Icons.account_balance,
        label: 'সরকারি ছুটি',
        valueWidget: holiday.isGovernmentHoliday
            ? const _YesPill(text: 'হ্যাঁ')
            : _NeutralPill(text: 'না', color: roles.fgTertiary),
      ),
      _InfoRowData(
        icon: Icons.account_balance_wallet_outlined,
        label: 'ব্যাংক বন্ধ',
        valueWidget: holiday.banksClosed
            ? const _YesPill(text: 'হ্যাঁ')
            : _NeutralPill(text: 'না', color: roles.fgTertiary),
      ),
      _InfoRowData(
        icon: Icons.calendar_today_outlined,
        label: 'বাংলা',
        valueText: bn.formatFullBn(useBanglaNumerals: useBn),
      ),
      _InfoRowData(
        icon: Icons.brightness_3,
        label: 'হিজরি',
        valueText: hi.formatFullBn(useBanglaNumerals: useBn),
      ),
      _InfoRowData(
        icon: Icons.public,
        label: 'পালিত হয়',
        valueText: holiday.type == HolidayType.international
            ? 'আন্তর্জাতিকভাবে'
            : 'বাংলাদেশ',
      ),
    ];

    return Container(
      decoration: BoxDecoration(
        color: roles.bgSurface,
        borderRadius: AppRadii.lgBorder,
        border: Border.all(color: roles.borderSubtle),
      ),
      child: Column(
        children: <Widget>[
          for (int i = 0; i < rows.length; i++)
            DecoratedBox(
              decoration: BoxDecoration(
                border: i == rows.length - 1
                    ? null
                    : Border(
                        bottom: BorderSide(color: roles.borderSubtle),
                      ),
              ),
              child: _InfoRow(data: rows[i]),
            ),
        ],
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({required this.data});

  final _InfoRowData data;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      child: Row(
        children: <Widget>[
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: roles.bgSurface2,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(data.icon, size: 14, color: roles.fgSecondary),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              data.label,
              style: AppTypography.bodyBn().copyWith(
                fontSize: 14,
                color: roles.fgSecondary,
              ),
            ),
          ),
          if (data.valueWidget != null)
            data.valueWidget!
          else
            Text(
              data.valueText ?? '',
              style: AppTypography.bodyBn().copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: roles.fgPrimary,
              ),
            ),
        ],
      ),
    );
  }
}

class _InfoRowData {
  const _InfoRowData({
    required this.icon,
    required this.label,
    this.valueText,
    this.valueWidget,
  }) : assert(
          valueText != null || valueWidget != null,
          'Either valueText or valueWidget must be provided',
        );

  final IconData icon;
  final String label;
  final String? valueText;
  final Widget? valueWidget;
}

class _YesPill extends StatelessWidget {
  const _YesPill({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: const BoxDecoration(
        color: AppColors.successTint,
        borderRadius: AppRadii.pillBorder,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          const Icon(Icons.check, size: 11, color: AppColors.success),
          const SizedBox(width: 3),
          Text(
            text,
            style: AppTypography.bodySmBn().copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.success,
            ),
          ),
        ],
      ),
    );
  }
}

class _NeutralPill extends StatelessWidget {
  const _NeutralPill({required this.text, required this.color});

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: AppRadii.pillBorder,
      ),
      child: Text(
        text,
        style: AppTypography.bodySmBn().copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}
