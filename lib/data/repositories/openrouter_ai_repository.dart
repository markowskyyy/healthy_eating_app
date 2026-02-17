import 'dart:convert';
import 'package:healthy_eating_app/domain/repositories/ai_repository.dart';
import 'package:http/http.dart' as http;

class OpenRouterAiRepository implements AiRepository {
  final String apiKey;
  final String model;
  final String baseUrl = 'https://openrouter.ai/api/v1/chat/completions';

  OpenRouterAiRepository({required this.apiKey, required this.model});

  @override
  Future<String> getRecommendations(String prompt) async {
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
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final content = data['choices'][0]['message']['content'];
      return _processContent(content);
    } else {
      throw Exception('OpenRouter API error: ${response.statusCode} - ${response.body}');
    }
  }

  String _processContent(String content) {
    return content.replaceAll('<think>', '').replaceAll('</think>', '');
  }
}