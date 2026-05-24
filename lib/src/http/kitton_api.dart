import 'package:dio/dio.dart';

import '../model/kitton_base.dart';
import 'kitton_exception.dart';
import 'kitton_response.dart';

class KittonApi {
  final Dio client;

  KittonApi(this.client);

  Future<T> get<T extends Kitton>(
    String path, {
    Map<String, dynamic>? queryParameters,
    required T Function(Map<String, dynamic>) model,
  }) async {
    try {
      final response = await client.get(
        path,
        queryParameters: queryParameters,
      );

      final body = KittonResponse(response.data).body;

      return model(body);
    } catch (error) {
      throw KittonException.from(error);
    }
  }

  Future<T> post<T extends Kitton>(
    String path, {
    Map<String, dynamic>? data,
    required T Function(Map<String, dynamic>) model,
  }) async {
    try {
      final response = await client.post(
        path,
        data: data,
      );

      final body = KittonResponse(response.data).body;

      return model(body);
    } catch (error) {
      throw KittonException.from(error);
    }
  }

  Future<void> postVoid(
    String path, {
    Map<String, dynamic>? data,
  }) async {
    try {
      await client.post(
        path,
        data: data,
      );
    } catch (error) {
      throw KittonException.from(error);
    }
  }
}