import 'dart:convert';

import 'package:bongocal/core/errors/exceptions.dart';
import 'package:bongocal/features/pro_interest/data/datasources/pro_interest_remote_datasource.dart';
import 'package:bongocal/features/pro_interest/data/models/pro_interest_submission_model.dart';
import 'package:bongocal/features/pro_interest/domain/entities/beta_interest.dart';
import 'package:bongocal/features/pro_interest/domain/entities/price_point.dart';
import 'package:bongocal/features/pro_interest/domain/entities/pro_feature.dart';
import 'package:bongocal/features/pro_interest/domain/entities/usage_frequency.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';

ProInterestSubmissionModel _sample() => ProInterestSubmissionModel(
      name: 'A',
      email: 'a@b.com',
      whatsapp: '',
      usageFrequency: UsageFrequency.daily,
      features: const <ProFeature>[ProFeature.noAds, ProFeature.cloudSync],
      pricePoint: PricePoint.tk99,
      betaInterest: BetaInterest.yes,
      submittedAt: DateTime.utc(2026, 4, 28),
      userAgent: 'TestAgent',
    );

void main() {
  final Uri endpoint = Uri.parse('https://example.com/exec');

  test('POSTs JSON-encoded body as text/plain to the endpoint', () async {
    http.BaseRequest? captured;
    String? capturedBody;

    final MockClient client = MockClient((http.Request request) async {
      captured = request;
      capturedBody = request.body;
      return http.Response('OK', 200);
    });
    final ProInterestRemoteDataSource ds =
        ProInterestRemoteDataSource(client: client, endpoint: endpoint);

    await ds.submit(_sample());

    expect(captured, isNotNull);
    expect(captured!.url, endpoint);
    expect(captured!.method, 'POST');
    // text/plain content type avoids the CORS preflight on web.
    expect(
      captured!.headers['Content-Type'],
      contains('text/plain'),
    );

    final Map<String, dynamic> json =
        jsonDecode(capturedBody!) as Map<String, dynamic>;
    expect(json['email'], 'a@b.com');
    expect(json['usage'], 'daily');
    expect(json['features'], 'no_ads,cloud_sync');
    expect(json['price'], 'tk_99_month');
    expect(json['beta'], 'yes');
  });

  test('Treats any 2xx response as success', () async {
    final MockClient client = MockClient((http.Request request) async {
      return http.Response('thanks', 204);
    });
    final ProInterestRemoteDataSource ds =
        ProInterestRemoteDataSource(client: client, endpoint: endpoint);

    await expectLater(ds.submit(_sample()), completes);
  });

  test('Throws ServerException on non-2xx', () async {
    final MockClient client = MockClient((http.Request request) async {
      return http.Response('boom', 500);
    });
    final ProInterestRemoteDataSource ds =
        ProInterestRemoteDataSource(client: client, endpoint: endpoint);

    await expectLater(
      ds.submit(_sample()),
      throwsA(isA<ServerException>()),
    );
  });

  test('Throws NetworkException on transport failure', () async {
    final MockClient client = MockClient((http.Request request) async {
      throw http.ClientException('connection reset');
    });
    final ProInterestRemoteDataSource ds =
        ProInterestRemoteDataSource(client: client, endpoint: endpoint);

    await expectLater(
      ds.submit(_sample()),
      throwsA(isA<NetworkException>()),
    );
  });
}
