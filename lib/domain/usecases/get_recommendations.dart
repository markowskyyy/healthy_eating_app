import 'package:healthy_eating_app/core/usecase/usecase.dart';
import 'package:healthy_eating_app/domain/entities/food_entry.dart';
import 'package:healthy_eating_app/domain/repositories/ai_repository.dart';
import 'package:healthy_eating_app/domain/repositories/food_repository.dart';

class GetRecommendations implements UseCase<String, void> {
  final FoodRepository foodRepository;
  final AiRepository aiRepository;

  GetRecommendations(this.foodRepository, this.aiRepository);

  @override
  Future<String> call({void params}) async {
    final entries = await foodRepository.getEntries();
    final prompt = _buildPrompt(entries);
    return await aiRepository.getRecommendations(prompt);
  }

  String _buildPrompt(List<FoodEntry> entries) {
    if (entries.isEmpty) {
      return 'У меня нет записей о еде. Дай общие рекоммендации о ток какой должен быть рацион';
    }

    if (entries.length > 50) entries.take(50).toList();

    final buffer = StringBuffer();
    buffer.writeln(
      'Проанализируй мой рацион питания за последний месяц. '
      'Ниже приведен список продуктов с граммовкой и датой/временем употребления. '
      'Учти, что калорийность некоторых продуктов не указана (помечена как "?"), '
      'тебе нужно оценить их примерную энергетическую ценность самостоятельно '
      'на основе стандартных данных (например, кола ~40 ккал/100г, сахар ~400 ккал/100г, '
      'торт ~350-450 ккал/100г, желе ~60-80 ккал/100г).\n'
    );

    buffer.writeln('Вот мои записи:\n');
    for (var entry in entries) {
      buffer.writeln('- ${entry.name} (${entry.toString()}) / ${entry.date}');
    }

    buffer.writeln(
    '''Пожалуйста, дай подробный ответ, который должен включать следующие пункты:
      
    1. Общая оценка рациона: Насколько сбалансированным (или не сбалансированным) является мое питание? Какие продукты доминируют?
    2. Анализ калорийности и БЖУ: Рассчитай примерную суммарную калорийность за указанный период. Есть ли явный переизбыток или недостаток калорий? Каких макронутриентов (белки, жиры, углеводы) критически не хватает, а каких в избытке? (Обрати внимание на огромное количество сахара). но не перечисляй мои продукты / напиши только вывод
    3. Анализ времени приема пищи: Я ем преимущественно ночью/под утро (время указано). Как это влияет на пищеварение, метаболизм и качество сна? Дай рекомендации по оптимальному режиму питания.
    4. Риски для здоровья: К каким последствиям может привести такой рацион (сахар, газировка, отсутствие овощей/клетчатки) при регулярном повторении?
    5. Рекомендации по улучшению:
       - Что нужно срочно добавить в рацион (овощи, сложные углеводы, норму белка)?
       - Чем можно заменить вредные продукты (сахар, колу) без сильного стресса для организма?
       - Каких продуктов категорически не хватает судя по этому списку?
    
    Оформи ответ понятными блоками или списком, чтобы мне было удобно читать.'''
    );


    return buffer.toString();
  }
}