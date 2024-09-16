import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:grocerymart/config/hive_contants.dart';
import 'package:grocerymart/utils/request_handler.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'dart:ui' as ui;
class ApiClient {
  final Dio _dio = Dio(

  );

  ApiClient() {
    addApiInterceptors(_dio);
  }

  Map<String, dynamic> defaultHeaders = {
    HttpHeaders.authorizationHeader: null,
    "lang":Hive.box(AppHSC.appSettingsBox).get(AppHSC.appLocal) ?? 'en',
    "Cookie":"XSRF-TOKEN=eyJpdiI6IlpyVDNMbXl3Z2o0ZmNWUC9JSkt6SUE9PSIsInZhbHVlIjoiSUsrVk1kbzZpbGhkR1pHVkhzVmlSckFtL2VaWEpPbkdaaEV2bHBERUExd2oyK0JvaG5pU0R3UXI4MDFYOXgreVRRSHhFSjdGekk5cnFhMENYVGdjdkw2QWk1OTlYZ1N2N2QxcDl5NkxaaFdhaGIyYjkrSXNqOFdRdmwvZEExcVoiLCJtYWMiOiIxNTRkOGZlOWU0OGNkYWJkZWY5NDNiODUxNGIzN2RlNDUzOTAxODU0ZDRhNTc2M2E2YjI2NGNiYzU2OTZjMGUxIiwidGFnIjoiIn0%3D; alsultanbakkerij_session=eyJpdiI6Im1PQU9WQVZEQmJ4ZjZXTTJPWFFocWc9PSIsInZhbHVlIjoiWldUSjk2cWZYcEROVHhnSmxpNkdBS2N1UUVnRTcxOWxqbHhYNVQ5WUF3UklUdEgwY0dtRlV4WnlZR3p0YW8rSHRzUlVLaWxTd1FSelQzRENyaExURmZaMCtFYmNFaXg2dmJ0ZFdYUFhqeTVqVGg4dHdraVdXdHJEU0lOeXYxdzUiLCJtYWMiOiIxMTRhNWY3NGI2ZjU2ZjUxNGM5ZmM0MDRlZWUxNWNmNWEzZDMyYWVkNzNmMzRlN2ZjMTg2ZjM1MWE5NTU2OTIwIiwidGFnIjoiIn0%3D; laravel_maintenance=eyJleHBpcmVzX2F0IjoxNzI2NTU4MDM4LCJtYWMiOiI4MzI0YjBiNWNjMmYxM2FkY2E0ZTNiMjdiNGJmNTNlMzEzNjVkMTU5NGU3MmY0ZGE0NjJlNTAzZjAxZTk4ZGRlIn0%3D"
     // HttpHeaders.acceptHeader:'application/json'
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

  void updateLang({required String lan}) {
    defaultHeaders['lang'] = lan;
  }

}

final apiClientProvider = Provider((ref) => ApiClient());
