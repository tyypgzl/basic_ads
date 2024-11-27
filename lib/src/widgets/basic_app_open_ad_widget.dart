import 'dart:async';

import 'package:basic_ads/basic_ads.dart';
import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

enum AppOpenAdDisplayMode {
  /// Only show the ad on the first open of the app.
  /// If the app is in the background and brought to the foreground,
  /// the ad will not be shown.
  onlyFirstOpen,

  /// Show the ad on the first open of the app and when the app is brought
  /// to the foreground.
  firstOpenAndAppStateChangedToForeground,

  /// Show the ad when the app is brought to the foreground.
  /// If the app is opened for the first time, the ad will not be shown.
  onlyAppStateChangedToForeground;
}

@immutable
final class BasicAppOpenAdWidget extends StatefulWidget {
  const BasicAppOpenAdWidget({
    required this.child,
    this.displayMode = AppOpenAdDisplayMode.onlyFirstOpen,
    this.replayInterval = const Duration(days: 1),
    super.key,
  });

  final Widget child;
  final AppOpenAdDisplayMode displayMode;
  final Duration replayInterval;

  @override
  State<BasicAppOpenAdWidget> createState() => BasicAppOpenAdWidgetState();
}

final class BasicAppOpenAdWidgetState extends State<BasicAppOpenAdWidget> {
  StreamSubscription<AppState>? _subscription;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      AppStateEventNotifier.startListening();
      if (widget.displayMode == AppOpenAdDisplayMode.onlyFirstOpen ||
          widget.displayMode ==
              AppOpenAdDisplayMode.firstOpenAndAppStateChangedToForeground) {
        _show();
      }
      if (widget.displayMode ==
              AppOpenAdDisplayMode.onlyAppStateChangedToForeground ||
          widget.displayMode ==
              AppOpenAdDisplayMode.firstOpenAndAppStateChangedToForeground) {
        _subscription = AppStateEventNotifier.appStateStream.listen((event) {
          if (event == AppState.foreground) {
            _show();
          }
        });
      }
    });
  }

  @override
  void dispose() {
    AppStateEventNotifier.stopListening();
    _subscription?.cancel();
    super.dispose();
  }

  Future<void> _show() async {
    try {
      final completer = Completer<AppOpenAd>();
      final config = BasicAds.instance.config;

      await AppOpenAd.load(
        adUnitId: config.appOpenAdIds.platform,
        request: const AdRequest(),
        adLoadCallback: AppOpenAdLoadCallback(
          onAdLoaded: completer.complete,
          onAdFailedToLoad: completer.completeError,
        ),
      );
      final appOpenAd = await completer.future;
      appOpenAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) => ad.dispose(),
        onAdFailedToShowFullScreenContent: (ad, error) => ad.dispose(),
      );

      // chack interval and config date cache
      final lastShowTime = BasicAds.instance.appOpenAdsLastShowTime;
      if (lastShowTime != null) {
        final now = DateTime.now();
        final difference = now.difference(lastShowTime);
        if (difference < widget.replayInterval) {
          return;
        }
      }

      await appOpenAd.show();
      await BasicAds.instance.cache.writeLastShowTime(DateTime.now());
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        BasicAdsException(error),
        stackTrace,
      );
    }
  }

  @override
  Widget build(BuildContext context) => widget.child;
}
