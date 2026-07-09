# Kitton

**Kitton** is a lightweight model layer for Dart and Flutter that simplifies working with REST APIs.

Instead of manually parsing `Map<String, dynamic>` objects, Kitton lets you define strongly typed request and response models using plain Dart.

No code generation.

No annotations.

No reflection.

Just models.

---

## Features

- ✅ Strongly typed models
- ✅ Typed value readers (`string`, `integer`, `boolean`, `date`, etc.)
- ✅ Automatic type coercion
- ✅ Nested model parsing
- ✅ Nullable nested models
- ✅ Collections of models
- ✅ Recursive JSON serialization
- ✅ Hidden & visible serialization
- ✅ Request models
- ✅ Utility helpers
- ✅ Zero code generation

---

# Installation

```yaml
dependencies:
  kitton: ^0.1.0
```

or

```yaml
dependencies:
  kitton:
    path: ../kitton
```

---

# Why Kitton?

Without Kitton:

```dart
final response = await dio.get('/profile');

final name = response.data['name'];
final email = response.data['email'];
final active = response.data['active'];
```

With Kitton:

```dart
final response = await dio.get('/profile');

final user = User(response.data);

print(user.name);
print(user.email);
print(user.active);
```

No manual casting.

No `fromJson()`.

No repetitive code.

---

# Core Concepts

Kitton separates **requests** from **responses**.

```
API Request
      │
      ▼
KittonRequest
      │
      ▼
HTTP Client
      │
      ▼
REST API
      │
      ▼
JSON Response
      │
      ▼
Kitton
```

Use:

- **KittonRequest** for data sent to an API.
- **Kitton** for data received from an API.

---

# Creating Response Models

Response models extend `Kitton`.

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

Usage:

```dart
final response = await dio.get('/profile');

final user = User(response.data);

print(user.name);
```

---

# Creating Request Models

Request models extend `KittonRequest`.

```dart
import 'package:kitton/kitton.dart';

class LoginRequest extends KittonRequest {
  LoginRequest({
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
final request = LoginRequest(
  email: 'john@example.com',
  password: 'secret',
);

await dio.post(
  '/login',
  data: request.toJson(),
);
```

---

## More Request Examples

### Forgot Password

```dart
class ForgotPasswordRequest extends KittonRequest {
  ForgotPasswordRequest({
    required String email,
  }) : super({
          'email': email,
        });

  String get email => string('email');
}
```

Usage:

```dart
final request = ForgotPasswordRequest(
  email: 'john@example.com',
);

await dio.post(
  '/forgot-password',
  data: request.toJson(),
);
```

---

### OTP Verification

```dart
class OtpRequest extends KittonRequest {
  OtpRequest({
    required String email,
    required int otpCode,
  }) : super({
          'email': email,
          'otp_code': otpCode,
        });

  String get email => string('email');

  int get otpCode => integer('otp_code');
}
```

Usage:

```dart
final request = OtpRequest(
  email: 'john@example.com',
  otpCode: 123456,
);

await dio.post(
  '/verify-otp',
  data: request.toJson(),
);
```

---

### Update Profile

```dart
class UpdateProfileRequest extends KittonRequest {
  UpdateProfileRequest({
    required String name,
    required String avatar,
    required String phoneNumber,
    required String dateOfBirth,
  }) : super({
          'name': name,
          'avatar': avatar,
          'phone_number': phoneNumber,
          'date_of_birth': dateOfBirth,
        });

  String get name => string('name');

  String get avatar => string('avatar');

  String get phoneNumber => string('phone_number');

  String get dateOfBirth => string('date_of_birth');
}
```

Usage:

```dart
final request = UpdateProfileRequest(
  name: 'Christian',
  avatar: 'avatar.png',
  phoneNumber: '+521999999999',
  dateOfBirth: '1998-04-15',
);

await dio.post(
  '/profile',
  data: request.toJson(),
);
```

---

# Typed Readers

Kitton provides strongly typed readers with automatic type conversion.

| Method | Returns |
|----------|----------|
| `string()` | String |
| `str()` | String |
| `integer()` | int |
| `intValue()` | int |
| `decimal()` | double |
| `doubleValue()` | double |
| `numValue()` | num |
| `boolean()` | bool |
| `boolValue()` | bool |
| `date()` | DateTime? |
| `dateOr()` | DateTime |
| `map()` | Map<String, dynamic> |
| `list()` | List<dynamic> |
| `stringList()` | List<String> |
| `intList()` | List<int> |

Example:

```dart
class User extends Kitton {
  User(super.data);

  int get age => integer('age');

  bool get verified => boolean('verified');

  DateTime? get birthday => date('birthday');
}
```

---

# Nested Models

### Single Model

```dart
class Order extends Kitton {
  Order(super.data);

  User get customer => model(
    'customer',
    User.new,
  );
}
```

---

### Nullable Model

```dart
User? get customer => nullableModel(
  'customer',
  User.new,
);
```

---

### List of Models

```dart
class Cart extends Kitton {
  Cart(super.data);

  List<Product> get products => models(
    'products',
    Product.new,
  );
}
```

---

# Serialization

Kitton automatically serializes nested objects recursively.

```dart
final json = user.toJson();
```

Nested models:

```dart
class Order extends Kitton {
  Order(super.data);

  User get user => model(
    'user',
    User.new,
  );
}
```

Produces:

```json
{
  "user": {
    "id": 1,
    "name": "John"
  }
}
```

Lists are serialized automatically.

Maps are serialized automatically.

Nested `Kitton` objects are serialized automatically.

---

# Raw Serialization

Return the original model without applying serialization filters.

```dart
final json = user.toRawJson();
```

---

# Hidden Fields

Hide attributes during serialization.

```dart
class User extends Kitton {
  User(super.data);

  @override
  List<String> get hidden => [
    'password',
    'token',
  ];
}
```

```dart
user.toJson();
```

Result:

```json
{
  "id": 1,
  "name": "John"
}
```

---

# Visible Fields

Serialize only selected fields.

```dart
@override
List<String> get visible => [
  'id',
  'name',
  'email',
];
```

---

# Utility Methods

```dart
user.has('email');

user.missing('password');

user.get('email');

user.attr('email');

user.only(['id', 'name']);

user.except(['password']);

user.fill(['id', 'name']);

user.merge({
  'role': 'admin',
});

user.isEmpty;

user.isNotEmpty;
```

---

# Complete Example

```dart
final request = LoginRequest(
  email: 'john@example.com',
  password: 'secret',
);

final response = await dio.post(
  '/login',
  data: request.toJson(),
);

final login = LoginResponse(response.data);

print(login.user.name);
print(login.token);
```

The complete flow looks like this:

```
Developer
      │
      ▼
LoginRequest
      │
      ▼
request.toJson()
      │
      ▼
HTTP Client
      │
      ▼
REST API
      │
      ▼
JSON Response
      │
      ▼
LoginResponse
      │
      ▼
login.user.name
```

---

# Philosophy

Kitton follows a few simple principles.

- Convention over configuration.
- Strong typing.
- Minimal boilerplate.
- Plain Dart models.
- Explicit APIs.
- No runtime magic.
- No code generation.

---

# Roadmap

Upcoming features:

- HTTP Client (`KittonApi`)
- Pagination support
- API Response wrappers
- Enum readers
- Custom transformers
- Validation helpers

---

# License

MIT License.