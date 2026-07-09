part 'kitton_readers.dart';
part 'kitton_relations.dart';
part 'kitton_filters.dart';
part 'kitton_serialization.dart';

abstract class Kitton {
  final Map<String, dynamic> data;

  Kitton(Map<String, dynamic> data) : data = Map<String, dynamic>.from(data);

  List<String> get hidden => const [];

  List<String> get visible => const [];

  dynamic get(String key) => data[key];

  dynamic attr(String key) => get(key);

  bool has(String key) {
    return data.containsKey(key) && data[key] != null;
  }

  bool missing(String key) {
    return !has(key);
  }

  bool get isEmpty => data.isEmpty;

  bool get isNotEmpty => data.isNotEmpty;

  @override
  String toString() {
    return '${runtimeType.toString()}(${toJson()})';
  }
}
