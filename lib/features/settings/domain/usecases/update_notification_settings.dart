import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../repositories/settings_repository.dart';

class UpdateNotificationSettings {
  const UpdateNotificationSettings(this._repository);

  final SettingsRepository _repository;

  Future<Either<Failure, void>> call({
    bool? notificationsEnabled,
    List<int>? holidayReminderDays,
    String? eventReminderSound,
    bool? festivalGreetingsEnabled,
  }) async {
    final current = await _repository.getSettings();
    return current.fold(
      (f) async => Left<Failure, void>(f),
      (s) => _repository.updateSettings(
        s.copyWith(
          notificationsEnabled: notificationsEnabled,
          holidayReminderDays: holidayReminderDays,
          eventReminderSound: eventReminderSound,
          festivalGreetingsEnabled: festivalGreetingsEnabled,
        ),
      ),
    );
  }
}
