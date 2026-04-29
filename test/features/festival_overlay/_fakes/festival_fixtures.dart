import 'dart:ui';

import 'package:bongocal/features/festival_overlay/domain/entities/festival_greeting.dart';
import 'package:bongocal/features/festival_overlay/domain/entities/festival_theme.dart';

/// Reusable greeting fixtures so widget + use-case tests don't repeat
/// the 9-field constructor.
FestivalGreeting eidGreeting({String id = 'eid_ul_fitr'}) => FestivalGreeting(
      id: id,
      nameBn: 'ঈদ মোবারক',
      nameEn: 'Eid Mubarak',
      greetingBn: 'ঈদুল ফিতরের শুভেচ্ছা।',
      greetingEn: 'Eid greetings.',
      theme: FestivalTheme.eid,
      gradientStart: const Color(0xFF0E5C46),
      gradientEnd: const Color(0xFF1F8A6C),
      illustrationKey: 'eid_crescent',
    );

FestivalGreeting boishakhGreeting() => const FestivalGreeting(
      id: 'pohela_boishakh',
      nameBn: 'শুভ নববর্ষ',
      nameEn: 'Happy Bengali New Year',
      greetingBn: 'নতুন বছরের শুভেচ্ছা।',
      greetingEn: 'Happy new year.',
      theme: FestivalTheme.boishakh,
      gradientStart: Color(0xFFF42A41),
      gradientEnd: Color(0xFFFF6B6B),
      illustrationKey: 'boishakh_alpana',
    );
