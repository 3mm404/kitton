# Kitton

**Kitton** is a lightweight model and JSON serialization layer for Dart and Flutter.

It helps you work with API data using strongly typed getters without code generation, annotations, reflection, or repetitive `fromJson()` methods.

```dart
final user = User(response.data);

print(user.name);
print(user.email);
```

No manual casting.

No code generation.

No annotations.

Just Dart models.

---

## Features

* Strongly typed model getters
* Automatic type conversion
* Nested models
* Nullable nested models
* Lists of models
* Recursive JSON serialization
* Hidden fields
* Visible fields
* `only()` and `except()` filters
* Raw serialization
* Zero code generation
* Zero annotations
* Zero reflection
* Pure Dart

---

## Installation

Add Kitton to your `pubspec.yaml`:

```yaml
dependencies:
  kitton: ^0.1.0
```

For local development:

```yaml
dependencies:
  kitton:
    path: ../kitton
```

Then run:

```bash
dart pub get
```

Or in Flutter:

```bash
flutter pub get
```

---

## Quick Start

Create a model by extending `Kitton`:

```dart
import 'package:kitton/kitton.dart';

class User extends Kitton {
  User(super.data);

  int get id => integer('id');

  String get name => string('name');

  String get email => string('email');

  bool get active => boolean('active');
}
```

Create the model using a JSON map:

```dart
final user = User({
  'id': '10',
  'name': 'Christian',
  'email': 'christian@example.com',
  'active': 1,
});
```

Access the values using typed getters:

```dart
print(user.id); // 10
print(user.name); // Christian
print(user.email); // christian@example.com
print(user.active); // true
```

Kitton automatically converts compatible values to the expected Dart type.

---

## Why Kitton?

Without Kitton:

```dart
final response = await dio.get('/profile');

final data = response.data as Map<String, dynamic>;

final id = int.parse(data['id'].toString());
final name = data['name']?.toString() ?? '';
final email = data['email']?.toString() ?? '';
final active = data['active'] == true || data['active'] == 1;
```

With Kitton:

```dart
final response = await dio.get('/profile');

final user = User(response.data);

print(user.id);
print(user.name);
print(user.email);
print(user.active);
```

Kitton keeps JSON parsing inside the model and makes the rest of the application easier to read.

---

# Creating Models

A Kitton model receives a `Map<String, dynamic>`.

```dart
class Product extends Kitton {
  Product(super.data);

  int get id => integer('id');

  String get name => string('name');

  double get price => decimal('price');

  bool get available => boolean('available');
}
```

Usage:

```dart
final product = Product({
  'id': 1,
  'name': 'Keyboard',
  'price': '49.99',
  'available': 'true',
});

print(product.price); // 49.99
```

---

# Typed Readers

Kitton provides typed readers with automatic value conversion.

| Method          | Return type            |
| --------------- | ---------------------- |
| `string()`      | `String`               |
| `str()`         | `String`               |
| `integer()`     | `int`                  |
| `intValue()`    | `int`                  |
| `decimal()`     | `double`               |
| `doubleValue()` | `double`               |
| `numValue()`    | `num`                  |
| `boolean()`     | `bool`                 |
| `boolValue()`   | `bool`                 |
| `date()`        | `DateTime?`            |
| `dateOr()`      | `DateTime`             |
| `map()`         | `Map<String, dynamic>` |
| `list()`        | `List<dynamic>`        |
| `stringList()`  | `List<String>`         |
| `intList()`     | `List<int>`            |

---

## String Values

```dart
String get name => string('name');
```

You can provide a fallback value:

```dart
String get name => string('name', 'Unknown');
```

Values are converted using `toString()`.

```dart
final model = User({
  'name': 123,
});

print(model.name); // 123
```

---

## Integer Values

```dart
int get age => integer('age');
```

Kitton supports integers, decimal numbers, and numeric strings:

```dart
final user = User({
  'age': '23',
});
```

```dart
print(user.age); // 23
```

You can provide a fallback:

```dart
int get age => integer('age', 18);
```

---

## Double Values

```dart
double get price => decimal('price');
```

Example:

```dart
final product = Product({
  'price': '99.50',
});

print(product.price); // 99.5
```

You can also use:

```dart
double get price => doubleValue('price');
```

---

## Boolean Values

```dart
bool get active => boolean('active');
```

