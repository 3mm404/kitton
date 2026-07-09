# Kitton

Kitton es una capa de modelos ligera y expresiva para Dart y Flutter que facilita el trabajo con APIs JSON.

Con Kitton ya no necesitas parsear manualmente `Map<String, dynamic>` en toda tu aplicación. Solo defines modelos con getters tipados y Kitton se encarga de la lectura y la serialización.

---

## ¿Por qué Kitton?

Cuando consumes APIs REST, a menudo terminas con código repetitivo como:

```dart
factory User.fromJson(Map<String, dynamic> json) {
  return User(
    id: json['id'],
    email: json['email'],
  );
}
```

o con constantes conversiones de tipos:

```dart
final id = json['id'] as int;
final email = json['email'] as String;
```

Kitton elimina ese boilerplate.

---

## Características

- ✅ Lectores tipados para propiedades
- ✅ Coerción automática de valores
- ✅ Modelos anidados
- ✅ Modelos nulos
- ✅ Colecciones de modelos
- ✅ Serialización JSON recursiva
- ✅ Atributos ocultos y visibles
- ✅ API inspirada en Laravel Eloquent
- ✅ Helpers de utilidad
- ✅ Sin generación de código
- ✅ Sin reflexión
- ✅ Ligero y sin dependencias externas

---

## Instalación

```yaml
dependencies:
  kitton: ^0.1.0
```

O si trabajas localmente:

```yaml
dependencies:
  kitton:
    path: ../kitton
```

---

## Uso rápido

```dart
class User extends Kitton {
  User(super.data);

  int get id => integer('id');
  String get name => string('name');
  String get email => string('email');
  bool get active => boolean('active');
}

final user = User({
  'id': '1',
  'name': 'Christian',
  'email': 'test@mail.com',
  'active': 'yes',
});

print(user.id);      // 1
print(user.name);    // Christian
print(user.email);   // test@mail.com
print(user.active);  // true
```

Kitton convierte valores siempre que es posible.

---

## Lectores tipados

Kitton ofrece lectores que manejan de forma segura:

- `null`
- valores incorrectos
- conversiones automáticas
- valores de respaldo opcionales

| Lector | Retorno |
|--------|---------|
| `string()` | `String` |
| `str()` | `String` |
| `integer()` | `int` |
| `intValue()` | `int` |
| `decimal()` | `double` |
| `doubleValue()` | `double` |
| `numValue()` | `num` |
| `boolean()` | `bool` |
| `boolValue()` | `bool` |
| `date()` | `DateTime?` |
| `dateOr()` | `DateTime` |
| `map()` | `Map<String, dynamic>` |
| `list()` | `List<dynamic>` |
| `stringList()` | `List<String>` |
| `intList()` | `List<int>` |

```dart
int get age => integer('age');
bool get verified => boolean('verified');
DateTime? get birthday => date('birthday');
```

---

## Modelos anidados

Kitton hace que los objetos anidados sean sencillos.

### Modelo simple

```dart
class Order extends Kitton {
  Order(super.data);

  User get customer => model(
    'customer',
    User.new,
  );
}
```

```json
{
  "customer": {
    "id": 1,
    "name": "John"
  }
}
```

```dart
order.customer.name;
```

### Modelo nullable

```dart
User? get customer => nullableModel(
  'customer',
  User.new,
);
```

### Lista de modelos

```dart
class Cart extends Kitton {
  Cart(super.data);

  List<Product> get products => models(
    'products',
    Product.new,
  );
}

cart.products.first.name;
```

---

## Serialización

Kitton serializa recursivamente modelos, listas y mapas.

```dart
final user = User(data);
user.toJson();
```

Resultado:

```json
{
  "id": 1,
  "name": "Christian"
}
```

### Serialización recursiva

```dart
class Order extends Kitton {
  Order(super.data);

  User get user => model(
    'user',
    User.new,
  );
}

order.toJson();
```

Produce:

```json
{
  "user": {
    "id": 1,
    "name": "John"
  }
}
```

### Listas de modelos

```json
{
  "items": [
    Product(...),
    Product(...)
  ]
}
```

Se convierte en:

```json
{
  "items": [
    { "id": 1 },
    { "id": 2 }
  ]
}
```

### Mapas anidados

```json
{
  "settings": {
    "user": User(...)
  }
}
```

Se convierte en:

```json
{
  "settings": {
    "user": {
      "id": 1
    }
  }
}
```

---

## Atributos ocultos y visibles

### Hidden

Oculta atributos sensibles durante la serialización.

```dart
class User extends Kitton {
  User(super.data);

  @override
  List<String> get hidden => [
    'password',
    'remember_token',
    'api_token',
  ];
}
```

Salida de `toJson()`:

```json
{
  "id": 1,
  "email": "john@mail.com"
}
```

### Visible

Selecciona únicamente los campos que se serializan.

```dart
@override
List<String> get visible => [
  'id',
  'name',
  'email',
];
```

Todo lo demás se ignora.

### Serialización cruda

```dart
user.toRawJson();
```

`toRawJson()` devuelve los datos originales sin aplicar `hidden` ni `visible`.

---

## Comportamiento de serialización

Kitton maneja de forma recursiva:

- valores primitivos: `String`, `int`, `double`, `num`, `bool`, `DateTime`, `null`
- modelos Kitton anidados
- listas de modelos
- mapas con valores mixtos

---

## Métodos útiles

```dart
user.has('email');
user.missing('password');
user.get('email');
user.attr('email');
user.isEmpty;
user.isNotEmpty;
```

### Helpers de campos

```dart
user.only(['id', 'name']);
user.except(['password']);
user.fill(['id', 'name']);
user.merge({'role': 'admin'});
```

---

## Filosofía

Kitton sigue principios claros:

- Convención sobre configuración
- Tipado fuerte
- Menos boilerplate
- API explícita
- Sin reflexión
- Sin magia de runtime

---

## Roadmap

Próximas características planeadas:

- Modelos de request (`KittonRequest`)
- Integración HTTP (`KittonApi`)
- Wrappers de respuesta API
- Helpers de paginación
- Lectores para enums
- Transformadores personalizados
- Validaciones
- Soporte para modelos inmutables

---

## Licencia

MIT License
