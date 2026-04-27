import 'package:dartz/dartz.dart';

import '../../../../core/errors/failures.dart';
import '../entities/app_settings.dart';

/// Domain port for app-wide settings. The implementation persists via Hive
/// and exposes a [Stream] so the UI rebuilds when any field changes.
abstract class SettingsRepository {
  /// One-shot read of the current settings (or defaults if nothing is
  /// persisted yet).
  Future<Either<Failure, AppSettings>> getSettings();

  /// Persist the supplied settings, replacing the previous record. Emits
  /// the new value on [watchSettings].
  Future<Either<Failure, void>> updateSettings(AppSettings settings);

  /// Reactive stream of the current settings. The first event is the
  /// already-persisted value (or defaults).
  Stream<AppSettings> watchSettings();
}
