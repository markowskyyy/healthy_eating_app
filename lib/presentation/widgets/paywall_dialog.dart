import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:healthy_eating_app/core/consts/design.dart';
import 'package:healthy_eating_app/domain/extensions/context_localizations.dart';
import 'package:healthy_eating_app/presentation/providers/providers.dart';

class PaywallDialog extends ConsumerWidget {
  const PaywallDialog({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(purchasesViewModelProvider);
    final vm = ref.read(purchasesViewModelProvider.notifier);

    return AlertDialog(
      title: Text(context.localizations.subscriptionTitle),
      content: state.isLoading
          ? const SizedBox(
        height: 100,
        child: Center(child: CircularProgressIndicator()),
      )
          : Column(
        mainAxisSize: MainAxisSize.min,
        children: state.placements
            .expand((p) => p.paywall!.products)
            .map(
              (product) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                  children: [
                    Text(
                      product.name,
                      style: AppTextStyles.subtitle
                    ),
                    Text(
                      '${product.price} ${product.currencyCode}',
                      style: AppTextStyles.body
                    ),
                    const SizedBox(height: 12),
                    ElevatedButton(
                      onPressed: () async {
                        await vm.buy(product.id);
                        Navigator.pop(context);
                      },
                      child: Text(context.localizations.buyButton),
                    ),
                  ],
                ),
              )
        ).toList(),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: Text(context.localizations.cancelButton),
        ),
      ],
    );
  }
}