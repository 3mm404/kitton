class KittonResponse {
  final dynamic raw;

  KittonResponse(this.raw);

  Map<String, dynamic> get body {
    final data = raw;

    if (data is Map<String, dynamic>) {
      final innerData = data['data'];

      if (innerData is Map<String, dynamic>) {
        return innerData;
      }

      return data;
    }

    throw FormatException(
      'Expected Map<String, dynamic>, got ${data.runtimeType}',
    );
  }
}