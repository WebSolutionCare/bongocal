import '../../domain/entities/hijri_date.dart';

class HijriDateModel extends HijriDate {
  const HijriDateModel({
    required super.day,
    required super.month,
    required super.year,
  });

  factory HijriDateModel.fromEntity(HijriDate entity) => HijriDateModel(
        day: entity.day,
        month: entity.month,
        year: entity.year,
      );

  factory HijriDateModel.fromJson(Map<String, dynamic> json) => HijriDateModel(
        day: json['day'] as int,
        month: json['month'] as int,
        year: json['year'] as int,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'day': day,
        'month': month,
        'year': year,
      };
}
