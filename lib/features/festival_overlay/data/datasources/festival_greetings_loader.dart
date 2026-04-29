import 'dart:convert';
import 'dart:ui' show Color;

import 'package:flutter/services.dart' show AssetBundle, rootBundle;

import '../../domain/entities/festival_greeting.dart';
import '../../domain/entities/festival_theme.dart';

/// Loads `assets/data/festival_greetings.json` once and exposes the
/// catalog as a `Map<holidayId, FestivalGreeting>`. Cached for the
/// process lifetime — the file is < 4 KB and never changes at runtime.
class FestivalGreetingsLoader {
  FestivalGreetingsLoader({AssetBundle? bundle})
      : _bundle = bundle ?? rootBundle;

  static const String _assetPath = 'assets/data/festival_greetings.json';

  final AssetBundle _bundle;
  Map<String, FestivalGreeting>? _cache;

  Future<Map<String, FestivalGreeting>> load() async {
    final Map<String, FestivalGreeting>? cached = _cache;
    if (cached != null) return cached;
    final String raw = await _bundle.loadString(_assetPath);
    final Map<String, dynamic> decoded =
        json.decode(raw) as Map<String, dynamic>;
    final Map<String, FestivalGreeting> parsed =
        <String, FestivalGreeting>{};
    decoded.forEach((String id, dynamic node) {
      final Map<String, dynamic> map = node as Map<String, dynamic>;
      final Map<String, dynamic> colors =
          map['colors'] as Map<String, dynamic>;
      parsed[id] = FestivalGreeting(
        id: id,
        nameBn: map['nameBn'] as String,
        nameEn: map['nameEn'] as String,
        greetingBn: map['greetingBn'] as String,
        greetingEn: map['greetingEn'] as String,
        theme: FestivalThemeJson.fromJsonKey(map['theme'] as String),
        gradientStart: _parseHex(colors['start'] as String),
        gradientEnd: _parseHex(colors['end'] as String),
        illustrationKey: map['illustrationKey'] as String,
      );
    });
    _cache = parsed;
    return parsed;
  }

  static Color _parseHex(String hex) {
    final String cleaned = hex.replaceFirst('#', '');
    final int value = int.parse(cleaned, radix: 16);
    // 6-char hex assumed — opaque alpha.
    return Color(0xFF000000 | value);
  }
}
