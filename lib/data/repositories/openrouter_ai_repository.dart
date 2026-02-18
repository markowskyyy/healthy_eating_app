import 'dart:convert';
import 'package:healthy_eating_app/domain/analytics/analytics_service.dart';
import 'package:healthy_eating_app/domain/repositories/ai_repository.dart';
import 'package:http/http.dart' as http;

class OpenRouterAiRepository implements AiRepository {
  final String apiKey;
  final String model;
  final AnalyticsService analytics;
  final String baseUrl = 'https://openrouter.ai/api/v1/chat/completions';

  OpenRouterAiRepository({
    required this.apiKey,
    required this.model,
    required this.analytics,
  });


  @override
  Future<String> getRecommendations(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'model': model,
          'messages': [
            {'role': 'user', 'content': prompt}
          ],
          'temperature': 0.3,
          'max_tokens': 18330,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final content = data['choices'][0]['message']['content'];
        return _processContent(content);
      } else {

        analytics.logError(
          'OpenRouter API error',
          error: Exception('HTTP ${response.statusCode}'),
          stackTrace: StackTrace.current,
        );
        throw Exception('OpenRouter API error: ${response.statusCode} - ${response.body}');
      }
    } catch (e, s) {
      analytics.logError(
        'OpenRouter request failed',
        error: e,
        stackTrace: s,
      );
      rethrow;
    }
  }

  String _processContent(String content) {
    return content.replaceAll('<think>', '').replaceAll('</think>', '');
  }
}