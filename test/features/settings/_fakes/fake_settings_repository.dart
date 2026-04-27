import 'dart:async';

import 'package:bongocal/core/errors/failures.dart';
import 'package:bongocal/features/settings/domain/entities/app_settings.dart';
import 'package:bongocal/features/settings/domain/repositories/settings_repository.dart';
import 'package:dartz/dartz.dart';

/// In-memory fake for unit + widget tests. Exposes a broadcast stream so
/// multiple watchers (provider + assertions) all see updates.
class FakeSettingsRepository implements SettingsRepository {
  FakeSettingsRepository({AppSettings? initial})
      : _settings = initial ?? AppSettings.defaults() {
    _controller.add(_settings);
  }

  AppSettings _settings;
  final StreamController<AppSettings> _controller =
      StreamController<AppSettings>.broadcast();

  AppSettings get currentForTest => _settings;

  @override
  Future<Either<Failure, AppSettings>> getSettings() async =>
      Right<Failure, AppSettings>(_settings);

  @override
  Future<Either<Failure, void>> updateSettings(AppSettings settings) async {
    _settings = settings;
    _controller.add(settings);
    return const Right<Failure, void>(null);
  }

  @override
  Stream<AppSettings> watchSettings() async* {
    // Replay current value first, then forward subsequent updates.
    yield _settings;
    yield* _controller.stream;
  }

  Future<void> dispose() => _controller.close();
}
