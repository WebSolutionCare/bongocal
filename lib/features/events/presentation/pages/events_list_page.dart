import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../app/router.dart';
import '../../../../core/clock_provider.dart';
import '../../../../shared/theme/theme.dart';
import '../../../../shared/widgets/bottom_nav.dart';
import '../../domain/entities/personal_event.dart';
import '../providers/events_provider.dart';
import '../sheets/add_event_sheet.dart';
import '../widgets/event_card.dart';

enum _EventsFilter { today, upcoming, all }

extension on _EventsFilter {
  String get labelBn {
    switch (this) {
      case _EventsFilter.today:
        return 'আজ';
      case _EventsFilter.upcoming:
        return 'আগামী';
      case _EventsFilter.all:
        return 'সব';
    }
  }
}

final StateProvider<_EventsFilter> _eventsFilterProvider =
    StateProvider<_EventsFilter>((Ref ref) => _EventsFilter.upcoming);

class EventsListPage extends ConsumerStatefulWidget {
  const EventsListPage({
    this.autoOpenNew = false,
    this.autoOpenEditId,
    super.key,
  });

  /// When true, the create-event sheet opens on the first frame.
  final bool autoOpenNew;

  /// When non-null, the edit sheet for that id opens on the first frame.
  final String? autoOpenEditId;

  @override
  ConsumerState<EventsListPage> createState() => _EventsListPageState();
}

class _EventsListPageState extends ConsumerState<EventsListPage> {
  bool _autoOpenedSheet = false;

