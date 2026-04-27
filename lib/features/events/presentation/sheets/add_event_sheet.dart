import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/clock_provider.dart';
import '../../../../core/notifications/notifications_service.dart';
import '../../../../shared/theme/theme.dart';
import '../../domain/entities/event_category.dart';
import '../../domain/entities/personal_event.dart';
import '../../domain/entities/recurrence_rule.dart';
import '../../domain/repositories/event_repository.dart';
import '../providers/events_provider.dart';
import '../widgets/category_picker.dart';
import '../widgets/color_picker.dart';
import '../widgets/reminder_picker.dart';

/// Open the add/edit sheet. When [existing] is non-null the sheet renders
/// in edit mode (pre-filled fields, save → update). Returns the saved
/// event id, or null when the user cancels.
Future<String?> showAddEventSheet(
  BuildContext context, {
  PersonalEvent? existing,
  DateTime? initialDate,
}) {
  return showModalBottomSheet<String?>(
    context: context,
    isScrollControlled: true,
    useRootNavigator: true,
    backgroundColor: Colors.transparent,
    builder: (BuildContext ctx) => _AddEventSheet(
      existing: existing,
      initialDate: initialDate,
    ),
  );
}

class _AddEventSheet extends ConsumerStatefulWidget {
  const _AddEventSheet({this.existing, this.initialDate});

  final PersonalEvent? existing;
  final DateTime? initialDate;

  @override
  ConsumerState<_AddEventSheet> createState() => _AddEventSheetState();
}

class _AddEventSheetState extends ConsumerState<_AddEventSheet> {
  late final TextEditingController _titleCtrl;
  late final TextEditingController _notesCtrl;

