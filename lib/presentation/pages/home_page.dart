import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
import 'package:healthy_eating_app/core/adHelper/ad_helper.dart';
import 'package:healthy_eating_app/core/consts/design.dart';
import 'package:healthy_eating_app/domain/entities/food_entry.dart';
import 'package:healthy_eating_app/domain/extensions/context_localizations.dart';
import 'package:healthy_eating_app/presentation/providers/providers.dart';
import 'package:healthy_eating_app/presentation/viewmodels/home/home_viewmodel.dart';
import 'package:healthy_eating_app/presentation/widgets/food_entry_dialog.dart';
import 'package:healthy_eating_app/presentation/widgets/home_page_body.dart';


class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  ConsumerState<HomePage> createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  BannerAd? _bannerAd;
  bool _isBannerLoaded = false;

  @override
  void initState() {
    super.initState();

    _bannerAd = BannerAd(
      adUnitId: AdHelper.bannerAdUnitId,
      request: const AdRequest(),
      size: AdSize.banner,
      listener: BannerAdListener(
        onAdLoaded: (ad) {
          setState(() {_isBannerLoaded = true;});
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          debugPrint('BannerAd failed: $error');
        },
      ),
    )..load();
  }

  @override
  void dispose() {
    _bannerAd?.dispose();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    final homeState = ref.watch(homeViewModelProvider);
    final notifier = ref.read(homeViewModelProvider.notifier);
    final appHud = ref.read(appHudRepositoryProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          context.localizations.homeTitle,
          style: AppTextStyles.titleWhite,
        ),
        backgroundColor: AppColors.primary,
      ),
      body: Column(
        children: [
          // if (_isBannerLoaded && _bannerAd != null)
          //   SizedBox(
          //     width: _bannerAd!.size.width.toDouble(),
          //     height: _bannerAd!.size.height.toDouble(),
          //     child: AdWidget(ad: _bannerAd!),
          // ),
          Expanded(
            child: homeState.when(
              data: (state) => HomePageBody(
                selectDate: notifier.selectDate,
                deleteEntry: notifier.deleteEntry,
                selectedDate: state.selectedDate,
                entries: notifier.filteredEntries(),
                onEditEntry: (entry) => _showEditDialog(context, ref, entry),
              ),
              loading: () => const Center(
                child: CircularProgressIndicator(),
              ),
              error: (error, stack) => Center(
                child: Text(
                  context.localizations.errorPrefix(error.toString()),
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddDialog(context, ref),
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.add),
      ),
    );
  }

  void _showAddDialog(BuildContext context, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (ctx) => FoodEntryDialog(
        onSubmit: (name, mass, calories) {
          ref.read(homeViewModelProvider.notifier).addEntry(name, mass, calories);
        },
        buttonText: context.localizations.addButton,
        mode: FoodEntryDialogMode.add,
      ),
    );
  }

  void _showEditDialog(
      BuildContext context,
      WidgetRef ref,
      FoodEntry entry,
      ) {
    showDialog(
      context: context,
      builder: (ctx) => FoodEntryDialog(
        initialName: entry.name,
        initialMass: entry.mass,
        initialCalories: entry.calories,
        onSubmit: (name, mass, calories) {
          final updatedEntry = FoodEntry(
            id: entry.id,
            date: entry.date,
            name: name,
            mass: mass,
            calories: calories,
          );
          ref.read(homeViewModelProvider.notifier).updateEntry(updatedEntry);
        },
        buttonText: context.localizations.saveButton,
        mode: FoodEntryDialogMode.edit,
      ),
    );
  }
}