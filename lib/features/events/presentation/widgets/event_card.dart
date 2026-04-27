import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../features/settings/presentation/providers/settings_provider.dart';
import '../../../../shared/theme/theme.dart';
import '../../domain/entities/event_category.dart';
import '../../domain/entities/personal_event.dart';
import '../../domain/entities/recurrence_rule.dart';

/// List card for a single personal event. Mirrors the event-row pattern
/// from BongoCal Home Screen.html: thin colored stripe (event color),
/// emoji icon, title + meta line, time block on the right.
class EventCard extends ConsumerWidget {
  const EventCard({
    required this.event,
    required this.onTap,
    super.key,
  });

  final PersonalEvent event;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final String Function(int) digits =
        ref.watch(numeralFormatterProvider);
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final Color accent = Color(event.colorValue);
    final bool isDark = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: roles.bgSurface,
      borderRadius: AppRadii.lgBorder,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.lgBorder,
        child: Ink(
          decoration: BoxDecoration(
            color: roles.bgSurface,
            borderRadius: AppRadii.lgBorder,
            border: Border.all(color: roles.borderSubtle),
            boxShadow: isDark ? AppShadows.xsDark : AppShadows.xsLight,
          ),
          padding: const EdgeInsets.fromLTRB(12, 12, 14, 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Container(
                width: 4,
                height: 44,
                decoration: BoxDecoration(
                  color: accent,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
              const SizedBox(width: 12),
              _CategoryIcon(category: event.category, accent: accent),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      event.title,
                      style: AppTypography.h3Bn().copyWith(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: roles.fgPrimary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _metaLine(event),
                      style: AppTypography.bodySmEn().copyWith(
                        fontSize: 12,
                        color: roles.fgTertiary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              _TimeBlock(
                event: event,
                accent: accent,
                roles: roles,
                digits: digits,
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _metaLine(PersonalEvent e) {
    final List<String> parts = <String>[];
    if (e.isAllDay) {
      parts.add('সারাদিন');
    } else if (e.startMinutes != null) {
      parts.add(_formatTimeBn(e.startMinutes!));
    }
    if (e.recurrence != RecurrenceRule.none) {
      parts.add(e.recurrence.displayBn);
    }
    if (e.description.isNotEmpty && parts.length < 2) {
      parts.add(e.description.split('\n').first);
    }
    return parts.join(' · ');
  }

  static String _formatTimeBn(int minutes) {
    final int h = minutes ~/ 60;
    final int m = minutes % 60;
    final int displayH = h == 0
        ? 12
        : h > 12
            ? h - 12
            : h;
    final String period = h < 12 ? 'AM' : 'PM';
    return '${displayH.toString()}:${m.toString().padLeft(2, '0')} $period';
  }
}

class _CategoryIcon extends StatelessWidget {
  const _CategoryIcon({required this.category, required this.accent});

  final EventCategory category;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: accent.withValues(alpha: 0.10),
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(
        category.emoji,
        style: const TextStyle(fontSize: 18),
      ),
    );
  }
}

class _TimeBlock extends StatelessWidget {
  const _TimeBlock({
    required this.event,
    required this.accent,
    required this.roles,
    required this.digits,
  });

  final PersonalEvent event;
  final Color accent;
  final AppColorRoles roles;
  final String Function(int) digits;

  @override
  Widget build(BuildContext context) {
    final DateTime d = event.date;
    final String month = const <String>[
      'JAN',
      'FEB',
      'MAR',
      'APR',
      'MAY',
      'JUN',
      'JUL',
      'AUG',
      'SEP',
      'OCT',
      'NOV',
      'DEC',
    ][d.month - 1];

    return Container(
      width: 48,
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: BoxDecoration(
        color: roles.bgSurface2,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Text(
            month,
            style: AppTypography.captionEn().copyWith(
              color: accent,
              fontSize: 9,
              fontWeight: FontWeight.w700,
              letterSpacing: 1.2,
            ),
          ),
          Text(
            digits(d.day),
            style: AppTypography.h3En().copyWith(
              color: roles.fgPrimary,
              fontSize: 18,
              fontWeight: FontWeight.w600,
              height: 1,
            ),
          ),
        ],
      ),
    );
  }
}
