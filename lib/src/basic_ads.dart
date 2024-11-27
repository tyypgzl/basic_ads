import 'dart:async';

import 'package:basic_ads/src/cache/cache.dart';
import 'package:basic_ads/src/config/basic_ads_config.dart';
import 'package:basic_ads/src/exception/exception.dart';
import 'package:flutter/foundation.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

final class BasicAds {
  BasicAds._()
      : _config = const BasicAdsConfig(),
        interstitialAd = const BasicInterstitialAd(),
        cache = const Cache(),
        rewardedAd = const BasicRewardedAd();

  static final BasicAds _instance = BasicAds._();

  static BasicAds get instance => _instance;

  BasicAdsConfig _config;

  final BasicInterstitialAd interstitialAd;
  final BasicRewardedAd rewardedAd;
  final Cache cache;
  DateTime? _appOpenAdsLastShowTime;

  Future<void> initialize({
    required BasicAdsConfig config,
    List<String>? testDeviceIds,
  }) async {
    try {
      await MobileAds.instance.initialize();
      if (testDeviceIds != null) {
        await MobileAds.instance.updateRequestConfiguration(
          RequestConfiguration(
            testDeviceIds: testDeviceIds,
          ),
        );
      }
      _config = config;
      _appOpenAdsLastShowTime = await cache.readLastShowTime();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(BasicAdsException(error), stackTrace);
    }
  }

  BasicAdsConfig get config => _config;

  DateTime? get appOpenAdsLastShowTime => _appOpenAdsLastShowTime;
}

final class BasicInterstitialAd {
  const BasicInterstitialAd();

  Future<void> show() async {
    try {
      final completer = Completer<InterstitialAd>();
      await InterstitialAd.load(
        adUnitId: BasicAds.instance.config.interstitialAdIds.platform,
        request: const AdRequest(),
        adLoadCallback: InterstitialAdLoadCallback(
          onAdLoaded: completer.complete,
          onAdFailedToLoad: completer.completeError,
        ),
      );
      final interstitialAd = await completer.future;
      interstitialAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) => ad.dispose(),
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
        },
      );
      await interstitialAd.show();
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        BasicAdsException(error),
        stackTrace,
      );
    }
  }
}

final class BasicRewardedAd {
  const BasicRewardedAd();

  Future<void> show(
    ValueSetter<({num amount, String type})> onRewarded,
  ) async {
    try {
      final completer = Completer<RewardedAd>();
      await RewardedAd.load(
        adUnitId: BasicAds.instance.config.rewardedAdIds.platform,
        request: const AdRequest(),
        rewardedAdLoadCallback: RewardedAdLoadCallback(
          onAdLoaded: completer.complete,
          onAdFailedToLoad: completer.completeError,
        ),
      );
      final rewardedAd = await completer.future;
      rewardedAd.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) => ad.dispose(),
        onAdFailedToShowFullScreenContent: (ad, error) {
          ad.dispose();
        },
      );
      await rewardedAd.show(
        onUserEarnedReward: (ad, reward) => onRewarded.call(
          (
            amount: reward.amount,
            type: reward.type,
          ),
        ),
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        BasicAdsException(error),
        stackTrace,
      );
    }
  }
}
