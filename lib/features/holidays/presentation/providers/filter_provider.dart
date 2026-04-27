import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../domain/entities/holiday.dart';
import '../../domain/entities/holiday_type.dart';
import 'holidays_provider.dart';

/// Selected filter on the holidays list. `null` means "show all".
final StateProvider<HolidayType?> holidayTypeFilterProvider =
    StateProvider<HolidayType?>((Ref ref) => null);

/// Holidays for the visible year, filtered by [holidayTypeFilterProvider].
final FutureProvider<List<Holiday>> filteredHolidaysProvider =
    FutureProvider<List<Holiday>>((Ref ref) async {
  final List<Holiday> all = await ref.watch(holidaysForYearProvider.future);
  final HolidayType? filter = ref.watch(holidayTypeFilterProvider);
  if (filter == null) return all;
  return <Holiday>[
    for (final Holiday h in all)
      if (h.type == filter) h,
  ];
});
