import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import '../../../../core/errors/exceptions.dart';
import '../models/holiday_model.dart';

/// Loads `assets/data/holidays_<year>.json` once per year and caches the
/// parsed list in memory. Uses [AssetBundle] so tests can swap in a fake.
class HolidayLocalDataSource {
  HolidayLocalDataSource({AssetBundle? bundle})
      : _bundle = bundle ?? rootBundle;

  final AssetBundle _bundle;
  final Map<int, Future<List<HolidayModel>>> _cache =
      <int, Future<List<HolidayModel>>>{};

  Future<List<HolidayModel>> loadAll(int year) {
    return _cache[year] ??= _load(year);
  }

  Future<List<HolidayModel>> _load(int year) async {
    final String assetPath = 'assets/data/holidays_$year.json';
    final String raw;
    try {
      raw = await _bundle.loadString(assetPath);
    } on FlutterError catch (e) {
      throw CacheException('Holidays asset not found: $assetPath ($e)');
    }
    try {
      final List<dynamic> decoded = json.decode(raw) as List<dynamic>;
      final List<HolidayModel> holidays = <HolidayModel>[
        for (final dynamic entry in decoded)
          HolidayModel.fromJson(entry as Map<String, dynamic>),
      ];
      holidays.sort(
        (HolidayModel a, HolidayModel b) => a.date.compareTo(b.date),
      );
      return holidays;
    } on FormatException catch (e) {
      throw CacheException('Invalid JSON in $assetPath: ${e.message}');
    }
  }
}
