import 'package:equatable/equatable.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../settings/presentation/providers/settings_provider.dart';
import '../../domain/entities/calendar_date.dart';
import '../../domain/entities/month_data.dart';
import '../../domain/repositories/calendar_repository.dart';
import '../../domain/usecases/get_month_data.dart';
import 'calendar_provider.dart';

/// Year + month pair for the visible month view.
class CurrentMonth extends Equatable {
  const CurrentMonth({required this.year, required this.month})
      : assert(month >= 1 && month <= 12, 'month must be 1..12');

  final int year;
  final int month;

  CurrentMonth previous() {
    if (month == 1) return CurrentMonth(year: year - 1, month: 12);
    return CurrentMonth(year: year, month: month - 1);
  }

  CurrentMonth next() {
    if (month == 12) return CurrentMonth(year: year + 1, month: 1);
    return CurrentMonth(year: year, month: month + 1);
  }

  @override
  List<Object?> get props => <Object?>[year, month];
}

/// State for the month view. Defaults to the month containing "today".
class CurrentMonthNotifier extends Notifier<CurrentMonth> {
  @override
  CurrentMonth build() {
    final DateTime now = ref.watch(clockProvider)();
    return CurrentMonth(year: now.year, month: now.month);
  }

  void goToPrevious() => state = state.previous();
  void goToNext() => state = state.next();

  void goTo(int year, int month) =>
      state = CurrentMonth(year: year, month: month);

  void goToToday() {
    final DateTime now = ref.read(clockProvider)();
    state = CurrentMonth(year: now.year, month: now.month);
  }
}

final NotifierProvider<CurrentMonthNotifier, CurrentMonth> currentMonthProvider =
    NotifierProvider<CurrentMonthNotifier, CurrentMonth>(
  CurrentMonthNotifier.new,
);

/// Re-runs whenever [currentMonthProvider] changes. Holds the 6×7 grid for
/// the visible month.
final FutureProvider<MonthData> monthDataProvider =
    FutureProvider<MonthData>((Ref ref) async {
  final CalendarRepository repo = ref.watch(calendarRepositoryProvider);
  final CurrentMonth current = ref.watch(currentMonthProvider);
  final result = await GetMonthData(repo).call(
    GetMonthDataParams(year: current.year, month: current.month),
  );
  return result.fold(
    (f) => throw StateError('monthDataProvider failed: ${f.message ?? f}'),
    (d) => d,
  );
});

/// Subtitle for the month header: `১৪৩২ বঙ্গাব্দ · ১৪৪৭ হিজরি`.
///
/// Derived from the first day of the visible month for a stable label even
/// when the month spans two BS or Hijri years.
final FutureProvider<String> monthSubtitleProvider =
    FutureProvider<String>((Ref ref) async {
  final CalendarRepository repo = ref.watch(calendarRepositoryProvider);
  final CurrentMonth current = ref.watch(currentMonthProvider);
  final bool useBn = ref.watch(useBanglaNumeralsProvider);
  final DateTime firstOfMonth = DateTime(current.year, current.month, 1);
  final result = await repo.convertToAllCalendars(firstOfMonth);
  return result.fold(
    (f) => throw StateError('monthSubtitleProvider failed: ${f.message ?? f}'),
    (CalendarDate cd) =>
        '${cd.bangla.yearBnFormatted(useBanglaNumerals: useBn)} বঙ্গাব্দ · '
        '${cd.hijri.yearBnFormatted(useBanglaNumerals: useBn)} হিজরি',
  );
});
