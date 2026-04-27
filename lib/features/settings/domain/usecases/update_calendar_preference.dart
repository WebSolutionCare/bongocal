import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/primary_calendar_preference.dart';
import '../entities/week_start_preference.dart';
import '../repositories/settings_repository.dart';

class UpdateCalendarPreference {
  const UpdateCalendarPreference(this._repository);

  final SettingsRepository _repository;

  Future<Either<Failure, void>> call({
    PrimaryCalendarPreference? primary,
    WeekStartPreference? weekStart,
    bool? showBanglaNumerals,
  }) async {
    final current = await _repository.getSettings();
    return current.fold(
      (f) async => Left<Failure, void>(f),
      (s) => _repository.updateSettings(
        s.copyWith(
          primaryCalendar: primary,
          weekStartDay: weekStart,
          showBanglaNumerals: showBanglaNumerals,
        ),
      ),
    );
  }
}