Kitton recognizes common boolean representations:

```text
true
false
1
0
yes
no
on
off
```

Example:

```dart
final user = User({
  'active': 'yes',
});

print(user.active); // true
```

---

## Date Values

```dart
DateTime? get createdAt => date('created_at');
```

Example:

```dart
final user = User({
  'created_at': '2026-07-16T12:00:00Z',
});
```

```dart
print(user.createdAt);
```

You can provide a fallback with `dateOr()`:

```dart
DateTime get createdAt => dateOr(
      'created_at',
      DateTime.now(),
    );
```

---

## Map Values

```dart
Map<String, dynamic> get settings => map('settings');
```

Example:

```dart
final user = User({
  'settings': {
    'theme': 'dark',
    'notifications': true,
  },
});

print(user.settings['theme']); // dark
```

---

## List Values

```dart
List<dynamic> get roles => list('roles');
```

For string lists:

```dart
List<String> get roles => stringList('roles');
```

For integer lists:

```dart
List<int> get categoryIds => intList('category_ids');
```

Example:

```dart
final user = User({
  'roles': ['admin', 'editor'],
  'category_ids': ['1', 2, 3.0],
});
```

```dart
print(user.roles);
print(user.categoryIds);
```

---

# Nested Models

Kitton supports nested JSON objects.

```dart
class Address extends Kitton {
  Address(super.data);

  String get city => string('city');

  String get country => string('country');
}
```

```dart
class User extends Kitton {
  User(super.data);

  String get name => string('name');

  Address get address => model(
        'address',
        Address.new,
      );
}
```

Usage:

```dart
final user = User({
  'name': 'Christian',
  'address': {
    'city': 'Tuxtla Gutiérrez',
    'country': 'Mexico',
  },
});

print(user.address.city);
```

---

## Nullable Nested Models

Use `nullableModel()` when a nested object may be `null` or missing.

```dart
class User extends Kitton {
  User(super.data);

  Address? get address => nullableModel(
        'address',
        Address.new,
      );
}
```

Usage:

```dart
final user = User({
  'name': 'Christian',
  'address': null,
});

print(user.address); // null
```

---

# Lists of Models

Use `models()` to convert a JSON array into a list of Kitton models.

```dart
class Product extends Kitton {
  Product(super.data);

  int get id => integer('id');

  String get name => string('name');
}
```

```dart
class Cart extends Kitton {
  Cart(super.data);

  List<Product> get products => models(
        'products',
        Product.new,
      );
}
```

Usage:

```dart
final cart = Cart({
  'products': [
    {
      'id': 1,
      'name': 'Keyboard',
    },
    {
      'id': 2,
      'name': 'Mouse',
    },
  ],
});

for (final product in cart.products) {
  print(product.name);
}
```

---

# JSON Serialization

Use `toJson()` to serialize a model.

```dart
final user = User({
  'id': 1,
  'name': 'Christian',
  'active': true,
});

final json = user.toJson();
```

Result:

```json
{
  "id": 1,
  "name": "Christian",
  "active": true
}
```

---

## Recursive Serialization

Kitton automatically serializes nested models.

```dart
final address = Address({
  'city': 'Tuxtla Gutiérrez',
  'country': 'Mexico',
});

final user = User({
  'name': 'Christian',
  'address': address,
});

final json = user.toJson();
```

Result:

```json
{
  "name": "Christian",
  "address": {
    "city": "Tuxtla Gutiérrez",
    "country": "Mexico"
  }
}
```

Kitton recursively serializes:

* Kitton models
* Lists
* Maps
* Nested models
* Lists of models

---

# Request Data

Kitton can also represent data that will be sent to an API.

```dart
class LoginData extends Kitton {
  LoginData({
    required String email,
    required String password,
  }) : super({
          'email': email,
          'password': password,
        });

  String get email => string('email');

  String get password => string('password');
}
```

Usage:

```dart
final login = LoginData(
  email: 'john@example.com',
  password: 'secret',
);

final json = login.toJson();
```

Result:

```json
{
  "email": "john@example.com",
  "password": "secret"
}
```

You can send the serialized map using any HTTP client:

```dart
await dio.post(
  '/login',
  data: login.toJson(),
);
```

Kitton does not depend on a specific HTTP client.

---

# Hidden Fields

Use `hidden` to exclude fields during serialization.

