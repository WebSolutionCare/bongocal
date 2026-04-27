import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive/hive.dart';
import 'package:uuid/uuid.dart';

import '../../../../core/clock_provider.dart';
import '../../../../core/storage/hive_service.dart';
import '../../data/datasources/event_local_datasource.dart';
import '../../data/models/personal_event_model.dart';
import '../../data/repositories/event_repository_impl.dart';
import '../../domain/entities/personal_event.dart';
import '../../domain/repositories/event_repository.dart';

/// Box-level provider — opened lazily and lives for the app's lifetime.
final Provider<Box<PersonalEventModel>> eventsBoxProvider =
    Provider<Box<PersonalEventModel>>(
  (Ref ref) => Hive.box<PersonalEventModel>(HiveBoxes.events),
);

final Provider<EventLocalDataSource> eventLocalDataSourceProvider =
    Provider<EventLocalDataSource>(
  (Ref ref) => EventLocalDataSource(box: ref.watch(eventsBoxProvider)),
);

final Provider<EventRepository> eventRepositoryProvider =
    Provider<EventRepository>(
  (Ref ref) => EventRepositoryImpl(
    dataSource: ref.watch(eventLocalDataSourceProvider),
    now: ref.watch(clockProvider),
  ),
);

final Provider<Uuid> uuidProvider = Provider<Uuid>((Ref ref) => const Uuid());

/// Notifier whose state is bumped whenever events are mutated. Other
/// providers watch this and re-derive — Hive's box listener is more
/// invasive to wire across providers.
class EventsRevisionNotifier extends Notifier<int> {
  @override
  int build() => 0;

  void bump() => state = state + 1;
}

final NotifierProvider<EventsRevisionNotifier, int> eventsRevisionProvider =
    NotifierProvider<EventsRevisionNotifier, int>(EventsRevisionNotifier.new);

final FutureProvider<List<PersonalEvent>> allEventsProvider =
    FutureProvider<List<PersonalEvent>>((Ref ref) async {
  ref.watch(eventsRevisionProvider);
  final EventRepository repo = ref.watch(eventRepositoryProvider);
  final result = await repo.getAllEvents();
  return result.fold(
    (f) => throw StateError('allEventsProvider failed: ${f.message ?? f}'),
    (List<PersonalEvent> list) => list,
  );
});

final FutureProvider<List<PersonalEvent>> upcomingEventsProvider =
    FutureProvider<List<PersonalEvent>>((Ref ref) async {
  ref.watch(eventsRevisionProvider);
  final EventRepository repo = ref.watch(eventRepositoryProvider);
  final result = await repo.getUpcomingEvents(limit: 20);
  return result.fold(
    (f) =>
        throw StateError('upcomingEventsProvider failed: ${f.message ?? f}'),
    (List<PersonalEvent> list) => list,
  );
});

final FutureProviderFamily<List<PersonalEvent>, DateTime>
    eventsForDateProvider =
    FutureProvider.family<List<PersonalEvent>, DateTime>(
  (Ref ref, DateTime date) async {
    ref.watch(eventsRevisionProvider);
    final EventRepository repo = ref.watch(eventRepositoryProvider);
    final result = await repo.getEventsForDate(date);
    return result.fold(
      (f) =>
          throw StateError('eventsForDateProvider failed: ${f.message ?? f}'),
      (List<PersonalEvent> list) => list,
    );
  },
);

final FutureProviderFamily<PersonalEvent?, String> eventByIdProvider =
    FutureProvider.family<PersonalEvent?, String>((Ref ref, String id) async {
  ref.watch(eventsRevisionProvider);
  final EventRepository repo = ref.watch(eventRepositoryProvider);
  final result = await repo.getEventById(id);
  return result.fold(
    (f) => throw StateError('eventByIdProvider failed: ${f.message ?? f}'),
    (PersonalEvent? e) => e,
  );
});
