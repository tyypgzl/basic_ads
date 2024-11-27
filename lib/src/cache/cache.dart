import 'package:shared_preferences/shared_preferences.dart';

enum CacheKeys {
  appOpenAdsLastShowTime,
}

final class CacheException implements Exception {
  const CacheException(this.error);

  final Object error;

  @override
  String toString() {
    return 'CacheException: $error';
  }
}

final class Cache {
  const Cache();
  Future<DateTime?> readLastShowTime() async {
    try {
      final sharedPref = SharedPreferencesAsync();
      final lastShowInt = await sharedPref.getInt(
        CacheKeys.appOpenAdsLastShowTime.name,
      );
      if (lastShowInt != null) {
        return DateTime.fromMillisecondsSinceEpoch(
          lastShowInt,
          isUtc: true,
        ).toLocal();
      }
      return null;
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        CacheException(error),
        stackTrace,
      );
    }
  }

  Future<void> writeLastShowTime(DateTime time) async {
    try {
      final sharedPref = SharedPreferencesAsync();
      await sharedPref.setInt(
        CacheKeys.appOpenAdsLastShowTime.name,
        time.toUtc().millisecondsSinceEpoch,
      );
    } catch (error, stackTrace) {
      Error.throwWithStackTrace(
        CacheException(error),
        stackTrace,
      );
    }
  }
}
