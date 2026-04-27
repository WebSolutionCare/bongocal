import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/clock_provider.dart';
import '../../../events/presentation/providers/events_provider.dart';
import '../../../holidays/presentation/providers/holidays_provider.dart';
import '../../data/repositories/calendar_repository_impl.dart';
import '../../domain/entities/calendar_date.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../../domain/usecases/convert_date.dart';
import '../../domain/usecases/get_today.dart';

export '../../../../core/clock_provider.dart';

final Provider<CalendarRepository> calendarRepositoryProvider =
    Provider<CalendarRepository>((Ref ref) {
  // Re-derive the calendar repo whenever events are mutated so the month
  // grid's event-dot marks stay in sync.
  ref.watch(eventsRevisionProvider);
  return CalendarRepositoryImpl(
    now: ref.watch(clockProvider),
    holidayRepository: ref.watch(holidayRepositoryProvider),
    eventRepository: ref.watch(eventRepositoryProvider),
  );
});

/// Today resolved into the three calendars.
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
