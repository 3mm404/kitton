import 'package:get/get.dart';

abstract class KittonRegister {
  T find<T>() => Get.find<T>();

  void bind<T>(T Function() builder) {
    if (!Get.isRegistered<T>()) {
      Get.lazyPut<T>(
        builder,
        fenix: true,
      );
    }
  }

  void keep<T>(T dependency) {
    if (!Get.isRegistered<T>()) {
      Get.put<T>(
        dependency,
        permanent: true,
      );
    }
  }

  void register();
}