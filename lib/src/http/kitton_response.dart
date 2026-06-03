class KittonResponse {
  final dynamic raw;

  KittonResponse(this.raw);

  dynamic get body {
    final data = raw;

    if (data is Map<String, dynamic>) {
      if (data.containsKey('data')) {
        return data['data'];
      }

      return data;
    }

    if (data is List) {
      return data;
    }

    throw FormatException('Expected Map or List, got ${data.runtimeType}');
  }
}
