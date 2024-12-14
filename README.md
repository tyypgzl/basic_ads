# Basic Ads

This is simple ads package top of the Google Mobile Ads. It's easy to use and customize.

## Getting Started

### 1. Add dependency

```yaml
dependencies:
  basic_ads: ^1.0.0
```

### 2. Platform Specific Setup

#### Prerequisites
- Android API level 20 or higher
- set `compileSdkVersion` or `compileSdk` to 28 or higher in your `android/app/build.gradle` file

#### Android

Add the following code to your `AndroidManifest.xml` file.

```xml
<application>
    <meta-data
        android:name="com.google.android.gms.ads.APPLICATION_ID"
        android:value="ca-app-pub-################~##########"/>
</application>
```

> Note: Replace `ca-app-pub-################~##########` with your AdMob App ID.

#### iOS

Add the following code to your `Info.plist` file.

```xml
<key>GADApplicationIdentifier</key>
<string>ca-app-pub-################~##########</string>
```

> Note: Replace `ca-app-pub-################~##########` with your AdMob App ID.



### 3. Initialize

Add the following code to your main function. This will initialize the ads.

```dart
import 'package:basic_ads/basic_ads.dart';

WidgetsFlutterBinding.ensureInitialized();

await BasicAds.instance.initialize(
  config: const BasicAdsConfig(),
);
```

> Note: You can customize the ads by passing the `BasicAdsConfig` object to the `initialize` method. If you don't pass the `BasicAdsConfig` object, the default configuration will be used. Default configuration is using the test ad unit ids.

### 4. Show Banner Ads

Add the following code to your widget. This will show the banner ads at the bottom of the screen.

```dart
Scaffold(
  body: Center(),
  bottomNavigationBar: BasicAdsBanner(),
);
```

### 5. Show Interstitial Ads

Add the following code to your widget. This will show the interstitial ads.

```dart
ElevatedButton(
  onPressed: () async {
    try {
      await BasicAds.instance.interstitialAd.show();
    } catch (error,stackTrace) {
        log('Error: $error\n$stackTrace');
    }
  },
  child: const Text('Show Interstitial Ad'),
);
```

### 6. Show Rewarded Ads

Add the following code to your widget. This will show the rewarded ads.

```dart
FilledButton.tonal(
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
```

7. Show App Open Ads

Wrap the widget that top of the widget tree with `BasicAppOpenAdWidget`. This will show the app open ads. Or you can wrap to `runApp` method or `MaterialApp` widget.


```dart
runApp(
  const BasicAppOpenAdWidget(
    displayMode: AppOpenAdDisplayMode.onlyAppStateChangedToForeground,
    replayInterval: Duration(days: 1),
    child: MainApp(),
  ),
);
```

- displayMode(Enum)

It's about when you show adverts. You can choose one of the following options.

  - `AppOpenAdDisplayMode.onlyFirstOpen`
  Show the ad only the first time the app is opened. If the app is switch to the background and then to the foreground, the ad will not be shown.

  - `AppOpenAdDisplayMode.firstOpenAndAppStateChangedToForeground`
  Show the ad the first time the app is opened or when the app is switched to the background and then to the foreground.
  - `AppOpenAdDisplayMode.onlyAppStateChangedToForeground`
  Show the ad only when the app is switched to the background and then to the foreground.

- replayInterval(Duration)

It's about how often you show adverts. If you set the value to 1 day, the ad will be shown once a day. 
> Default value is 1 day.

