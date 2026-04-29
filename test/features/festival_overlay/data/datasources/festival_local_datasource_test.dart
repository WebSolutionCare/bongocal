import 'dart:io';

import 'package:bongocal/features/festival_overlay/data/datasources/festival_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tempDir;
  late Box<dynamic> box;
  late FestivalLocalDataSource ds;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('bongocal_festival_');
    Hive.init(tempDir.path);
    box = await Hive.openBox<dynamic>(
      'festival_test_${tempDir.path.hashCode}',
    );
    ds = FestivalLocalDataSource(box: box);
  });

  tearDown(() async {
    await box.close();
    await tempDir.delete(recursive: true);
  });

  test('readLastShown defaults to null when nothing is stored', () {
    expect(ds.readLastShown('eid_ul_fitr'), isNull);
  });

  test('round-trips a single (festivalId, date) entry', () async {
    await ds.writeLastShown(
      festivalId: 'pohela_boishakh',
      date: DateTime(2026, 4, 14),
    );
    expect(ds.readLastShown('pohela_boishakh'), '2026-04-14');
  });

  test('clear() wipes the ledger', () async {
    await ds.writeLastShown(
      festivalId: 'eid_ul_adha',
      date: DateTime(2026, 5, 28),
    );
    await ds.clear();
    expect(ds.readLastShown('eid_ul_adha'), isNull);
  });

  test('formatDate is yyyy-MM-dd with zero-padded month + day', () {
    expect(
      FestivalLocalDataSource.formatDate(DateTime(2026, 1, 5)),
      '2026-01-05',
    );
  });
}