  late DateTime _date;
  late EventCalendarType _calendarType;
  late bool _isAllDay;
  late TimeOfDay _start;
  late TimeOfDay _end;
  late RecurrenceRule _recurrence;
  late EventCategory _category;
  late int _colorValue;
  late Set<int> _reminders;
  bool _saving = false;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    final PersonalEvent? e = widget.existing;
    _titleCtrl = TextEditingController(text: e?.title ?? '');
    _notesCtrl = TextEditingController(text: e?.description ?? '');
    _date = e?.date ??
        widget.initialDate ??
        ref.read(clockProvider)();
    _calendarType = e?.calendarType ?? EventCalendarType.english;
    _isAllDay = e?.isAllDay ?? false;
    _start = TimeOfDay(
      hour: (e?.startMinutes ?? 600) ~/ 60,
      minute: (e?.startMinutes ?? 600) % 60,
    );
    _end = TimeOfDay(
      hour: (e?.endMinutes ?? 720) ~/ 60,
      minute: (e?.endMinutes ?? 720) % 60,
    );
    _recurrence = e?.recurrence ?? RecurrenceRule.none;
    _category = e?.category ?? EventCategory.custom;
    _colorValue = e?.colorValue ?? kEventColorPalette.first;
    _reminders = <int>{...?e?.reminderMinutesBefore};
  }

  @override
  void dispose() {
    _titleCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  bool get _isEdit => widget.existing != null;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final double maxHeight = MediaQuery.of(context).size.height * 0.92;
    final double bottomInset = MediaQuery.of(context).viewInsets.bottom;

    return ConstrainedBox(
      constraints: BoxConstraints(maxHeight: maxHeight),
      child: Container(
        decoration: BoxDecoration(
          color: roles.bgSurface,
          borderRadius: const BorderRadius.vertical(
            top: Radius.circular(28),
          ),
        ),
        padding: EdgeInsets.only(bottom: bottomInset),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 8),
            // Drag grabber.
            Container(
              width: 36,
              height: 5,
              decoration: BoxDecoration(
                color: roles.borderStrong,
                borderRadius: BorderRadius.circular(999),
              ),
            ),
            _Header(
              title: _isEdit ? 'ইভেন্ট সম্পাদনা' : 'নতুন ইভেন্ট',
              onCancel: () => Navigator.of(context).pop(),
              onSave: _saving ? null : _save,
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    _TitleField(
                      controller: _titleCtrl,
                      emoji: _category.emoji,
                      errorText: _validationError,
                    ),
                    _DateField(
                      date: _date,
                      onPick: _pickDate,
                    ),
                    _CalendarTypeRow(
                      selected: _calendarType,
                      onSelect: (EventCalendarType t) =>
                          setState(() => _calendarType = t),
                    ),
                    _SwitchField(
                      icon: Icons.brightness_5_outlined,
                      iconBg: AppColors.brandGold50,
                      iconColor: AppColors.brandGold700,
                      label: 'সারাদিন',
                      value: _isAllDay,
                      onChanged: (bool v) => setState(() => _isAllDay = v),
                    ),
                    if (!_isAllDay) _TimeRow(
                      start: _start,
                      end: _end,
                      onPickStart: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: _start,
                        );
                        if (picked != null) setState(() => _start = picked);
                      },
                      onPickEnd: () async {
                        final TimeOfDay? picked = await showTimePicker(
                          context: context,
                          initialTime: _end,
                        );
                        if (picked != null) setState(() => _end = picked);
                      },
                    ),
                    _RecurrenceField(
                      selected: _recurrence,
                      onSelect: (RecurrenceRule r) =>
                          setState(() => _recurrence = r),
                    ),
                    const _SectionLabel(text: 'রিমাইন্ডার'),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: ReminderPicker(
                        selected: _reminders,
                        onToggle: (int m) => setState(() {
                          if (!_reminders.add(m)) _reminders.remove(m);
                        }),
                      ),
                    ),
                    const _SectionLabel(text: 'ক্যাটাগরি'),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: CategoryPicker(
                        selected: _category,
                        onSelect: (EventCategory c) =>
                            setState(() => _category = c),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 14),
                      child: Row(
                        children: <Widget>[
                          Text(
                            'রং',
                            style: AppTypography.bodySmBn().copyWith(
                              fontSize: 13,
                              fontWeight: FontWeight.w500,
                              color: roles.fgPrimary,
                            ),
                          ),
                          Expanded(
                            child: ColorPicker(
                              selectedValue: _colorValue,
                              onSelect: (int v) =>
                                  setState(() => _colorValue = v),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const _SectionLabel(text: 'নোট'),
                    TextField(
                      controller: _notesCtrl,
                      maxLines: 4,
                      style: AppTypography.bodyBn().copyWith(
                        fontSize: 14,
                        color: roles.fgPrimary,
                      ),
                      decoration: InputDecoration(
                        hintText: 'অতিরিক্ত বিবরণ যোগ করুন...',
                        hintStyle: AppTypography.bodyBn().copyWith(
                          fontSize: 14,
                          color: roles.fgTertiary,
                        ),
                        filled: true,
                        fillColor: roles.bgSurface2,
                        contentPadding: const EdgeInsets.all(12),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: roles.borderSubtle),
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: BorderSide(color: roles.borderSubtle),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(14),
                          borderSide: const BorderSide(
                            color: AppColors.brandEmerald,
                          ),
                        ),
                      ),
                    ),
                    if (_isEdit) ...<Widget>[
                      const SizedBox(height: 24),
                      TextButton.icon(
                        onPressed: _saving ? null : _delete,
                        icon: const Icon(
                          Icons.delete_outline,
                          color: AppColors.error,
                        ),
                        label: Text(
                          'ইভেন্ট মুছুন',
                          style: AppTypography.bodyBn().copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.error,
                          ),
                        ),
                      ),
                    ],
                    const SizedBox(height: 8),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _date,
      firstDate: DateTime(2020),
      lastDate: DateTime(2035),
    );
    if (picked != null) setState(() => _date = picked);
  }

  Future<void> _save() async {
    final String title = _titleCtrl.text.trim();
    if (title.isEmpty) {
      setState(() => _validationError = 'একটি নাম দিন');
      return;
    }
    setState(() {
      _validationError = null;
      _saving = true;
    });

    final EventRepository repo = ref.read(eventRepositoryProvider);
    final DateTime now = ref.read(clockProvider)();
    final PersonalEvent original = widget.existing ??
        PersonalEvent(
          id: const Uuid().v4(),
          title: title,
          date: _date,
          isAllDay: _isAllDay,
          calendarType: _calendarType,
          recurrence: _recurrence,
          category: _category,
          colorValue: _colorValue,
          reminderMinutesBefore: _reminders.toList()..sort(),
          createdAt: now,
          updatedAt: now,
          startMinutes: _isAllDay ? null : _start.hour * 60 + _start.minute,
          endMinutes: _isAllDay ? null : _end.hour * 60 + _end.minute,
        );

    final PersonalEvent toSave = _isEdit
        ? original.copyWith(
            title: title,
            description: _notesCtrl.text.trim(),
            date: _date,
            isAllDay: _isAllDay,
            calendarType: _calendarType,
            recurrence: _recurrence,
            category: _category,
            colorValue: _colorValue,
            reminderMinutesBefore: _reminders.toList()..sort(),
            updatedAt: now,
            startMinutes: _isAllDay ? null : _start.hour * 60 + _start.minute,
            endMinutes: _isAllDay ? null : _end.hour * 60 + _end.minute,
          )
        : original.copyWith(description: _notesCtrl.text.trim());

    final result = _isEdit
        ? await repo.updateEvent(toSave)
        : await repo.createEvent(toSave);

    await result.fold<Future<void>>(
      (Object f) async {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('সংরক্ষণ করা যায়নি · $f')),
        );
      },
      (_) async {
        await _scheduleReminders(toSave);
        ref.read(eventsRevisionProvider.notifier).bump();
        if (!mounted) return;
        Navigator.of(context).pop(toSave.id);
      },
    );
    if (mounted) setState(() => _saving = false);
  }

  Future<void> _delete() async {
    final PersonalEvent? e = widget.existing;
    if (e == null) return;
    setState(() => _saving = true);
    final EventRepository repo = ref.read(eventRepositoryProvider);
    final result = await repo.deleteEvent(e.id);
    await result.fold<Future<void>>(
      (Object f) async {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('মুছে ফেলা যায়নি · $f')),
        );
      },
      (_) async {
        await _cancelReminders(e);
        ref.read(eventsRevisionProvider.notifier).bump();
        if (!mounted) return;
        Navigator.of(context).pop();
      },
    );
    if (mounted) setState(() => _saving = false);
  }

  Future<void> _scheduleReminders(PersonalEvent e) async {
    if (e.isAllDay && e.reminderMinutesBefore.isEmpty) return;
    final DateTime base = e.startMinutes != null
        ? DateTime(
            e.date.year,
            e.date.month,
            e.date.day,
            e.startMinutes! ~/ 60,
            e.startMinutes! % 60,
          )
        : DateTime(e.date.year, e.date.month, e.date.day, 9);
    for (final int minutes in e.reminderMinutesBefore) {
      final DateTime when = base.subtract(Duration(minutes: minutes));
      if (when.isBefore(ref.read(clockProvider)())) continue;
      await NotificationsService.instance.scheduleAt(
        id: _notificationId(e.id, minutes),
        title: e.title,
        body: '${e.title} starts in ${reminderLabelBn(minutes)}',
        whenLocal: when,
      );
    }
  }

  Future<void> _cancelReminders(PersonalEvent e) async {
    for (final int minutes in e.reminderMinutesBefore) {
      await NotificationsService.instance
          .cancel(_notificationId(e.id, minutes));
    }
  }

  /// Stable 31-bit notification id derived from (eventId, minutes).
  static int _notificationId(String eventId, int minutes) =>
      '${eventId}_$minutes'.hashCode & 0x7FFFFFFF;
}

