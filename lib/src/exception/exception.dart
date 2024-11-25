final class BasicAdsException implements Exception {
  const BasicAdsException(this.error);

  final Object error;

  @override
  String toString() {
    return 'BasicAdsException: $error';
  }
}
