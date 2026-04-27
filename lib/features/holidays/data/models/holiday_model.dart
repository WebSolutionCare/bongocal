import '../../domain/entities/holiday.dart';
import '../../domain/entities/holiday_type.dart';

/// Data-layer projection of [Holiday] with JSON ↔ entity helpers.
class HolidayModel extends Holiday {
  const HolidayModel({
    required super.id,
    required super.nameBn,
    required super.nameEn,
    required super.date,
    required super.type,
    required super.descriptionBn,
    required super.descriptionEn,
    required super.isGovernmentHoliday,
    required super.banksClosed,
    required super.isObservance,
  });

  factory HolidayModel.fromJson(Map<String, dynamic> json) => HolidayModel(
        id: json['id'] as String,
        nameBn: json['nameBn'] as String,
        nameEn: json['nameEn'] as String,
        date: DateTime.parse(json['dateEnglish'] as String),
        type: HolidayTypeX.fromJsonKey(json['type'] as String),
        descriptionBn: (json['descBn'] as String?) ?? '',
        descriptionEn: (json['descEn'] as String?) ?? '',
        isGovernmentHoliday: (json['govHoliday'] as bool?) ?? false,
        banksClosed: (json['banksClosed'] as bool?) ?? false,
        isObservance: (json['isObservance'] as bool?) ?? false,
      );

  Map<String, dynamic> toJson() => <String, dynamic>{
        'id': id,
        'nameBn': nameBn,
        'nameEn': nameEn,
        'dateEnglish':
            '${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}',
        'type': type.jsonKey,
        'descBn': descriptionBn,
        'descEn': descriptionEn,
        'govHoliday': isGovernmentHoliday,
        'banksClosed': banksClosed,
        'isObservance': isObservance,
      };
}
