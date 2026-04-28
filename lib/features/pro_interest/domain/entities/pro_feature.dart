/// Pro features the respondent can express interest in. Multi-select.
enum ProFeature {
  noAds,
  cloudSync,
  familySharing,
  themes,
  photoMemories,
  widgets,
  quotes,
  azanSound,
}

extension ProFeatureX on ProFeature {
  String get displayBn {
    switch (this) {
      case ProFeature.noAds:
        return 'কোনো বিজ্ঞাপন নেই';
      case ProFeature.cloudSync:
        return 'ক্লাউড সিঙ্ক';
      case ProFeature.familySharing:
        return 'ফ্যামিলি শেয়ারিং';
      case ProFeature.themes:
        return 'প্রিমিয়াম থিম';
      case ProFeature.photoMemories:
        return 'ছবি স্মৃতিচারণ';
      case ProFeature.widgets:
        return 'অ্যাডভান্সড উইজেট';
      case ProFeature.quotes:
        return 'প্রিমিয়াম উক্তি ও হাদিস';
      case ProFeature.azanSound:
        return 'কাস্টম আজান ও সাউন্ড';
    }
  }

  String get sheetKey {
    switch (this) {
      case ProFeature.noAds:
        return 'no_ads';
      case ProFeature.cloudSync:
        return 'cloud_sync';
      case ProFeature.familySharing:
        return 'family_sharing';
      case ProFeature.themes:
        return 'themes';
      case ProFeature.photoMemories:
        return 'photo_memories';
      case ProFeature.widgets:
        return 'widgets';
      case ProFeature.quotes:
        return 'quotes';
      case ProFeature.azanSound:
        return 'azan_sound';
    }
  }
}