  @override
  void initState() {
    super.initState();
    if (widget.autoOpenNew || widget.autoOpenEditId != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted || _autoOpenedSheet) return;
        _autoOpenedSheet = true;
        _openSheetFromRoute();
      });
    }
  }

  Future<void> _openSheetFromRoute() async {
    final String? editId = widget.autoOpenEditId;
    if (editId != null) {
      final result =
          await ref.read(eventRepositoryProvider).getEventById(editId);
      final PersonalEvent? existing =
          result.fold((_) => null, (PersonalEvent? e) => e);
      if (!mounted) return;
      if (existing == null) {
        await showAddEventSheet(context);
      } else {
        await showAddEventSheet(context, existing: existing);
      }
    } else {
      await showAddEventSheet(context);
    }
    if (mounted) context.go(AppRoutes.events);
  }

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final _EventsFilter filter = ref.watch(_eventsFilterProvider);
    final DateTime today = ref.watch(clockProvider)();
    final AsyncValue<List<PersonalEvent>> async = ref.watch(
      filter == _EventsFilter.today
          ? eventsForDateProvider(today)
          : filter == _EventsFilter.upcoming
              ? upcomingEventsProvider
              : allEventsProvider,
    );

    final double bottomInset = MediaQuery.of(context).padding.bottom;

    return Scaffold(
      backgroundColor: roles.bgCanvas,
      extendBody: true,
      body: SafeArea(
        bottom: false,
        child: Column(
          children: <Widget>[
            const _TopBar(),
            const _FilterRow(),
            Expanded(
              child: async.when(
                data: (List<PersonalEvent> events) => events.isEmpty
                    ? _EmptyState(filter: filter)
                    : _EventsList(
                        events: events,
                        bottomPadding: AppSpacing.bottomNavHeight +
                            bottomInset +
                            AppSpacing.s6,
                      ),
                loading: () => const Center(
                  child: CircularProgressIndicator(),
                ),
                error: (Object e, _) => Center(
                  child: Padding(
                    padding: const EdgeInsets.all(AppSpacing.gutter),
                    child: Text(
                      'লোড করা যায়নি · $e',
                      style: AppTypography.bodyBn().copyWith(
                        color: roles.fgSecondary,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.brandEmerald,
        foregroundColor: Colors.white,
        onPressed: () => showAddEventSheet(context),
        child: const Icon(Icons.add),
      ),
      bottomNavigationBar: BottomNav(
        currentIndex: 3,
        onTap: (int i) {
          switch (i) {
            case 0:
              context.go(AppRoutes.home);
            case 1:
              context.go(AppRoutes.month);
            case 2:
              context.go(AppRoutes.holidays);
            case 3:
              return;
            case 4:
              context.go(AppRoutes.settings);
          }
        },
        items: const <BottomNavItem>[
          BottomNavItem(icon: Icons.home_outlined, label: 'হোম'),
          BottomNavItem(
            icon: Icons.calendar_today_outlined,
            label: 'ক্যালেন্ডার',
          ),
          BottomNavItem(icon: Icons.star_outline, label: 'ছুটি'),
          BottomNavItem(icon: Icons.event_note_outlined, label: 'ইভেন্ট'),
          BottomNavItem(icon: Icons.settings_outlined, label: 'সেটিংস'),
        ],
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar();

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'অনুষ্ঠান',
            style: AppTypography.h1Bn().copyWith(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              color: roles.fgPrimary,
              letterSpacing: -0.12,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'EVENTS',
            style: AppTypography.captionEn().copyWith(
              color: roles.fgTertiary,
              letterSpacing: 1.1,
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterRow extends ConsumerWidget {
  const _FilterRow();

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final _EventsFilter selected = ref.watch(_eventsFilterProvider);
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 0, 20, 12),
      child: Row(
        children: <Widget>[
          for (final _EventsFilter f in _EventsFilter.values) ...<Widget>[
            _FilterChip(
              label: f.labelBn,
              isSelected: f == selected,
              onTap: () =>
                  ref.read(_eventsFilterProvider.notifier).state = f,
            ),
            const SizedBox(width: 8),
          ],
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final Color bg =
        isSelected ? AppColors.brandEmerald : roles.bgSurface;
    final Color fg = isSelected ? Colors.white : roles.fgSecondary;
    return Material(
      color: bg,
      borderRadius: AppRadii.pillBorder,
      child: InkWell(
        onTap: onTap,
        borderRadius: AppRadii.pillBorder,
        child: Ink(
          decoration: BoxDecoration(
            color: bg,
            border: Border.all(
              color: isSelected
                  ? AppColors.brandEmerald
                  : roles.borderSubtle,
            ),
            borderRadius: AppRadii.pillBorder,
          ),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          child: Text(
            label,
            style: AppTypography.bodySmBn().copyWith(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: fg,
            ),
          ),
        ),
      ),
    );
  }
}

class _EventsList extends StatelessWidget {
  const _EventsList({required this.events, required this.bottomPadding});

  final List<PersonalEvent> events;
  final double bottomPadding;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const BouncingScrollPhysics(),
      padding: EdgeInsets.fromLTRB(16, 4, 16, bottomPadding),
      itemCount: events.length,
      separatorBuilder: (_, __) => const SizedBox(height: 10),
      itemBuilder: (BuildContext context, int i) {
        final PersonalEvent event = events[i];
        return EventCard(
          event: event,
          onTap: () => showAddEventSheet(context, existing: event),
        );
      },
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.filter});

  final _EventsFilter filter;

  @override
  Widget build(BuildContext context) {
    final AppColorRoles roles =
        Theme.of(context).extension<AppColorRoles>()!;
    final String message;
    switch (filter) {
      case _EventsFilter.today:
        message = 'আজ কোনো অনুষ্ঠান নেই';
      case _EventsFilter.upcoming:
        message = 'কোনো আসন্ন অনুষ্ঠান নেই';
      case _EventsFilter.all:
        message = 'এখনো কোনো ইভেন্ট তৈরি করা হয়নি';
    }
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.gutter),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(
              Icons.event_note_outlined,
              size: 48,
              color: roles.fgTertiary,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: AppTypography.bodyBn().copyWith(
                fontSize: 16,
                color: roles.fgSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 6),
            Text(
              '+ চাপ দিয়ে নতুন ইভেন্ট যোগ করুন',
              style: AppTypography.bodySmBn().copyWith(
                fontSize: 13,
                color: roles.fgTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
