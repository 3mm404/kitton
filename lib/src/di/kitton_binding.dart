import 'package:get/get.dart';

import 'kitton_register.dart';

class KittonBinding extends Bindings {
  final List<KittonRegister> registers;

  KittonBinding({
    required this.registers,
  });

  @override
  void dependencies() {
    for (final register in registers) {
      register.register();
    }
  }
}