import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/theme_preference.dart';
import '../repositories/settings_repository.dart';

class UpdateTheme {
  const UpdateTheme(this._repository);

  final SettingsRepository _repository;

  Future<Either<Failure, void>> call(ThemePreference theme) async {
    final current = await _repository.getSettings();
    return current.fold(
      (f) async => Left<Failure, void>(f),
      (s) => _repository.updateSettings(s.copyWith(themeMode: theme)),
    );
  }
}
