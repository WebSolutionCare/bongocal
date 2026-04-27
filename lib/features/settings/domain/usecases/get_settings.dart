import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/app_settings.dart';
import '../repositories/settings_repository.dart';

class GetSettings {
  const GetSettings(this._repository);

  final SettingsRepository _repository;

  Future<Either<Failure, AppSettings>> call() => _repository.getSettings();
}
