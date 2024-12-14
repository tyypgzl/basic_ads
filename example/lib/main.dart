import 'dart:developer';

import 'package:basic_ads/basic_ads.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await BasicAds.instance.initialize(
    config: const BasicAdsConfig(),
  );

  runApp(
    const BasicAppOpenAdWidget(
      displayMode: AppOpenAdDisplayMode.onlyAppStateChangedToForeground,
      replayInterval: Duration(days: 1),
      child: MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const BasicAppOpenAdWidget(
      child: MaterialApp(
        home: HomeView(),
      ),
    );
  }
}

@immutable
final class HomeView extends StatelessWidget {
  const HomeView({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            FilledButton(
              onPressed: () async {
                try {
                  await BasicAds.instance.interstitialAd.show();
                } catch (error, stackTrace) {
                  log(
                    'Interstitial Ad Error: ',
                    error: error,
                    stackTrace: stackTrace,
                  );
                }
              },
              child: const Text('Interstitial Ad'),
            ),
            FilledButton.tonal(
              onPressed: () async {
                try {
                  await BasicAds.instance.rewardedAd.show(
                    (value) => log('Rewarded Ad Reward: $value'),
                  );
                } catch (error, stackTrace) {
                  log(
                    'Rewarded Ad Error: ',
                    error: error,
                    stackTrace: stackTrace,
                  );
                }
              },
              child: const Text('Rewarded Ad'),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const BasicAdsBanner(),
    );
  }
}

@immutable
final class Test extends StatelessWidget {
  const Test({super.key});

  @override
  Widget build(BuildContext context) {
    return FilledButton.tonal(
      onPressed: () async {
        try {
          await BasicAds.instance.rewardedAd.show(
            (value) => log('Rewarded Ad Reward: $value'),
          );
        } catch (error, stackTrace) {
          log('Error: $error\n$stackTrace');
        }
      },
      child: const Text('Rewarded Ad'),
    );
  }
}
