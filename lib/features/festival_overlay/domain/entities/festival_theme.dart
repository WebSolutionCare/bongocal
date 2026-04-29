/// Visual theme variants for the festival overlay. Each maps to a unique
/// gradient + illustration combo in the presentation layer.
enum FestivalTheme {
  boishakh,
  eid,
  independence,
  victory,
  durgaPuja,
  christmas,
}

extension FestivalThemeJson on FestivalTheme {
  static FestivalTheme fromJsonKey(String key) {
    switch (key) {
      case 'boishakh':
        return FestivalTheme.boishakh;
      case 'eid':
        return FestivalTheme.eid;
      case 'independence':
        return FestivalTheme.independence;
      case 'victory':
        return FestivalTheme.victory;
      case 'durga_puja':
        return FestivalTheme.durgaPuja;
      case 'christmas':
        return FestivalTheme.christmas;
      default:
        throw ArgumentError('Unknown FestivalTheme key: $key');
    }
  }
}
