import 'package:bongocal/features/holidays/data/datasources/holiday_local_datasource.dart';
import 'package:bongocal/features/holidays/data/models/holiday_model.dart';
import 'package:bongocal/features/holidays/domain/entities/holiday_type.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

class _FakeBundle extends CachingAssetBundle {
  _FakeBundle({this.payload});

  final String? payload;
  int loadCount = 0;

  @override
  Future<ByteData> load(String key) async {
    throw UnimplementedError();
  }

  @override
  Future<String> loadString(String key, {bool cache = true}) async {
    loadCount++;
    if (payload == null) {
      throw FlutterError('asset $key not found');
    }
    return payload!;
  }
}

void main() {
  const String happyPayload = '''
[
  {
    "id": "boishakh",
    "nameBn": "পহেলা বৈশাখ",
    "nameEn": "Pohela Boishakh",
    "dateEnglish": "2026-04-14",
    "type": "religious",
    "descBn": "বাঙালির নববর্ষ।",
    "descEn": "Bengali New Year.",
    "banksClosed": true,
    "govHoliday": true,
    "isObservance": false
  },
  {
    "id": "language_day",
    "nameBn": "শহীদ দিবস",
    "nameEn": "Language Martyrs Day",
    "dateEnglish": "2026-02-21",
    "type": "government_national",
    "descBn": "১৯৫২ সালের ভাষা শহীদদের স্মরণে।",
    "descEn": "Honoring the 1952 language martyrs.",
    "banksClosed": true,
    "govHoliday": true,
    "isObservance": false
  }
]
''';

  test('parses, sorts ascending, and caches per year', () async {
    final _FakeBundle bundle = _FakeBundle(payload: happyPayload);
    final HolidayLocalDataSource ds =
        HolidayLocalDataSource(bundle: bundle);

    final List<HolidayModel> first = await ds.loadAll(2026);
    expect(first.length, 2);
    expect(first.first.id, 'language_day');
    expect(first.last.id, 'boishakh');
    expect(first.first.type, HolidayType.governmentNational);
    expect(first.last.type, HolidayType.religious);
    expect(first.first.date, DateTime(2026, 2, 21));

    // Cache hit — bundle should not be hit again. Both calls share the
    // same cached Future, so the resolved list is the very same instance.
    final List<HolidayModel> second = await ds.loadAll(2026);
    expect(
      identical(first, second),
      isTrue,
      reason: 'second call must return the cached list, not re-parse',
    );
    expect(bundle.loadCount, 1);
  });

  test('throws CacheException when asset is missing', () async {
    final HolidayLocalDataSource ds =
        HolidayLocalDataSource(bundle: _FakeBundle());
    await expectLater(
      ds.loadAll(2099),
      throwsA(isA<Exception>()),
    );
  });
}
