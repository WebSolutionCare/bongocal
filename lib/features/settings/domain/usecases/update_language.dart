import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/language_preference.dart';
import '../repositories/settings_repository.dart';

class UpdateLanguage {
  const UpdateLanguage(this._repository);

  final SettingsRepository _repository;

  Future<Either<Failure, void>> call(LanguagePreference language) async {
    final current = await _repository.getSettings();
    return current.fold(
      (f) async => Left<Failure, void>(f),
      (s) => _repository.updateSettings(s.copyWith(language: language)),
    );
  }
}
