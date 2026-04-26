import '../../domain/entities/bangla_date.dart';

/// Data-layer representation of a Bengali date. Identical shape to
/// [BanglaDate]; kept as a separate type so the data layer can grow
/// JSON/Hive serialization without polluting the domain entity.
class BanglaDateModel extends BanglaDate {
  const BanglaDateModel({
    required super.day,
    required super.monthIndex,
    required super.year,
  });

  factory BanglaDateModel.fromEntity(BanglaDate entity) => BanglaDateModel(
        day: entity.day,
        monthIndex: entity.monthIndex,
        year: entity.year,
      );

  factory BanglaDateModel.fromJson(Map<String, dynamic> json) =>
      BanglaDateModel(
        day: json['day'] as int,
        monthIndex: json['monthIndex'] as int,
        year: json['year'] as int,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'day': day,
        'monthIndex': monthIndex,
        'year': year,
      };
}
