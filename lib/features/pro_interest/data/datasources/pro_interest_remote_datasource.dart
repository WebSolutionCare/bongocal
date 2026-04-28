import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../../../core/constants/app_info.dart';
import '../../../../core/errors/exceptions.dart';
import '../models/pro_interest_submission_model.dart';

/// POSTs Pro-interest submissions to the deployed Apps Script Web App.
///
/// CORS note: Apps Script Web Apps don't return permissive CORS headers
/// for `application/json` requests, which would force a browser preflight.
/// We use `Content-Type: text/plain;charset=UTF-8` (a "simple" CORS
/// content type) and let Apps Script read the body as a JSON string —
/// works on web, mobile, and desktop without any extra plumbing.
class ProInterestRemoteDataSource {
  ProInterestRemoteDataSource({http.Client? client, Uri? endpoint})
      : _client = client ?? http.Client(),
        _endpoint = endpoint;

  final http.Client _client;
  final Uri? _endpoint;

  static const Duration _timeout = Duration(seconds: 10);

  Future<void> submit(ProInterestSubmissionModel submission) async {
    final Uri uri = _endpoint ?? _resolveEndpoint();

    final http.Response response;
    try {
      response = await _client
          .post(
            uri,
            headers: const <String, String>{
              'Content-Type': 'text/plain;charset=UTF-8',
            },
            body: json.encode(submission.toJson()),
          )
          .timeout(_timeout);
    } on Exception catch (e) {
      throw NetworkException('Pro interest submit failed: $e');
    }

    final int code = response.statusCode;
    if (code < 200 || code >= 300) {
      throw ServerException(
        'Pro interest submit returned $code: ${response.body}',
      );
    }
  }

  /// Parses the configured endpoint, throwing a clear error in dev when
  /// the URL is still the placeholder sentinel.
  static Uri _resolveEndpoint() {
    if (!AppInfo.isProInterestEndpointConfigured) {
      throw const ServerException(
        'Pro interest endpoint not configured — replace '
        'AppInfo.proInterestEndpoint with the deployed Apps Script URL.',
      );
    }
    return Uri.parse(AppInfo.proInterestEndpoint);
  }
}
