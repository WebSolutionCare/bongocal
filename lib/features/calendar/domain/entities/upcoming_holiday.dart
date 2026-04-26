import 'package:equatable/equatable.dart';

/// A summary projection of the next holiday or festival from "today". Lives
/// in the calendar feature for now because the Home screen renders it
/// alongside today; once the holidays feature lands it should source this
/// directly from there and this file can be deleted.
class UpcomingHoliday extends Equatable {
  const UpcomingHoliday({
    required this.id,
    required this.nameBn,
    required this.nameEn,
    required this.date,
    required this.daysAway,
    required this.isFestival,
    required this.isGovernment,
  });

  final String id;
  final String nameBn;
  final String nameEn;
  final DateTime date;

  /// Whole days from "today" (start-of-day) to the holiday. Zero if today.
  final int daysAway;

  /// True for cultural festivals (Pohela Boishakh, Eid, Durga Puja). Drives
  /// gold-disc styling on the date cell.
  final bool isFestival;

  /// True for government holidays (the `সরকারি ছুটি` pill).
  final bool isGovernment;

  @override
  List<Object?> get props => <Object?>[
        id,
        nameBn,
        nameEn,
        date,
        daysAway,
        isFestival,
        isGovernment,
      ];
}
