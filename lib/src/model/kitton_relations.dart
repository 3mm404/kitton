part of 'kitton_base.dart';

extension KittonRelations on Kitton {
  T model<T extends Kitton>(
    String key,
    T Function(Map<String, dynamic>) builder,
  ) {
    final value = data[key];

    if (value is Map<String, dynamic>) {
      return builder(Map<String, dynamic>.from(value));
    }

    if (value is Map) {
      return builder(Map<String, dynamic>.from(value));
    }

    return builder({});
  }

  T? nullableModel<T extends Kitton>(
    String key,
    T Function(Map<String, dynamic>) builder,
  ) {
    final value = data[key];

    if (value == null) return null;

    if (value is Map<String, dynamic>) {
      return builder(Map<String, dynamic>.from(value));
    }

    if (value is Map) {
      return builder(Map<String, dynamic>.from(value));
    }

    return null;
  }

  List<T> models<T extends Kitton>(
    String key,
    T Function(Map<String, dynamic>) builder,
  ) {
    final value = data[key];

    if (value is! List) return [];

    return value
        .whereType<Map>()
        .map((item) => builder(Map<String, dynamic>.from(item)))
        .toList();
  }
}