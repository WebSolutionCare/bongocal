/// How often the respondent expects to use BongoCal.
enum UsageFrequency { daily, weekly, monthly, rarely }

extension UsageFrequencyX on UsageFrequency {
  String get displayBn {
    switch (this) {
      case UsageFrequency.daily:
        return 'প্রতিদিন';
      case UsageFrequency.weekly:
        return 'সপ্তাহে কয়েকবার';
      case UsageFrequency.monthly:
        return 'মাসে কয়েকবার';
      case UsageFrequency.rarely:
        return 'কম';
    }
  }

  /// Stable string the Apps Script will see in the Sheet.
  String get sheetKey {
    switch (this) {
      case UsageFrequency.daily:
        return 'daily';
      case UsageFrequency.weekly:
        return 'weekly';
      case UsageFrequency.monthly:
        return 'monthly';
      case UsageFrequency.rarely:
        return 'rarely';
    }
  }
}
