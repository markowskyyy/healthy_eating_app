import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthy_eating_app/core/consts/design.dart';
import 'package:healthy_eating_app/domain/extensions/context_localizations.dart';
import 'package:healthy_eating_app/presentation/viewmodels/recommendations/recommendations_viewmodel.dart';


class RecommendationsScreen extends ConsumerWidget {
  const RecommendationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final recState = ref.watch(recommendationsViewModelProvider);
    final viewModel = ref.read(recommendationsViewModelProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.localizations.recommendationsTitle,
          style: AppTextStyles.title.copyWith(color: Colors.white),
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.grey.shade50,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: recState.when(
                  data: (state) => SingleChildScrollView(
                    child: Text(
                      state.response.isEmpty
                          ? context.localizations.recommendationsEmpty
                          : state.response,
                      style: AppTextStyles.body,
                    ),
                  ),
                  loading: () => const Center(child: CircularProgressIndicator()),
                  error: (error, stack) => Center(
                    child: Text(
                      context.localizations.errorPrefix(error.toString()),
                      style: const TextStyle(color: Colors.red),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => viewModel.fetchRecommendations(),
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primary,
                foregroundColor: Colors.black,
                minimumSize: const Size(double.infinity, 50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Text(
                context.localizations.getRecommendationsButton,
                style: AppTextStyles.subtitleWhite,
              ),
            ),
          ],
        ),
      ),
    );
  }
}