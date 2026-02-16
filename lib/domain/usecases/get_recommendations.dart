import 'package:healthy_eating_app/domain/entities/food_entry.dart';
import 'package:healthy_eating_app/domain/repositories/ai_repository.dart';
import 'package:healthy_eating_app/domain/repositories/food_repository.dart';

class GetRecommendations {
  final FoodRepository foodRepository;
  final AiRepository aiRepository;

  GetRecommendations(this.foodRepository, this.aiRepository);

  Future<String> call(DateTime start, DateTime end) async {

    // Получаем записи за период
    final entries = await foodRepository.getEntriesForPeriod(start, end);

    // Формируем промпт
    final prompt = _buildPrompt(entries);

    // Отправляем в AI и возвращаем ответ
    return await aiRepository.getRecommendations(prompt);

  }

  String _buildPrompt(List<FoodEntry> entries) {
    if (entries.isEmpty) {
      return 'У меня нет записей о еде. Дай общие рекоммендации о ток какой должен быть рацион';
    }

    final buffer = StringBuffer();
    buffer.writeln('Сделай анализ моего рациона питания за последний месяц. Вот список продуктов, которые я ел:');
    for (var entry in entries) {
      buffer.writeln('- ${entry.name} (${entry.calories?.toStringAsFixed(0) ?? '?'} ккал)');
    }
    buffer.writeln();
    buffer.writeln('Пожалуйста, дай рекомендации по улучшению рациона, учитывая баланс калорий, разнообразие продуктов и возможные недостающие питательные вещества.');

    return buffer.toString();
  }
}