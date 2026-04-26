import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/repositories/calendar_repository_impl.dart';
import '../../domain/entities/calendar_date.dart';
import '../../domain/entities/upcoming_holiday.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../../domain/usecases/convert_date.dart';
import '../../domain/usecases/get_today.dart';

/// Pinned "today" so the placeholder build matches the design references.
///
/// Replace with `DateTime.now` once Phase 1 onboarding lands. Tests override
/// this via `ProviderScope.overrides`.
DateTime _defaultNow() => DateTime(2026, 4, 27);

/// Function returning current `DateTime`. Treat this as the canonical clock
/// for the calendar feature; production code reads it via [Ref.watch].
final Provider<DateTime Function()> clockProvider =
    Provider<DateTime Function()>((Ref ref) => _defaultNow);

final Provider<CalendarRepository> calendarRepositoryProvider =
    Provider<CalendarRepository>(
  (Ref ref) => CalendarRepositoryImpl(now: ref.watch(clockProvider)),
);

/// Today resolved into the three calendars. Auto-dispose so a hot-restart or
/// clock override is picked up immediately.
final FutureProvider<CalendarDate> todayProvider =
    FutureProvider<CalendarDate>((Ref ref) async {
  final CalendarRepository repo = ref.watch(calendarRepositoryProvider);
  final result = await GetToday(repo).call();
  return result.fold(
    (f) => throw StateError('todayProvider failed: ${f.message ?? f}'),
    (d) => d,
  );
});

/// User's currently-selected day on the month view. `null` → no selection.
final StateProvider<DateTime?> selectedDateProvider =
    StateProvider<DateTime?>((Ref ref) => null);

/// 7-day Sat-first strip centered on the week containing "today".
final FutureProvider<List<CalendarDate>> weekStripProvider =
    FutureProvider<List<CalendarDate>>((Ref ref) async {
  final CalendarRepository repo = ref.watch(calendarRepositoryProvider);
  final CalendarDate today = await ref.watch(todayProvider.future);
  final DateTime weekStart =
      today.gregorian.subtract(Duration(days: today.weekdayIndexSatFirst));
  final ConvertDate convert = ConvertDate(repo);

  final List<CalendarDate> days = <CalendarDate>[];
  for (int i = 0; i < 7; i++) {
    final DateTime d = weekStart.add(Duration(days: i));
    final result = await convert(d);
    days.add(
      result.fold(
        (f) => throw StateError('weekStripProvider failed: ${f.message ?? f}'),
        (cd) => cd,
      ),
    );
  }
  return days;
});

/// Next upcoming holiday relative to "today" (or null if none seeded).
final FutureProvider<UpcomingHoliday?> nextHolidayProvider =
    FutureProvider<UpcomingHoliday?>((Ref ref) async {
  final CalendarRepository repo = ref.watch(calendarRepositoryProvider);
  final CalendarDate today = await ref.watch(todayProvider.future);
  final result = await repo.getNextHoliday(today.gregorian);
  return result.fold(
    (f) => throw StateError('nextHolidayProvider failed: ${f.message ?? f}'),
    (h) => h,
  );
});
