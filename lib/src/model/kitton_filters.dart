part of 'kitton_base.dart';

extension KittonFilters on Kitton {
  Map<String, dynamic> only(List<String> keys) {
    return {
      for (final key in keys)
        if (data.containsKey(key)) key: data[key],
    };
  }

  Map<String, dynamic> except(List<String> keys) {
    final json = Map<String, dynamic>.from(data);

    for (final key in keys) {
      json.remove(key);
    }

    return json;
  }

  Map<String, dynamic> fill(List<String> fields) {
    return only(fields);
  }

  Map<String, dynamic> merge(Map<String, dynamic> values) {
    return {
      ...data,
      ...values,
    };
  }
}