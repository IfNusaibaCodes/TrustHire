import 'dart:async';
import 'dart:convert';

import 'package:http/http.dart' as http;

import '../../Utilities/Constants/api_config.dart';
import 'scam_analyzer.dart';

/// Result of an analysis plus whether we had to fall back to the offline engine.
class ScamAnalysis {
  final ScamResult result;

  /// True when the ML API was unreachable and we used the on-device rule engine
  /// instead. The UI uses this to tell the user the result is the offline one.
  final bool usedFallback;

  const ScamAnalysis(this.result, {required this.usedFallback});
}

/// Talks to the self-hosted ML scam-detection API and converts its JSON into the
/// app's existing [ScamResult] shape.
///
/// DESIGN: the feature must NEVER hard-fail. If the server is down, slow, or the
/// phone is offline, we silently fall back to the original rule engine
/// ([ScamAnalyzer]) so the user still gets a result. This is why the rule engine
/// is kept in the codebase rather than deleted.
class MlScamService {
  final http.Client _client;
  final Duration timeout;

  MlScamService({http.Client? client, this.timeout = const Duration(seconds: 8)})
      : _client = client ?? http.Client();

  Future<ScamAnalysis> analyze(String text) async {
    try {
      final response = await _client
          .post(
            Uri.parse(ApiConfig.scamPredictUrl),
            headers: const {'Content-Type': 'application/json'},
            body: jsonEncode({'text': text}),
          )
          .timeout(timeout);

      if (response.statusCode != 200) {
        return _fallback(text);
      }

      final json = jsonDecode(utf8.decode(response.bodyBytes))
          as Map<String, dynamic>;

      final result = ScamResult(
        (json['score'] as num).toInt(),
        json['risk_level'] as String,
        (json['issues'] as List<dynamic>? ?? const []).cast<String>(),
        (json['positives'] as List<dynamic>? ?? const []).cast<String>(),
      );
      return ScamAnalysis(result, usedFallback: false);
    } catch (_) {
      // Any failure (timeout, socket error, bad JSON) -> offline engine.
      return _fallback(text);
    }
  }

  ScamAnalysis _fallback(String text) {
    return ScamAnalysis(ScamAnalyzer.analyze(text), usedFallback: true);
  }

  void dispose() => _client.close();
}
