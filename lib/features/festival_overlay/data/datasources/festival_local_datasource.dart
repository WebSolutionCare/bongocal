import 'package:hive/hive.dart';

/// Hive-backed "last shown" ledger for the festival overlay. Keeps the
/// dates as `yyyy-MM-dd` strings so DST / timezone shifts don't make us
/// reshow yesterday's overlay at midnight.
class FestivalLocalDataSource {
  FestivalLocalDataSource({required Box<dynamic> box}) : _box = box;

  static const String _lastShownKey = 'last_shown_for';

  final Box<dynamic> _box;

  /// `yyyy-MM-dd` of the last day on which [festivalId] was shown,
  /// or null when never.
  String? readLastShown(String festivalId) {
    final Map<String, String> all = _readAll();
    return all[festivalId];
  }

  /// Mark [festivalId] as shown on [date] (date-only — time is dropped).
  Future<void> writeLastShown({
    required String festivalId,
    required DateTime date,
  }) async {
    final Map<String, String> all = Map<String, String>.from(_readAll());
    all[festivalId] = formatDate(date);
    await _box.put(_lastShownKey, all);
  }

  /// Wipe the ledger — exposed for tests + a future "reset" affordance.
  Future<void> clear() async {
    await _box.put(_lastShownKey, <String, String>{});
  }

  Map<String, String> _readAll() {
    final dynamic raw = _box.get(_lastShownKey);
    if (raw is Map) {
      return <String, String>{
        for (final MapEntry<dynamic, dynamic> e in raw.entries)
          if (e.key is String && e.value is String) e.key as String: e.value as String,
      };
    }
    return const <String, String>{};
  }

  /// `yyyy-MM-dd` — public for tests + reuse from the repo impl.
  static String formatDate(DateTime d) {
    final String mm = d.month.toString().padLeft(2, '0');
    final String dd = d.day.toString().padLeft(2, '0');
    return '${d.year}-$mm-$dd';
  }
}
