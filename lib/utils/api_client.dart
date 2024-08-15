import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocerymart/config/hive_contants.dart';
import 'package:grocerymart/utils/request_handler.dart';

class ApiClient {
  final Dio _dio = Dio(

  );

  ApiClient() {
    addApiInterceptors(_dio);
  }

  Map<String, dynamic> defaultHeaders = {
    HttpHeaders.authorizationHeader: null,
    "lang":"en",
     // HttpHeaders.acceptHeader:'application/json'
    "Cookie":"XSRF-TOKEN=eyJpdiI6InBmMzQycVRZV0JWZFp0ckJtbndOV2c9PSIsInZhbHVlIjoiOEx0WWF4MVZTa0JGcjJ0MGZOMXJ0SnhrWDNVbG8wOXpRQU1IMWhmMGpUNlJMOGFuTUtyamp0SUNCN2l0cmhCV0ZDUkNSQUltUElpRm5NY3RUek9QWEpQclI4Y2xTbXlEZU1QMG9yanpTYzhvOW53RDB6ZVd3U1lXN3F1SzN4OEgiLCJtYWMiOiIwNjY2YmQ3MjE1NTNhZGU3YjM2ZWZlMTMxODFmMGRlZmVhNWJhZDdmMjU0ZTM3N2E2NTBiNmRhZTVkMjE2MWRhIiwidGFnIjoiIn0%3D; alsultanbakkerij_session=eyJpdiI6ImtqVHR2SXFZakVOVTFtanJYbmVzSmc9PSIsInZhbHVlIjoiOFg4aENOMUNtaEk2K1ZDc2ZHdUs1MGpUMDFKaVNNM2ZjN053dXI4ZHlqeXJOcktmMndVTlh4QlZDNzd2RlBncE40d0tkNWVsc0NEWU80cm9pcTA5d2JHdW0rUjA3RklBdTJxbVUvOUlTZzJoKzBSeWFId21xRmthZWloeXJOcGoiLCJtYWMiOiJhN2NlNjE4ZDVjZWU0YjE4ZTM1NGEzZjFkZGFiNGRjZWM5YzY2ZWFhMTYyNTIwZGE0ZDc4MTgxNTVkOTZkOWYwIiwidGFnIjoiIn0%3D; laravel_maintenance=eyJleHBpcmVzX2F0IjoxNzIzODAyNzczLCJtYWMiOiI4MGU4ZDBhMjFiZmY0ZmFiNWRhYmZhYzU0NzE0MDQ0ZjIwMTgzOGRiMWMzYTczYjkzNTk1ZjQ5NmZhNDM4NWU5In0%3D"
  };

  Future<Response> get(String url, {Map<String, dynamic>? query}) async {
    return _dio.get(
      url,
      queryParameters: query,
      options: Options(headers: defaultHeaders,),
    );
  }

  Future<Response> post(
    String url, {
    dynamic data,
    Map<String, dynamic>? headers,
  }) async {
    return _dio.post(
      url,
      data: data,
      options: Options(
        headers: headers ?? defaultHeaders,
        followRedirects: true,
        validateStatus: ((status) {
          return status! < 500;
        }),
      ),
    );
  }

  Future<Response> put(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) async {
    return _dio.put(
      url,
      data: data,
      options: Options(
        headers: headers ?? defaultHeaders,
        followRedirects: false,
        validateStatus: ((status) {
          return status! <= 500;
        }),
      ),
    );
  }

  Future<Response> delete(
    String url, {
    Map<String, dynamic>? data,
    Map<String, dynamic>? headers,
  }) async {
    return _dio.delete(
      url,
      data: data,
      options: Options(
        headers: headers ?? defaultHeaders,
        followRedirects: false,
        validateStatus: ((status) {
          return status! <= 500;
        }),
      ),
    );
  }

  void updateToken({required String token}) {
    defaultHeaders[HttpHeaders.authorizationHeader] = 'Bearer $token';
  }

}

final apiClientProvider = Provider((ref) => ApiClient());
