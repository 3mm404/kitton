part of 'kitton_base.dart';

extension KittonSerialization on Kitton {
  Map<String, dynamic> toJson() {
    Map<String, dynamic> json = _normalizeMap(data);

    for (final key in hidden) {
      json.remove(key);
    }

    if (visible.isNotEmpty) {
      json = {
        for (final key in visible)
          if (json.containsKey(key)) key: json[key],
      };
    }

    return json;
  }

  Map<String, dynamic> toRawJson() {
    return _normalizeMap(data);
  }

  Map<String, dynamic> _normalizeMap(Map<String, dynamic> source) {
    return source.map((key, value) {
      return MapEntry(key, _normalizeValue(value));
    });
  }

  dynamic _normalizeValue(dynamic value) {
    if (value is Kitton) {
      return value.toJson();
    }

    if (value is Map<String, dynamic>) {
      return _normalizeMap(value);
    }

    if (value is Map) {
      return _normalizeMap(Map<String, dynamic>.from(value));
    }

    if (value is List) {
      return value.map(_normalizeValue).toList();
    }

    return value;
  }
}