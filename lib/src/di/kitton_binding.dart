import 'package:get/get.dart';

import 'kitton_module.dart';

class KittonBinding extends Bindings {
  final List<KittonModule> modules;

  KittonBinding({
    required this.modules,
  });

  @override
  void dependencies() {
    for (final module in modules) {
      module.register();
    }
  }
}