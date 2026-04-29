import 'package:bongocal/features/festival_overlay/domain/entities/festival_greeting.dart';
import 'package:bongocal/features/festival_overlay/domain/usecases/check_festival_for_today.dart';
import 'package:bongocal/features/settings/domain/entities/app_settings.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_fakes/fake_festival_overlay_repository.dart';
import '../../_fakes/festival_fixtures.dart';

void main() {
  late FakeFestivalOverlayRepository repo;
  late CheckFestivalForToday usecase;

  setUp(() {
    repo = FakeFestivalOverlayRepository();
    usecase = CheckFestivalForToday(repo);
  });

  test(
    'returns the greeting when settings are enabled and the repo finds one',
    () async {
      repo.greetingForToday = eidGreeting();
      final result = await usecase(
        today: DateTime(2026, 3, 21),
        settings: AppSettings.defaults(),
      );
      final FestivalGreeting? greeting =
          result.fold((_) => fail('expected Right'), (g) => g);
      expect(greeting?.id, 'eid_ul_fitr');
    },
  );

  test('returns null when festival greetings are disabled', () async {
    repo.greetingForToday = eidGreeting();
    final result = await usecase(
      today: DateTime(2026, 3, 21),
      settings:
          AppSettings.defaults().copyWith(festivalGreetingsEnabled: false),
    );
    expect(result.fold((_) => fail('expected Right'), (g) => g), isNull);
  });

  test(
    'returns null when settings are enabled but the repo says nothing today',
    () async {
      repo.greetingForToday = null;
      final result = await usecase(
        today: DateTime(2026, 4, 27),
        settings: AppSettings.defaults(),
      );
      expect(result.fold((_) => fail('expected Right'), (g) => g), isNull);
    },
  );
}
