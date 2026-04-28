import 'package:equatable/equatable.dart';

import 'beta_interest.dart';
import 'price_point.dart';
import 'pro_feature.dart';
import 'usage_frequency.dart';

/// One filled-in Pro interest form. Maps 1:1 to a row on the Google Sheet.
///
/// Only [email], [usageFrequency], [features] (≥1), [pricePoint], and
/// [betaInterest] are required for a valid submission. Validation lives
/// in the presentation layer; the entity itself is permissive so the
/// data layer can serialize partial drafts during testing.
class ProInterestSubmission extends Equatable {
  const ProInterestSubmission({
    required this.email,
    required this.usageFrequency,
    required this.features,
    required this.pricePoint,
    required this.betaInterest,
    required this.submittedAt,
    this.name = '',
    this.whatsapp = '',
    this.suggestions = '',
    this.userAgent = '',
  });

  final String name;
  final String email;
  final String whatsapp;
  final UsageFrequency usageFrequency;
  final List<ProFeature> features;
  final PricePoint pricePoint;
  final BetaInterest betaInterest;
  final String suggestions;
  final DateTime submittedAt;

  /// Free-form client identifier (e.g. `Chrome 134 / Web` or
  /// `iOS 17 / iPhone 15`). Set by the data layer at submission time.
  final String userAgent;

  @override
  List<Object?> get props => <Object?>[
        name,
        email,
        whatsapp,
        usageFrequency,
        features,
        pricePoint,
        betaInterest,
        suggestions,
        submittedAt,
        userAgent,
      ];
}
