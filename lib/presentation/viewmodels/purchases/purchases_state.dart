import 'package:healthy_eating_app/domain/entities/apphud_entities.dart';

class PurchasesState {
  final bool isSubscribed;
  final List<AppHudPlacement> placements;
  final bool isLoading;
  final String? error;

  const PurchasesState({
    required this.isSubscribed,
    required this.placements,
    required this.isLoading,
    this.error,
  });

  factory PurchasesState.initial() => const PurchasesState(
    isSubscribed: false,
    placements: [],
    isLoading: true,
  );

  PurchasesState copyWith({
    bool? isSubscribed,
    List<AppHudPlacement>? placements,
    bool? isLoading,
    String? error,
  }) {
    return PurchasesState(
      isSubscribed: isSubscribed ?? this.isSubscribed,
      placements: placements ?? this.placements,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }
}