```dart
class User extends Kitton {
  User(super.data);

  String get name => string('name');

  String get email => string('email');

  @override
  List<String> get hidden => [
        'password',
        'token',
      ];
}
```

Usage:

```dart
final user = User({
  'name': 'Christian',
  'email': 'christian@example.com',
  'password': 'secret',
  'token': 'private-token',
});

final json = user.toJson();
```

Result:

```json
{
  "name": "Christian",
  "email": "christian@example.com"
}
```

---

# Visible Fields

Use `visible` to serialize only selected fields.

```dart
class User extends Kitton {
  User(super.data);

  @override
  List<String> get visible => [
        'id',
        'name',
        'email',
      ];
}
```

Usage:

```dart
final user = User({
  'id': 1,
  'name': 'Christian',
  'email': 'christian@example.com',
  'password': 'secret',
  'token': 'private-token',
});

final json = user.toJson();
```

Result:

```json
{
  "id": 1,
  "name": "Christian",
  "email": "christian@example.com"
}
```

---

# Raw Serialization

Use `toRawJson()` to return the original model data without applying `hidden` or `visible` filters.

```dart
final raw = user.toRawJson();
```

This is useful when you need access to all original attributes.

---

# Filtering Attributes

## Only

Use `only()` to select specific fields.

```dart
final data = user.only([
  'id',
  'name',
]);
```

Result:

```json
{
  "id": 1,
  "name": "Christian"
}
```

---

## Except

Use `except()` to exclude specific fields.

```dart
final data = user.except([
  'password',
  'token',
]);
```

---

# Utility Methods

Kitton provides utility methods for working with model attributes.

```dart
user.has('email');

user.missing('password');

user.get('email');

user.attr('email');

user.only([
  'id',
  'name',
]);

user.except([
  'password',
]);

user.fill([
  'id',
  'name',
]);

user.merge({
  'role': 'admin',
});

user.isEmpty;

user.isNotEmpty;
```

---

# Complete Example

```dart
import 'package:kitton/kitton.dart';

class Address extends Kitton {
  Address(super.data);

  String get city => string('city');

  String get country => string('country');
}

class User extends Kitton {
  User(super.data);

  int get id => integer('id');

  String get name => string('name');

  String get email => string('email');

  bool get active => boolean('active');

  Address? get address => nullableModel(
        'address',
        Address.new,
      );

  List<String> get roles => stringList('roles');

  @override
  List<String> get hidden => [
        'password',
        'token',
      ];
}

void main() {
  final user = User({
    'id': '10',
    'name': 'Christian',
    'email': 'christian@example.com',
    'active': 1,
    'roles': [
      'admin',
      'editor',
    ],
    'address': {
      'city': 'Tuxtla Gutiérrez',
      'country': 'Mexico',
    },
    'password': 'secret',
    'token': 'private-token',
  });

  print(user.id);
  print(user.name);
  print(user.active);
  print(user.address?.city);
  print(user.roles);

  print(user.toJson());
}
```

Serialized result:

```json
{
  "id": "10",
  "name": "Christian",
  "email": "christian@example.com",
  "active": 1,
  "roles": [
    "admin",
    "editor"
  ],
  "address": {
    "city": "Tuxtla Gutiérrez",
    "country": "Mexico"
  }
}
```

Typed getters convert values when they are read.

Serialization preserves the original JSON-compatible values stored in the model.

---

# Philosophy

Kitton follows a small set of principles:

* Simple Dart models
* Strongly typed access
* Minimal boilerplate
* Explicit model definitions
* No code generation
* No annotations
* No reflection
* No HTTP client dependency
* No state-management dependency
* No runtime magic

Kitton focuses exclusively on models and JSON serialization.

---

# Current Scope

Kitton currently focuses on:

* Typed model readers
* JSON value conversion
* Nested models
* Model collections
* Recursive serialization
* Attribute filters
* Hidden and visible fields

Kitton does not currently provide:

* HTTP clients
* Dependency injection
* State management
* Local storage
* API authentication
* Form validation
* Database persistence

These responsibilities should remain outside the core package.

---

# Roadmap

Possible future improvements:

* Enum readers
* Strict required readers
* Custom value transformers
* Improved date parsing
* Serialization transformers
* Model equality helpers
* Better parsing exceptions
* Additional collection readers
* More tests and examples

---

# License

Kitton is available under the MIT License.