class _Header extends StatelessWidget {
  const _Header({
    required this.title,
    required this.onCancel,
    required this.onSave,
  });

  final String title;
  final VoidCallback onCancel;
  final VoidCallback? onSave;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Container(
      padding: const EdgeInsets.fromLTRB(8, 12, 12, 12),
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: roles.borderSubtle)),
      ),
      child: Row(
        children: <Widget>[
          TextButton(
            onPressed: onCancel,
            child: Text(
              'বাতিল',
              style: AppTypography.bodyBn().copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w500,
                color: roles.fgSecondary,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Text(
                title,
                style: AppTypography.h3Bn().copyWith(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: roles.fgPrimary,
                ),
              ),
            ),
          ),
          FilledButton(
            onPressed: onSave,
            style: FilledButton.styleFrom(
              backgroundColor: AppColors.brandEmerald,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
              shape: const RoundedRectangleBorder(
                borderRadius: AppRadii.pillBorder,
              ),
            ),
            child: Text(
              'সংরক্ষণ',
              style: AppTypography.bodyBn().copyWith(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TitleField extends StatelessWidget {
  const _TitleField({
    required this.controller,
    required this.emoji,
    required this.errorText,
  });

  final TextEditingController controller;
  final String emoji;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Padding(
      padding: const EdgeInsets.only(top: 6, bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: const EdgeInsets.symmetric(vertical: 2),
            decoration: BoxDecoration(
              border: Border(bottom: BorderSide(color: roles.borderSubtle)),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: roles.bgSurface2,
                    border: Border.all(color: roles.borderSubtle),
                    borderRadius: AppRadii.mdBorder,
                  ),
                  alignment: Alignment.center,
                  child: Text(emoji, style: const TextStyle(fontSize: 22)),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: TextField(
                    controller: controller,
                    style: AppTypography.h2Bn().copyWith(
                      fontSize: 22,
                      fontWeight: FontWeight.w600,
                      letterSpacing: -0.22,
                      color: roles.fgPrimary,
                    ),
                    decoration: InputDecoration(
                      hintText: 'ইভেন্টের নাম...',
                      hintStyle: AppTypography.h2Bn().copyWith(
                        fontSize: 22,
                        fontWeight: FontWeight.w500,
                        color: roles.fgTertiary,
                      ),
                      border: InputBorder.none,
                      contentPadding: const EdgeInsets.symmetric(vertical: 4),
                      isDense: true,
                    ),
                  ),
                ),
              ],
            ),
          ),
          if (errorText != null)
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Text(
                errorText!,
                style: AppTypography.bodySmBn().copyWith(
                  fontSize: 12,
                  color: AppColors.error,
                ),
              ),
            ),
        ],
      ),
    );
  }
}

