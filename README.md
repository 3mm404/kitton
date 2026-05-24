/// Base class for all application models.
///
/// Kitton provides:
/// - Typed value readers
/// - Nested model parsing
/// - Safe field filtering
/// - JSON serialization
/// - Laravel-like hidden / visible fields
///
/// Philosophy:
/// - Minimal boilerplate
/// - Convention over configuration
/// - Explicit over magic
/// - No required fromJson factory
///
/// Example:
/// ```dart
/// class User extends Kitton {
///   User(super.data);
///
///   int get id => intValue('id');
///   String get email => string('email');
/// }
///
/// final user = User({
///   'id': '1',
///   'email': 'test@mail.com',
/// });
///
/// print(user.id);
/// print(user.email);
/// ```
abstract class Kitton {
  /// Internal raw data map.
  final Map<String, dynamic> data;

  /// Creates a new model instance from a raw map.
  Kitton(Map<String, dynamic> data)
      : data = Map<String, dynamic>.from(data);

  /// Fields that should be hidden when calling [toJson].
  ///
  /// Example:
  /// ```dart
  /// @override
  /// List<String> get hidden => ['password', 'token'];
  /// ```
  List<String> get hidden => const [];

  /// Fields that should be visible when calling [toJson].
  ///
  /// If this list is not empty, only these fields will be returned.
  ///
  /// Example:
  /// ```dart
  /// @override
  /// List<String> get visible => ['id', 'name', 'email'];
  /// ```
  List<String> get visible => const [];

  /// Returns the raw value for a given key.
  dynamic get(String key) => data[key];

  /// Alias for [get].
  dynamic attr(String key) => get(key);

  /// Checks if a key exists and its value is not null.
  bool has(String key) {
    return data.containsKey(key) && data[key] != null;
  }

  /// Checks if a key does not exist or its value is null.
  bool missing(String key) {
    return !has(key);
  }

  /// Checks if the model has no data.
  bool get isEmpty => data.isEmpty;

  /// Checks if the model has data.
  bool get isNotEmpty => data.isNotEmpty;

  /// Reads a value as String.
  String string(String key, [String fallback = '']) {
    final value = data[key];

    if (value == null) return fallback;

    return value.toString();
  }

  /// Alias for [string].
  String str(String key, [String fallback = '']) {
    return string(key, fallback);
  }

  /// Reads a value as int.
  int intValue(String key, [int fallback = 0]) {
    final value = data[key];

    if (value == null) return fallback;

    if (value is int) return value;

    if (value is num) return value.toInt();

    return int.tryParse(value.toString()) ?? fallback;
  }

  /// Alias for [intValue].
  int integer(String key, [int fallback = 0]) {
    return intValue(key, fallback);
  }

  /// Reads a value as double.
  double doubleValue(String key, [double fallback = 0.0]) {
    final value = data[key];

    if (value == null) return fallback;

    if (value is double) return value;

    if (value is num) return value.toDouble();

    return double.tryParse(value.toString()) ?? fallback;
  }

  /// Alias for [doubleValue].
  double decimal(String key, [double fallback = 0.0]) {
    return doubleValue(key, fallback);
  }

  /// Reads a value as num.
  num numValue(String key, [num fallback = 0]) {
    final value = data[key];

    if (value == null) return fallback;

    if (value is num) return value;

    return num.tryParse(value.toString()) ?? fallback;
  }

  /// Reads a value as bool.
  ///
  /// Supports:
  /// - true / false
  /// - 1 / 0
  /// - "true" / "false"
  /// - "yes" / "no"
  /// - "on" / "off"
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

  /// Alias for [boolValue].
  bool boolean(String key, [bool fallback = false]) {
    return boolValue(key, fallback);
  }

  /// Reads a value as DateTime.
  ///
  /// Returns null if parsing fails.
  DateTime? date(String key) {
    final value = data[key];

    if (value == null) return null;

    if (value is DateTime) return value;

    if (value is String) {
      return DateTime.tryParse(value);
    }

    return null;
  }

  /// Reads a value as DateTime or returns fallback.
  DateTime dateOr(String key, DateTime fallback) {
    return date(key) ?? fallback;
  }

  /// Reads a value as Map<String, dynamic>.
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

  /// Reads a value as List<dynamic>.
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

  /// Reads a value as List<String>.
  List<String> stringList(String key) {
    return list(key).map((item) => item.toString()).toList();
  }

  /// Reads a value as List<int>.
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

  /// Parses a nested model.
  ///
  /// Example:
  /// ```dart
  /// User get user => model<User>('user', User.new);
  /// ```
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

  /// Parses a nullable nested model.
  ///
  /// Useful when the API may return null.
  ///
  /// Example:
  /// ```dart
  /// User? get user => nullableModel<User>('user', User.new);
  /// ```
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

  /// Parses a list of nested models.
  ///
  /// Example:
  /// ```dart
  /// List<User> get users => models<User>('users', User.new);
  /// ```
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

  /// Returns only the specified keys.
  Map<String, dynamic> only(List<String> keys) {# Kitton

Kitton is a lightweight Dart model layer for working with API data.

It helps you convert raw `Map<String, dynamic>` responses into clean, typed models with less boilerplate.

Inspired by Laravel models and simple JSON mapping patterns.

---

## Features

- Typed value readers
- Nested model parsing
- List model parsing
- Safe JSON serialization
- Hidden and visible fields
- Laravel-like `only`, `except`, and `fill`
- Optional HTTP helper with `KittonApi`

---

## Installation

For local development:

```yaml
dependencies:
  kitton:
    path: ../kitton
    return {
      for (final key in keys)
        if (data.containsKey(key)) key: data[key],
    };
  }

  /// Returns all fields except the specified keys.
  Map<String, dynamic> except(List<String> keys) {
    final json = Map<String, dynamic>.from(data);

    for (final key in keys) {
      json.remove(key);
    }

    return json;
  }

  /// Alias of [only].
  ///
  /// Inspired by Laravel's fillable fields.
  Map<String, dynamic> fill(List<String> fields) {
    return only(fields);
  }

  /// Returns a new map with merged values.
  ///
  /// Does not mutate the original model.
  Map<String, dynamic> merge(Map<String, dynamic> values) {
    return {
      ...data,
      ...values,
    };
  }

  /// Converts the model into JSON.
  ///
  /// Applies:
  /// - hidden fields
  /// - visible fields
  /// - nested lists/maps cleanup
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

  /// Returns the raw cloned map without applying hidden / visible.
  Map<String, dynamic> toRawJson() {
    return _normalizeMap(data);
  }

  /// Normalizes a map recursively.
  Map<String, dynamic> _normalizeMap(Map<String, dynamic> source) {
    return source.map((key, value) {
      return MapEntry(key, _normalizeValue(value));
    });
  }

  /// Normalizes values recursively.
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

  @override
  String toString() {
    return '${runtimeType.toString()}(${toJson()})';
  }
}


Estoy trabajando 