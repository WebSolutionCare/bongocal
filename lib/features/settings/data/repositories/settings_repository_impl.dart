import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../../domain/entities/app_settings.dart';
import '../../domain/repositories/settings_repository.dart';
import '../datasources/settings_local_datasource.dart';
import '../models/app_settings_model.dart';

class SettingsRepositoryImpl implements SettingsRepository {
  SettingsRepositoryImpl({required SettingsLocalDataSource dataSource})
      : _dataSource = dataSource;

  final SettingsLocalDataSource _dataSource;

  @override
  Future<Either<Failure, AppSettings>> getSettings() async {
    try {
      final AppSettingsModel? stored = _dataSource.read();
      return Right<Failure, AppSettings>(stored ?? AppSettings.defaults());
    } on Exception catch (e) {
      return Left<Failure, AppSettings>(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateSettings(AppSettings settings) async {
    try {
      await _dataSource.write(AppSettingsModel.fromEntity(settings));
      return const Right<Failure, void>(null);
    } on Exception catch (e) {
      return Left<Failure, void>(CacheFailure(message: e.toString()));
    }
  }

  @override
  Stream<AppSettings> watchSettings() async* {
    // Seed with current value so subscribers don't need a separate read.
    final AppSettingsModel? initial = _dataSource.read();
    yield initial ?? AppSettings.defaults();
    yield* _dataSource
        .watch()
        .map((AppSettingsModel? m) => m ?? AppSettings.defaults());
  }
}
