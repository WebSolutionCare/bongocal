import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';

import '../../../../core/clock_provider.dart';
import '../../../../core/storage/hive_service.dart';
import '../../../holidays/presentation/providers/holidays_provider.dart';
import '../../../settings/domain/entities/app_settings.dart';
import '../../../settings/presentation/providers/settings_provider.dart';
import '../../data/datasources/festival_greetings_loader.dart';
import '../../data/datasources/festival_local_datasource.dart';
import '../../data/repositories/festival_overlay_repository_impl.dart';
import '../../domain/entities/festival_greeting.dart';
import '../../domain/repositories/festival_overlay_repository.dart';
import '../../domain/usecases/check_festival_for_today.dart';

/// Hive box backing the "last shown" ledger. Pre-opened by [HiveService].
final Provider<Box<dynamic>> festivalStateBoxProvider = Provider<Box<dynamic>>(
  (Ref ref) => Hive.box<dynamic>(HiveBoxes.festivalState),
);

final Provider<FestivalGreetingsLoader> festivalGreetingsLoaderProvider =
    Provider<FestivalGreetingsLoader>(
  (Ref ref) => FestivalGreetingsLoader(),
);

final Provider<FestivalLocalDataSource> festivalLocalDataSourceProvider =
    Provider<FestivalLocalDataSource>(
  (Ref ref) =>
      FestivalLocalDataSource(box: ref.watch(festivalStateBoxProvider)),
);

final Provider<FestivalOverlayRepository> festivalOverlayRepositoryProvider =
    Provider<FestivalOverlayRepository>(
  (Ref ref) => FestivalOverlayRepositoryImpl(
    loader: ref.watch(festivalGreetingsLoaderProvider),
    localDataSource: ref.watch(festivalLocalDataSourceProvider),
    holidayRepository: ref.watch(holidayRepositoryProvider),
  ),
);

final Provider<CheckFestivalForToday> checkFestivalForTodayProvider =
    Provider<CheckFestivalForToday>(
  (Ref ref) =>
      CheckFestivalForToday(ref.watch(festivalOverlayRepositoryProvider)),
);

/// Resolves to the festival greeting (if any) we should display right now.
/// Re-runs whenever the user toggles the festival setting or the clock
/// rolls forward.
final FutureProvider<FestivalGreeting?> festivalForTodayProvider =
    FutureProvider<FestivalGreeting?>((Ref ref) async {
  final AppSettings settings = ref.watch(currentSettingsProvider);
  final DateTime today = ref.watch(clockProvider)();
  final CheckFestivalForToday usecase =
      ref.watch(checkFestivalForTodayProvider);
  final result = await usecase(today: today, settings: settings);
  return result.fold((_) => null, (FestivalGreeting? g) => g);
});
