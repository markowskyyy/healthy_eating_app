import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:healthy_eating_app/domain/usecases/get_recommendations.dart';
import 'package:healthy_eating_app/presentation/providers/providers.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'recommendations_viewmodel.freezed.dart';
part 'recommendations_viewmodel.g.dart';

@freezed
class RecommendationsState with _$RecommendationsState {
  const factory RecommendationsState({
    @Default('') String response,
  }) = _RecommendationsState;
}

@riverpod
class RecommendationsViewModel extends _$RecommendationsViewModel {
  late final GetRecommendations _getRecommendations;

  @override
  Future<RecommendationsState> build() async {
    _getRecommendations = ref.watch(getRecommendationsProvider);
    return const RecommendationsState();
  }

  Future<void> fetchRecommendations() async {
    state = const AsyncValue.loading();
    try {
      final response = await _getRecommendations(params: null);
      state = AsyncValue.data(RecommendationsState(response: response));
    } catch (e, stack) {
      state = AsyncValue.error(e, stack);
    }
  }
}