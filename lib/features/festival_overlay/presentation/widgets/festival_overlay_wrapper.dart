import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/clock_provider.dart';
import '../../domain/entities/festival_greeting.dart';
import '../providers/festival_overlay_provider.dart';
import 'festival_overlay_widget.dart';

/// Wraps the entire routed app surface and conditionally lays a festival
/// greeting on top. Mounted via `MaterialApp.router(builder: ...)` so it
/// covers every page on every route.
class FestivalOverlayWrapper extends ConsumerStatefulWidget {
  const FestivalOverlayWrapper({required this.child, super.key});

  final Widget child;

  @override
  ConsumerState<FestivalOverlayWrapper> createState() =>
      _FestivalOverlayWrapperState();
}

class _FestivalOverlayWrapperState
    extends ConsumerState<FestivalOverlayWrapper> {
  /// Locally tracks "the user already dismissed this session". The Hive
  /// write that records [festivalForTodayProvider] -> null happens
  /// asynchronously; this flag prevents a brief reflash while it lands.
  String? _dismissedFestivalId;

  Future<void> _onDismiss(FestivalGreeting greeting) async {
    setState(() => _dismissedFestivalId = greeting.id);
    final DateTime today = ref.read(clockProvider)();
    await ref.read(festivalOverlayRepositoryProvider).markAsShown(
          festivalId: greeting.id,
          date: today,
        );
    // Refresh so anyone else watching the provider sees the new value.
    // ignore: unused_result
    ref.refresh(festivalForTodayProvider);
  }

  @override
  Widget build(BuildContext context) {
    final AsyncValue<FestivalGreeting?> async =
        ref.watch(festivalForTodayProvider);
    final FestivalGreeting? greeting = async.valueOrNull;
    final bool show = greeting != null && _dismissedFestivalId != greeting.id;

    return Stack(
      children: <Widget>[
        widget.child,
        if (show)
          Positioned.fill(
            child: FestivalOverlayWidget(
              greeting: greeting,
              today: ref.read(clockProvider)(),
              onDismiss: () => _onDismiss(greeting),
            ),
          ),
      ],
    );
  }
}
