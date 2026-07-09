import 'package:kitton/kitton.dart';

abstract class KittonRequest extends Kitton {
  KittonRequest(super.data);

  Map<String, dynamic> toJson() {
    return data;
  }
}
