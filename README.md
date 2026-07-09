---

# Request Models

`Kitton` and `KittonRequest` serve different purposes.

While `Kitton` is designed to represent **data received from an API**, `KittonRequest` is intended for **data being sent to an API**.

Keeping requests and responses separate makes your application easier to understand, maintain, and extend.

| Kitton | KittonRequest |
|---------|---------------|
| Represents API responses | Represents API requests |
| Supports serialization filters (`hidden` / `visible`) | Sends the payload exactly as provided |
| Recursively serializes nested models | Returns the raw request payload |
| Optimized for reading data | Optimized for writing data |

---

## Creating a Request

Create a request model by extending `KittonRequest`.

```dart
class LoginRequest extends KittonRequest {
  LoginRequest(super.data);

  String get email => string('email');

  String get password => string('password');
}
```

Create an instance:

```dart
final request = LoginRequest({
  'email': 'john@example.com',
  'password': 'secret',
});
```

Send it with your HTTP client:

```dart
await api.post(
  '/login',
  data: request.toJson(),
);
```

Produces:

```json
{
  "email": "john@example.com",
  "password": "secret"
}
```

---

## Response Models

Responses should extend `Kitton`.

```dart
class LoginResponse extends Kitton {
  LoginResponse(super.data);

  String get token => string('token');

  User get user => model(
    'user',
    User.new,
  );
}
```

Usage:

```dart
final response = await api.post(
  '/login',
  model: LoginResponse.new,
);

print(response.user.name);
```

---

## Serialization Differences

`Kitton` applies serialization rules such as `hidden` and `visible` when calling `toJson()`.

```dart
class User extends Kitton {
  User(super.data);

  @override
  List<String> get hidden => [
    'password',
    'remember_token',
  ];
}
```

```dart
user.toJson();
```

Produces:

```json
{
  "id": 1,
  "name": "John"
}
```

In contrast, `KittonRequest` always returns the original payload.

```dart
abstract class KittonRequest extends Kitton {
  KittonRequest(super.data);

  @override
  Map<String, dynamic> toJson() {
    return data;
  }
}
```

Calling:

```dart
request.toJson();
```

Always returns:

```json
{
  "email": "john@example.com",
  "password": "secret"
}
```

No filtering is applied.

No fields are hidden.

The payload is sent exactly as it was created.

---

## Recommended Usage

```
HTTP Request
        │
        ▼
 LoginRequest (KittonRequest)
        │
        ▼
     API Call
        │
        ▼
 JSON Response
        │
        ▼
 LoginResponse (Kitton)
```

Use **`KittonRequest`** for outgoing data and **`Kitton`** for incoming data. This separation keeps serialization predictable and clearly distinguishes request models from response models.