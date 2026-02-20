import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthy_eating_app/domain/repositories/apphud_repository.dart';
import 'package:healthy_eating_app/presentation/viewmodels/purchases/purchases_state.dart';

class PurchasesViewModel extends StateNotifier<PurchasesState> {
  final AppHudRepository appHud;

  PurchasesViewModel(
      this.appHud, {required bool initialSubscribed}) : super(
    PurchasesState.initial().copyWith(isSubscribed: initialSubscribed),
  ) {
    load();
  }


  Future<void> load() async {
    try {
      state = state.copyWith(isLoading: true);

      final isSubscribed = await appHud.isSubscribed();
      if (!mounted) return;

      final placements = await appHud.getPlacements();
      if (!mounted) return;

      state = state.copyWith(
        isSubscribed: isSubscribed,
        placements: placements,
        isLoading: false,
      );
    } catch (e) {
      if (!mounted) return;

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