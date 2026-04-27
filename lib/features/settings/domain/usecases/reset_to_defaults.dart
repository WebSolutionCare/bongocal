import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class ResetToDefaults {
  const ResetToDefaults(this._repository);

  final SettingsRepository _repository;

  Future<Either<Failure, void>> call() =>
      _repository.updateSettings(AppSettings.defaults());
}
