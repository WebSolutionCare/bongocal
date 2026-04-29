import 'dart:io';

import 'package:bongocal/features/onboarding/data/datasources/onboarding_local_datasource.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';

void main() {
  late Directory tempDir;
  late Box<dynamic> box;
  late OnboardingLocalDataSource ds;

  setUp(() async {
    tempDir = await Directory.systemTemp.createTemp('bongocal_onboarding_');
    Hive.init(tempDir.path);
    box = await Hive.openBox<dynamic>(
      'settings_test_${tempDir.path.hashCode}',
    );
    ds = OnboardingLocalDataSource(box: box);
  });

  tearDown(() async {
    await box.close();
    await tempDir.delete(recursive: true);
  });

  test('defaults to false when nothing is persisted', () {
    expect(ds.readCompleted(), isFalse);
  });

  test('persists true across reads', () async {
    await ds.writeCompleted(true);
    expect(ds.readCompleted(), isTrue);
  });

  test('coexists with the AppSettings record under a different key',
      () async {
    await box.put('app_settings', 'unrelated-marker');
    await ds.writeCompleted(true);

    expect(ds.readCompleted(), isTrue);
    expect(box.get('app_settings'), 'unrelated-marker');
  });
}
