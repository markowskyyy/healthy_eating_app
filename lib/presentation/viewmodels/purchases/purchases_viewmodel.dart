import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthy_eating_app/domain/repositories/apphud_repository.dart';
import 'package:healthy_eating_app/presentation/viewmodels/purchases/purchases_state.dart';

class PurchasesViewModel extends StateNotifier<PurchasesState> {
  final AppHudRepository appHud;

  PurchasesViewModel(
      this.appHud, {required bool initialSubscribed}) : super(
    PurchasesState.initial().copyWith(isSubscribed: initialSubscribed),
  ) {
    _init();
  }

  Future<void> _init() async {
    final placements = await appHud.getPlacements();
    state = state.copyWith(placements: placements);
  }

  Future<void> load() async {
    try {
      state = state.copyWith(isLoading: true);

      final isSubscribed = await appHud.isSubscribed();
      final placements = await appHud.getPlacements();

      state = state.copyWith(
        isSubscribed: isSubscribed,
        placements: placements,
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: e.toString(),
      );
    }
  }

  Future<void> buy(String productId) async {
    await appHud.purchase(productId);
    await load();
  }
}