import 'package:bongocal/features/notifications/domain/usecases/cancel_all_reminders.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../_fakes/fake_notification_scheduler.dart';

void main() {
  test('CancelAllReminders forwards to the scheduler', () async {
    final FakeNotificationScheduler scheduler = FakeNotificationScheduler();
    final CancelAllReminders usecase = CancelAllReminders(scheduler);

    final result = await usecase();

    expect(result.isRight(), isTrue);
    expect(scheduler.cancelAllCount, 1);
  });
}
