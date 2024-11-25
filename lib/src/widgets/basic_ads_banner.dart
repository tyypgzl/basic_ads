import 'package:basic_ads/src/basic_ads.dart';
import 'package:flutter/widgets.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

@immutable
final class BasicAdsBanner extends StatefulWidget {
  const BasicAdsBanner({
    super.key,
  });

  @override
  State<BasicAdsBanner> createState() => _BasicAdsBannerState();
}

final class _BasicAdsBannerState extends State<BasicAdsBanner> {
  BannerAd? bannerAd;
  bool isLoaded = false;

  Future<void> loadAd() async {
    final AdSize? size =
        await AdSize.getCurrentOrientationAnchoredAdaptiveBannerAdSize(
      MediaQuery.sizeOf(context).width.truncate(),
    );
    if (size == null) {
      return;
    }
    final config = BasicAds.instance.config;
    bannerAd = BannerAd(
      adUnitId: config.bannerAdIds.platform,
      request: const AdRequest(),
      size: size,
      listener: BannerAdListener(
        onAdLoaded: (_) {
          setState(() {
            isLoaded = true;
          });
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
        },
      ),
    );
    await bannerAd?.load();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      loadAd();
    });
  }

  @override
  Widget build(BuildContext context) {
    if (bannerAd != null) {
      return SafeArea(
        child: SizedBox(
          width: bannerAd!.size.width.toDouble(),
          height: bannerAd!.size.height.toDouble(),
          child: AdWidget(ad: bannerAd!),
        ),
      );
    } else {
      return const SizedBox.shrink();
    }
  }
}
