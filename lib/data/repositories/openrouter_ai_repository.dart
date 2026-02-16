import 'dart:convert';
import 'package:healthy_eating_app/domain/repositories/ai_repository.dart';
import 'package:http/http.dart' as http;

class OpenRouterAiRepository implements AiRepository {
  final String apiKey;
  final String model; // например "deepseek/deepseek-r1"
  final String baseUrl = 'https://openrouter.ai/api/v1/chat/completions';

  OpenRouterAiRepository({required this.apiKey, required this.model});

  @override
  Future<String> getRecommendations(String prompt) async {
    final response = await http.post(
      Uri.parse(baseUrl),
      headers: {
        'Authorization': 'Bearer $apiKey',
        'Content-Type': 'application/json',
        // Опционально: HTTP-Referer и X-Title для статистики OpenRouter
        // 'HTTP-Referer': 'https://yourapp.com',
        // 'X-Title': 'Healthy Eating App',
      },
      body: jsonEncode({
        'model': model,
        'messages': [
          {'role': 'user', 'content': prompt}
        ],
        // Можно настроить параметры генерации
        'temperature': 0.7,
        /// ///////// 'max_tokens': 1000,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Обычно OpenRouter возвращает choices[0].message.content
      final content = data['choices'][0]['message']['content'];
      // Убираем служебные теги, если есть (как в Python примере)
      return _processContent(content);
    } else {
      throw Exception('OpenRouter API error: ${response.statusCode} - ${response.body}');
    }
  }

  String _processContent(String content) {
    // Удаляем теги <think> и </think> (и любые другие, если нужно)
    return content.replaceAll('<think>', '').replaceAll('</think>', '');
  }
}