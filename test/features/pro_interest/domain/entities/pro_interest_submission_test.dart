import 'package:bongocal/features/pro_interest/data/models/pro_interest_submission_model.dart';
import 'package:bongocal/features/pro_interest/domain/entities/beta_interest.dart';
import 'package:bongocal/features/pro_interest/domain/entities/price_point.dart';
import 'package:bongocal/features/pro_interest/domain/entities/pro_feature.dart';
import 'package:bongocal/features/pro_interest/domain/entities/pro_interest_submission.dart';
import 'package:bongocal/features/pro_interest/domain/entities/usage_frequency.dart';
import 'package:flutter_test/flutter_test.dart';

ProInterestSubmissionModel _sample() => ProInterestSubmissionModel(
      name: 'রহিম',
      email: 'rahim@example.com',
      whatsapp: '+8801712345678',
      usageFrequency: UsageFrequency.daily,
      features: const <ProFeature>[
        ProFeature.noAds,
        ProFeature.cloudSync,
        ProFeature.familySharing,
      ],
      pricePoint: PricePoint.tk99,
      betaInterest: BetaInterest.yes,
      suggestions: 'Dark theme is great.',
      submittedAt: DateTime.utc(2026, 4, 28, 9, 30),
      userAgent: 'Web',
    );

void main() {
  group('ProInterestSubmission', () {
    test('equality is field-based', () {
      final ProInterestSubmission a = _sample();
      final ProInterestSubmission b = _sample();
      expect(a, b);
    });
  });

  group('ProInterestSubmissionModel.toJson', () {
    test('produces the flat snake_case payload the Apps Script expects', () {
      final ProInterestSubmissionModel s = _sample();
      final Map<String, dynamic> json = s.toJson();

      expect(json['timestamp'], '2026-04-28T09:30:00.000Z');
      expect(json['name'], 'রহিম');
      expect(json['email'], 'rahim@example.com');
      expect(json['whatsapp'], '+8801712345678');
      expect(json['usage'], 'daily');
      expect(json['features'], 'no_ads,cloud_sync,family_sharing');
      expect(json['price'], 'tk_99_month');
      expect(json['beta'], 'yes');
      expect(json['suggestions'], 'Dark theme is great.');
      expect(json['user_agent'], 'Web');
    });

    test('serializes empty optional fields as empty strings', () {
      final ProInterestSubmissionModel s = ProInterestSubmissionModel(
        email: 'x@y.com',
        usageFrequency: UsageFrequency.weekly,
        features: const <ProFeature>[ProFeature.themes],
        pricePoint: PricePoint.lifetime499,
        betaInterest: BetaInterest.maybe,
        submittedAt: DateTime.utc(2026, 4, 28),
      );
      final Map<String, dynamic> json = s.toJson();

      expect(json['name'], '');
      expect(json['whatsapp'], '');
      expect(json['suggestions'], '');
      expect(json['user_agent'], '');
      expect(json['features'], 'themes');
    });
  });
}
