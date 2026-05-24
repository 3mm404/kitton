import 'package:kitton/kitton.dart';
import 'package:test/test.dart';

class User extends Kitton {
  User(super.data);

  int get id => intValue('id');
  String get name => string('name');
  String get email => string('email');
  bool get active => boolValue('active');

  Wallet get wallet => model<Wallet>('wallet', Wallet.new);
  List<Address> get addresses => models<Address>('addresses', Address.new);

  bool get hasMoney => wallet.balance > 0;
}

class Wallet extends Kitton {
  Wallet(super.data);

  num get balance => numValue('balance');
  num get reserved => numValue('reserved');
}

class Address extends Kitton {
  Address(super.data);

  String get city => string('city');
  String get country => string('country');
}

class SafeUser extends Kitton {
  SafeUser(super.data);

  @override
  List<String> get hidden => ['password', 'token'];
}

void main() {
  test('Kitton can read a complete API user response', () {
    final user = User({
      'id': '1',
      'name': 'Christian',
      'email': 'christian@mail.com',
      'active': 1,
      'wallet': {
        'balance': '250.50',
        'reserved': 40,
      },
      'addresses': [
        {
          'city': 'Playa del Carmen',
          'country': 'Mexico',
        },
        {
          'city': 'Cancun',
          'country': 'Mexico',
        },
      ],
    });

    print('');
    print('──── Kitton User Example ────');
    print('ID: ${user.id}');
    print('Name: ${user.name}');
    print('Email: ${user.email}');
    print('Active: ${user.active}');
    print('Wallet balance: \$${user.wallet.balance}');
    print('Wallet reserved: \$${user.wallet.reserved}');
    print('Has money: ${user.hasMoney}');
    print('Main city: ${user.addresses.first.city}');
    print('Total addresses: ${user.addresses.length}');
    print('JSON: ${user.toJson()}');
    print('─────────────────────────────');
    print('');

    expect(user.id, 1);
    expect(user.name, 'Christian');
    expect(user.active, true);
    expect(user.wallet.balance, 250.50);
    expect(user.addresses.length, 2);
    expect(user.addresses.first.city, 'Playa del Carmen');
  });

  test('Kitton hides sensitive fields from JSON', () {
    final user = SafeUser({
      'name': 'Christian',
      'email': 'christian@mail.com',
      'password': 'secret',
      'token': 'abc123',
    });

    print('');
    print('──── Kitton Hidden Fields Example ────');
    print(user.toJson());
    print('──────────────────────────────────────');
    print('');

    expect(user.toJson(), {
      'name': 'Christian',
      'email': 'christian@mail.com',
    });
  });

  test('Kitton can filter request data', () {
    final user = User({
      'name': 'Christian',
      'email': 'christian@mail.com',
      'password': 'secret',
      'active': true,
    });

    final loginData = user.only(['email', 'password']);

    print('');
    print('──── Kitton Request Data Example ────');
    print(loginData);
    print('─────────────────────────────────────');
    print('');

    expect(loginData, {
      'email': 'christian@mail.com',
      'password': 'secret',
    });
  });
}

