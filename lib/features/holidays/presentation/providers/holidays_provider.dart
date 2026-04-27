import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/clock_provider.dart';
import '../../data/datasources/holiday_local_datasource.dart';
import '../../data/repositories/holiday_repository_impl.dart';
import '../../domain/entities/holiday.dart';
import '../../domain/entities/holiday_type.dart';
import '../../domain/repositories/holiday_repository.dart';

final Provider<HolidayLocalDataSource> holidayLocalDataSourceProvider =
    Provider<HolidayLocalDataSource>(
  (Ref ref) => HolidayLocalDataSource(),
);

final Provider<HolidayRepository> holidayRepositoryProvider =
    Provider<HolidayRepository>(
  (Ref ref) => HolidayRepositoryImpl(
    dataSource: ref.watch(holidayLocalDataSourceProvider),
  ),
);

/// Year currently visible on the holidays list. Defaults to the year
/// containing the pinned [clockProvider] today.
final StateProvider<int> selectedHolidayYearProvider = StateProvider<int>(
  (Ref ref) => ref.watch(clockProvider)().year,
);

/// All holidays for [selectedHolidayYearProvider].
final FutureProvider<List<Holiday>> holidaysForYearProvider =
    FutureProvider<List<Holiday>>((Ref ref) async {
  final HolidayRepository repo = ref.watch(holidayRepositoryProvider);
  final int year = ref.watch(selectedHolidayYearProvider);
  final result = await repo.getAllHolidays(year);
  return result.fold(
    (f) => throw StateError('holidaysForYearProvider failed: ${f.message ?? f}'),
    (List<Holiday> list) => list,
  );
});

/// Upcoming holidays from "today" — limit applied at the call site via
/// [getUpcomingHolidaysProvider].
final FutureProvider<List<Holiday>> upcomingHolidaysProvider =
    FutureProvider<List<Holiday>>((Ref ref) async {
  final HolidayRepository repo = ref.watch(holidayRepositoryProvider);
  final DateTime now = ref.watch(clockProvider)();
  final result = await repo.getUpcomingHolidays(from: now);
  return result.fold(
    (f) => throw StateError('upcomingHolidaysProvider failed: ${f.message ?? f}'),
    (List<Holiday> list) => list,
  );
});

/// Convenience: just the next holiday (or null when no future holidays
/// remain in the current year). Used by the home's hero "next holiday" card.
final FutureProvider<Holiday?> nextHolidayProvider =
    FutureProvider<Holiday?>((Ref ref) async {
  final List<Holiday> all = await ref.watch(upcomingHolidaysProvider.future);
  return all.isEmpty ? null : all.first;
});

/// One-off lookup by stable id. Accepts [String] (the URL parameter).
final FutureProviderFamily<Holiday?, String> holidayByIdProvider =
    FutureProvider.family<Holiday?, String>((Ref ref, String id) async {
  final HolidayRepository repo = ref.watch(holidayRepositoryProvider);
  final result = await repo.getHolidayById(id);
  return result.fold(
    (f) => throw StateError('holidayByIdProvider failed: ${f.message ?? f}'),
    (Holiday? h) => h,
  );
});

/// Counts per [HolidayType] for the visible year — drives filter chip badges.
final FutureProvider<Map<HolidayType, int>> holidayCountsProvider =
    FutureProvider<Map<HolidayType, int>>((Ref ref) async {
  final List<Holiday> all = await ref.watch(holidaysForYearProvider.future);
  final Map<HolidayType, int> counts = <HolidayType, int>{
    for (final HolidayType t in HolidayType.values) t: 0,
  };
  for (final Holiday h in all) {
    counts[h.type] = (counts[h.type] ?? 0) + 1;
  }
  return counts;
});