class _DateField extends StatelessWidget {
  const _DateField({required this.date, required this.onPick});

  final DateTime date;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final String label = '${date.day} ${_monthEn(date.month)} ${date.year}';
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: roles.borderSubtle)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            children: <Widget>[
              const _FieldIcon(
                icon: Icons.calendar_today_outlined,
                bg: AppColors.brandEmerald50,
                fg: AppColors.brandEmerald,
              ),
              const SizedBox(width: 12),
              Text(
                'তারিখ',
                style: AppTypography.bodyBn().copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: roles.fgPrimary,
                ),
              ),
              const Spacer(),
              Material(
                color: AppColors.brandEmerald50,
                borderRadius: AppRadii.pillBorder,
                child: InkWell(
                  onTap: onPick,
                  borderRadius: AppRadii.pillBorder,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          label,
                          style: AppTypography.bodySmEn().copyWith(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.brandEmerald,
                          ),
                        ),
                        const SizedBox(width: 4),
                        const Icon(
                          Icons.chevron_right,
                          size: 16,
                          color: AppColors.brandEmerald,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _monthEn(int m) => const <String>[
        'January',
        'February',
        'March',
        'April',
        'May',
        'June',
        'July',
        'August',
        'September',
        'October',
        'November',
        'December',
      ][m - 1];
}

class _CalendarTypeRow extends StatelessWidget {
  const _CalendarTypeRow({required this.selected, required this.onSelect});

  final EventCalendarType selected;
  final ValueChanged<EventCalendarType> onSelect;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: roles.borderSubtle)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            children: <Widget>[
              Text(
                'তারিখ ফরম্যাট',
                style: AppTypography.bodySmBn().copyWith(
                  fontSize: 13,
                  color: roles.fgTertiary,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(3),
                decoration: BoxDecoration(
                  color: roles.bgSurface2,
                  border: Border.all(color: roles.borderSubtle),
                  borderRadius: AppRadii.pillBorder,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    for (final EventCalendarType t in EventCalendarType.values)
                      _SegButton(
                        label: t.displayBn,
                        isSelected: t == selected,
                        onTap: () => onSelect(t),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _SegButton extends StatelessWidget {
  const _SegButton({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Material(
      color: isSelected ? roles.bgSurface : Colors.transparent,
      borderRadius: AppRadii.pillBorder,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.pillBorder,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          child: Text(
            label,
            style: AppTypography.bodySmBn().copyWith(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: isSelected ? roles.fgPrimary : roles.fgTertiary,
            ),
          ),
        ),
      ),
    );
  }
}

class _SwitchField extends StatelessWidget {
  const _SwitchField({
    required this.icon,
    required this.iconBg,
    required this.iconColor,
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final Color iconBg;
  final Color iconColor;
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: roles.borderSubtle)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            children: <Widget>[
              _FieldIcon(icon: icon, bg: iconBg, fg: iconColor),
              const SizedBox(width: 12),
              Text(
                label,
                style: AppTypography.bodyBn().copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: roles.fgPrimary,
                ),
              ),
              const Spacer(),
              Switch.adaptive(value: value, onChanged: onChanged),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeRow extends StatelessWidget {
  const _TimeRow({
    required this.start,
    required this.end,
    required this.onPickStart,
    required this.onPickEnd,
  });

  final TimeOfDay start;
  final TimeOfDay end;
  final VoidCallback onPickStart;
  final VoidCallback onPickEnd;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: roles.borderSubtle)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            children: <Widget>[
              Expanded(
                child: _TimeCard(label: 'শুরু', time: start, onTap: onPickStart),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: _TimeCard(label: 'শেষ', time: end, onTap: onPickEnd),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TimeCard extends StatelessWidget {
  const _TimeCard({
    required this.label,
    required this.time,
    required this.onTap,
  });

  final String label;
  final TimeOfDay time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Material(
      color: roles.bgSurface2,
      borderRadius: AppRadii.lgBorder,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.lgBorder,
        child: Ink(
          decoration: BoxDecoration(
            color: roles.bgSurface2,
            border: Border.all(color: roles.borderSubtle),
            borderRadius: AppRadii.lgBorder,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Text(
                label.toUpperCase(),
                style: AppTypography.captionEn().copyWith(
                  fontSize: 11,
                  color: roles.fgTertiary,
                  letterSpacing: 0.44,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                _format(time),
                style: AppTypography.h2En().copyWith(
                  fontSize: 20,
                  fontWeight: FontWeight.w600,
                  color: roles.fgPrimary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static String _format(TimeOfDay t) {
    final int h = t.hour == 0
        ? 12
        : t.hourOfPeriod == 0
            ? 12
            : t.hourOfPeriod;
    final String period = t.period == DayPeriod.am ? 'AM' : 'PM';
    return '${h.toString()}:${t.minute.toString().padLeft(2, '0')} $period';
  }
}

class _RecurrenceField extends StatelessWidget {
  const _RecurrenceField({required this.selected, required this.onSelect});

  final RecurrenceRule selected;
  final ValueChanged<RecurrenceRule> onSelect;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 14),
      child: DecoratedBox(
        decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: roles.borderSubtle)),
        ),
        child: Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Row(
            children: <Widget>[
              const _FieldIcon(
                icon: Icons.repeat,
                bg: AppColors.brandRed50,
                fg: AppColors.brandRed700,
              ),
              const SizedBox(width: 12),
              Text(
                'পুনরাবৃত্তি',
                style: AppTypography.bodyBn().copyWith(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: roles.fgPrimary,
                ),
              ),
              const Spacer(),
              DropdownButton<RecurrenceRule>(
                value: selected,
                onChanged: (RecurrenceRule? r) {
                  if (r != null) onSelect(r);
                },
                underline: const SizedBox.shrink(),
                items: <DropdownMenuItem<RecurrenceRule>>[
                  for (final RecurrenceRule r in RecurrenceRule.values)
                    DropdownMenuItem<RecurrenceRule>(
                      value: r,
                      child: Text(
                        r.displayBn,
                        style: AppTypography.bodyBn().copyWith(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: roles.fgSecondary,
                        ),
                      ),
                    ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FieldIcon extends StatelessWidget {
  const _FieldIcon({
    required this.icon,
    required this.bg,
    required this.fg,
  });

  final IconData icon;
  final Color bg;
  final Color fg;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 32,
      height: 32,
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, size: 18, color: fg),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 14, 0, 4),
      child: Text(
        text.toUpperCase(),
        style: AppTypography.captionEn().copyWith(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.66,
          color: roles.fgTertiary,
        ),
      ),
    );
  }
}
