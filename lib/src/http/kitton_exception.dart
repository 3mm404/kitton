class KittonException implements Exception {
  final String message;
  final Object? error;

  KittonException(
    this.message, {
    this.error,
  });

  factory KittonException.from(Object error) {
    return KittonException(
      error.toString(),
      error: error,
    );
  }

  @override
  String toString() {
    return 'KittonException: $message';
  }
}