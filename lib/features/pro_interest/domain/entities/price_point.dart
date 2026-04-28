/// Price points the respondent might accept. Single-select.
enum PricePoint {
  tk49,
  tk99,
  tk149,
  tk199,
  lifetime499,
  lifetime999,
  freeOnly,
}

extension PricePointX on PricePoint {
  String get displayBn {
    switch (this) {
      case PricePoint.tk49:
        return '৳৪৯ / মাস';
      case PricePoint.tk99:
        return '৳৯৯ / মাস';
      case PricePoint.tk149:
        return '৳১৪৯ / মাস';
      case PricePoint.tk199:
        return '৳১৯৯ / মাস';
      case PricePoint.lifetime499:
        return 'এককালীন ৳৪৯৯ (lifetime)';
      case PricePoint.lifetime999:
        return 'এককালীন ৳৯৯৯ (lifetime)';
      case PricePoint.freeOnly:
        return 'ফ্রি ভার্সনই যথেষ্ট';
    }
  }

  /// Highlight this option on the form (gold "জনপ্রিয়" badge).
  bool get isPopular => this == PricePoint.tk99;

  String get sheetKey {
    switch (this) {
      case PricePoint.tk49:
        return 'tk_49_month';
      case PricePoint.tk99:
        return 'tk_99_month';
      case PricePoint.tk149:
        return 'tk_149_month';
      case PricePoint.tk199:
        return 'tk_199_month';
      case PricePoint.lifetime499:
        return 'lifetime_499';
      case PricePoint.lifetime999:
        return 'lifetime_999';
      case PricePoint.freeOnly:
        return 'free_only';
    }
  }
}
