part of 'kitton_base.dart';

extension KittonReaders on Kitton {
  String string(String key, [String fallback = '']) {
    final value = data[key];

    if (value == null) return fallback;

    return value.toString();
  }

  String str(String key, [String fallback = '']) {
    return string(key, fallback);
  }

  int intValue(String key, [int fallback = 0]) {
    final value = data[key];

    if (value == null) return fallback;
    if (value is int) return value;
    if (value is num) return value.toInt();

    return int.tryParse(value.toString()) ?? fallback;
  }

  int integer(String key, [int fallback = 0]) {
    return intValue(key, fallback);
  }

  double doubleValue(String key, [double fallback = 0.0]) {
    final value = data[key];

    if (value == null) return fallback;
    if (value is double) return value;
    if (value is num) return value.toDouble();

    return double.tryParse(value.toString()) ?? fallback;
  }

  double decimal(String key, [double fallback = 0.0]) {
    return doubleValue(key, fallback);
  }

  num numValue(String key, [num fallback = 0]) {
    final value = data[key];

    if (value == null) return fallback;
    if (value is num) return value;

    return num.tryParse(value.toString()) ?? fallback;
  }

  bool boolValue(String key, [bool fallback = false]) {
    final value = data[key];

    if (value == null) return fallback;
    if (value is bool) return value;
    if (value is num) return value != 0;

    if (value is String) {
      final normalized = value.toLowerCase().trim();

      if (['true', '1', 'yes', 'on'].contains(normalized)) {
        return true;
      }

      if (['false', '0', 'no', 'off'].contains(normalized)) {
        return false;
      }
    }

    return fallback;
  }

  bool boolean(String key, [bool fallback = false]) {
    return boolValue(key, fallback);
  }

  DateTime? date(String key) {
    final value = data[key];

    if (value == null) return null;
    if (value is DateTime) return value;
    if (value is String) return DateTime.tryParse(value);

    return null;
  }

  DateTime dateOr(String key, DateTime fallback) {
    return date(key) ?? fallback;
  }

  Map<String, dynamic> map(
    String key, [
    Map<String, dynamic> fallback = const {},
  ]) {
    final value = data[key];

    if (value == null) return Map<String, dynamic>.from(fallback);

    if (value is Map<String, dynamic>) {
      return Map<String, dynamic>.from(value);
    }

    if (value is Map) {
      return Map<String, dynamic>.from(value);
    }

    return Map<String, dynamic>.from(fallback);
  }

  List<dynamic> list(
    String key, [
    List<dynamic> fallback = const [],
  ]) {
    final value = data[key];

    if (value == null) return List<dynamic>.from(fallback);

    if (value is List) {
      return List<dynamic>.from(value);
    }

    return List<dynamic>.from(fallback);
  }

  List<String> stringList(String key) {
    return list(key).map((item) => item.toString()).toList();
  }

  List<int> intList(String key) {
    return list(key)
        .map((item) {
          if (item is int) return item;
          if (item is num) return item.toInt();

          return int.tryParse(item.toString());
        })
        .whereType<int>()
        .toList();
  }
}