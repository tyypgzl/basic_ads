import 'dart:io';

/// [BasicAdsConfig] using test ids default
/// if you want to use your own ids, you can add
/// your own ids in the constructor of the class.
final class BasicAdsConfig {
  const BasicAdsConfig({
    this.appOpenAdIds = const AppOpenAdIds.test(),
    this.bannerAdIds = const BannerAdIds.test(),
    this.interstitialAdIds = const InterstitialAdIds.test(),
    this.rewardedAdIds = const RewardedAdIds.test(),
  });

  /// If you want to use your prod ids, you can add
  /// [Google AdMob Docs](https://developers.google.com/admob/flutter/app-open)
  final AppOpenAdIds appOpenAdIds;

  /// If you want to use your prod ids, you can add
  /// [Google AdMob Docs](https://developers.google.com/admob/flutter/banner)
  final BannerAdIds bannerAdIds;

  /// If you want to use your prod ids, you can add
  /// [Google AdMob Docs](https://developers.google.com/admob/flutter/interstitial)
  final InterstitialAdIds interstitialAdIds;

  /// If you want to use your prod ids, you can add
  /// [Google AdMob Docs](https://developers.google.com/admob/flutter/rewarded)
  final RewardedAdIds rewardedAdIds;
}

final class BannerAdIds {
  const BannerAdIds({
    required this.android,
    required this.ios,
  });

  const BannerAdIds.test({
    this.android = 'ca-app-pub-3940256099942544/9214589741',
    this.ios = 'ca-app-pub-3940256099942544/2435281174',
  });

  final String android;
  final String ios;

  String get platform => Platform.isAndroid ? android : ios;
}

final class InterstitialAdIds {
  const InterstitialAdIds({
    required this.android,
    required this.ios,
  });

  const InterstitialAdIds.test({
    this.android = 'ca-app-pub-3940256099942544/1033173712',
    this.ios = 'ca-app-pub-3940256099942544/4411468910',
  });

  final String android;
  final String ios;

  String get platform => Platform.isAndroid ? android : ios;
}

final class RewardedAdIds {
  const RewardedAdIds({
    required this.android,
    required this.ios,
  });

  const RewardedAdIds.test({
    this.android = 'ca-app-pub-3940256099942544/5224354917',
    this.ios = 'ca-app-pub-3940256099942544/1712485313',
  });

  final String android;
  final String ios;

  String get platform => Platform.isAndroid ? android : ios;
}

final class AppOpenAdIds {
  const AppOpenAdIds({
    required this.android,
    required this.ios,
  });

  const AppOpenAdIds.test({
    this.android = 'ca-app-pub-3940256099942544/9257395921',
    this.ios = 'ca-app-pub-3940256099942544/5575463023',
  });

  final String android;
  final String ios;

  String get platform => Platform.isAndroid ? android : ios;
}
