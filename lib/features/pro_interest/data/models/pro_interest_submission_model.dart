import '../../domain/entities/beta_interest.dart';
import '../../domain/entities/price_point.dart';
import '../../domain/entities/pro_feature.dart';
import '../../domain/entities/pro_interest_submission.dart';
import '../../domain/entities/usage_frequency.dart';

/// Data-layer projection of [ProInterestSubmission] with a `toJson()` that
/// produces the flat key-value shape the Apps Script expects.
class ProInterestSubmissionModel extends ProInterestSubmission {
  const ProInterestSubmissionModel({
    required super.email,
    required super.usageFrequency,
    required super.features,
    required super.pricePoint,
    required super.betaInterest,
    required super.submittedAt,
    super.name,
    super.whatsapp,
    super.suggestions,
    super.userAgent,
  });

  factory ProInterestSubmissionModel.fromEntity(
    ProInterestSubmission s,
  ) =>
      ProInterestSubmissionModel(
        name: s.name,
        email: s.email,
        whatsapp: s.whatsapp,
        usageFrequency: s.usageFrequency,
        features: s.features,
        pricePoint: s.pricePoint,
        betaInterest: s.betaInterest,
        suggestions: s.suggestions,
        submittedAt: s.submittedAt,
        userAgent: s.userAgent,
      );

  /// Flat payload — matches the column order the Apps Script appends to
  /// the Sheet. Keep keys snake_case for Sheet header readability.
  Map<String, dynamic> toJson() => <String, dynamic>{
        'timestamp': submittedAt.toUtc().toIso8601String(),
        'name': name,
        'email': email,
        'whatsapp': whatsapp,
        'usage': usageFrequency.sheetKey,
        'features': features.map((ProFeature f) => f.sheetKey).join(','),
        'price': pricePoint.sheetKey,
        'beta': betaInterest.sheetKey,
        'suggestions': suggestions,
        'user_agent': userAgent,
      };
}
