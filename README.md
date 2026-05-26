# Kitton

Kitton is a lightweight Dart model layer for working with API data in Flutter.

Helps you convert raw `Map<String, dynamic>` responses into clean, typed models — with less boilerplate and more clarity.

Inspired by Laravel's Eloquent model conventions.

---

## Features

- ✅ Typed value readers (`string`, `intValue`, `boolValue`, `date`, etc.)
- ✅ Nested model parsing (`model`, `nullableModel`, `models`)
- ✅ Safe type coercion — no crashes on `"1"` vs `1`
- ✅ JSON serialization with `toJson` / `toRawJson`
- ✅ Laravel-style `hidden`, `visible`, `only`, `except`, `fill`
- ✅ No code generation required
- ✅ No `fromJson` factory required

---

## Installation

Add Kitton to your `pubspec.yaml`:

```yaml
dependencies:
  kitton:
    path: ../kitton
```

Or once published to pub.dev:

```yaml
dependencies:
  kitton: ^0.1.0
```

---

## Quick Start

```dart
class User extends Kitton {
  User(super.data);

  int get id => intValue('id');
  String get email => string('email');
  bool get isActive => boolValue('active');
}

final user = User({
  'id': '1',
  'email': 'test@mail.com',
  'active': 'yes',
});

print(user.id);       // 1
print(user.email);    // test@mail.com
print(user.isActive); // true
```

---

## Typed Readers

All readers accept a fallback value and handle `null` safely.

| Method | Returns | Notes |
|---|---|---|
| `string(key)` / `str(key)` | `String` | Calls `.toString()` on any value |
| `intValue(key)` / `integer(key)` | `int` | Parses strings automatically |
| `doubleValue(key)` / `decimal(key)` | `double` | Parses strings automatically |
| `numValue(key)` | `num` | — |
| `boolValue(key)` / `boolean(key)` | `bool` | Supports `true/false`, `1/0`, `"yes"/"no"`, `"on"/"off"` |
| `date(key)` | `DateTime?` | Returns `null` if unparseable |
| `dateOr(key, fallback)` | `DateTime` | Returns fallback if null |
| `map(key)` | `Map<String, dynamic>` | — |
| `list(key)` | `List<dynamic>` | — |
| `stringList(key)` | `List<String>` | — |
| `intList(key)` | `List<int>` | Filters out unparseable items |

---

## Nested Models

### Single model

```dart
class Order extends Kitton {
  Order(super.data);

  User get user => model<User>('user', User.new);
}
```

### Nullable model

```dart
class Order extends Kitton {
  Order(super.data);

  User? get user => nullableModel<User>('user', User.new);
}
```

### List of models

```dart
class Cart extends Kitton {
  Cart(super.data);

  List<Product> get items => models<Product>('items', Product.new);
}
```

---

## Serialization

```dart
final user = User({'id': 1, 'email': 'a@b.com', 'password': 'secret'});

user.toJson();    // applies hidden / visible filters
user.toRawJson(); // returns all fields as-is
```

### Hidden fields

```dart
class User extends Kitton {
  User(super.data);

  @override
  List<String> get hidden => ['password', 'token'];
}
```

### Visible fields (whitelist)

```dart
class User extends Kitton {
  User(super.data);

  @override
  List<String> get visible => ['id', 'name', 'email'];
}
```

---

## Field Filtering

```dart
final user = User({'id': 1, 'name': 'Ana', 'password': 'secret'});

user.only(['id', 'name']);    // {'id': 1, 'name': 'Ana'}
user.except(['password']);    // {'id': 1, 'name': 'Ana'}
user.fill(['id', 'name']);    // alias for only()
user.merge({'role': 'admin'}); // {'id': 1, ..., 'role': 'admin'}
```

---

## Utility Methods

```dart
user.has('email');     // true if key exists and value is not null
user.missing('email'); // opposite of has()
user.get('email');     // raw dynamic value
user.attr('email');    // alias for get()
user.isEmpty;          // true if data map is empty
user.isNotEmpty;       // true if data map has entries
```

---

## Philosophy

- **Minimal boilerplate** — extend, declare getters, done.
- **Convention over configuration** — sensible defaults for all readers.
- **Explicit over magic** — no reflection, no code generation.
- **No required `fromJson`** — just pass a `Map` to the constructor.

---

## License

MIT
