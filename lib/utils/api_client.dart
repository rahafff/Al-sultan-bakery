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
     // HttpHeaders.acceptHeader:'application/json'
// "Cookie":"XSRF-TOKEN=eyJpdiI6IlZMS0Fhd3ZLeUpoY2Y1UVo3VDUzWmc9PSIsInZhbHVlIjoiNmVXbFdYYXNRS25XWVIvbXErcytKV0l3b3cxQ3NqUHk4YzRaaDVtc0sxaUR3YmJnSUFMSmRoQ1VHL3dvN3BiWS9iWWFtWVhtUUgzcTI1Wjhoc0JZTHJXMkJZd3owVGE2ZWcyR3lSQUxIUTRFb2ZVaHJKZVdjVVpLOTBBYjhTRlMiLCJtYWMiOiI4YjQ2NGYyNzBmODliY2JjM2JiMmY4ZmY2OTZmMTQ4NDQwNzI2MDM1NmQ2Y2Y2NmFiMWU3NmI5ZjM3YWYyZjVhIiwidGFnIjoiIn0%3D; alsultanbakkerij_session=eyJpdiI6IjN0RE9mWTBTUk1yL2crTlFDS0Jnb3c9PSIsInZhbHVlIjoiODdDbWFzVm1OM01LQmxlYklqcUg4ZWRhTmhpUmFuU3ZBZSt3QnFUTG5yWGtWQ1FPL2FKRDFYckdQaVh0ZzhDOVJybnBRajFQcVU2QnFtV3hmNCtyS3g4TDNxMk9aYTdZMzBGQUxQL0N1M1ZIU2QyY29lT1ZYSEQwRnl0STZMdVgiLCJtYWMiOiJmMjgzOTM3MWZmN2QxZmRmMWVmY2YxN2JkMmRhNDM2Yjk4YmIxNjgxOGZjYWI5YTU5YWExZGIxYjlkYWEyODQwIiwidGFnIjoiIn0%3D; laravel_maintenance=eyJleHBpcmVzX2F0IjoxNzI2ODU2ODgyLCJtYWMiOiJkN2NmY2VhNjQ5YmMxMzdiY2Y0YjYzYzQ1MDcxYzcyM2I1OTJlYmE0Zjg2OGY5NWIwZTQzNDg0N2ZhMzk1MzVmIn0%3D"
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
