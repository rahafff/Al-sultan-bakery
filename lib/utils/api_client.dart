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
    "Cookie":"XSRF-TOKEN=eyJpdiI6InpGTW5OOTRpVXVQV0lsZ1FBWjlucUE9PSIsInZhbHVlIjoiSDg5UmswRGNNcVJsSVV5TlFQUlI0U1BNWE4wbWJSWmhYMTBoUUwwZ2hDM2JGTzNLNFhJT08rN0NMNVBNZDMxV09WeGdTRlVNaUtMaWw3TTlDanlndzdUczR5REExVTFJNGxlcmprbFFnVlZHVXZwbVBnRzhpTCthakgySUY3c0wiLCJtYWMiOiJmNDMzMjFlY2I4MTlhYzFiZmRjMjZmYWYwYThjMmM0MzRhZTQ3YWYyZTBkOTNmNWE0M2UxNjQ5ZjkxMjVhNTFiIiwidGFnIjoiIn0%3D; alsultanbakkerij_session=eyJpdiI6InBmV09aRUdwTElwem81Y045NW1Zc0E9PSIsInZhbHVlIjoiL05MQVQ5R1cwNG16dXZXVU1JZnMxanA5T0xubTFlaWFJVTBDUGlLNnVjM2xIcnBvWmdGSktTMWo4NUU4bnB3VU5tZHl0N3FFaUp3RmtncWR6N29TVWIwc1FUTlRKaWdCZ01OZ0M4bHcyM3ZJRUJZWFIzaU5IL0VOV2F2UEdKQVQiLCJtYWMiOiIzOTE2Mjk3YTdmMTI3OTFmOGFkMjA5ZWQ4OTllN2JiZTI2Y2YxZmZmMWYxYjk5Mjk5ZDZkZTIxNTZhNmJkNmM0IiwidGFnIjoiIn0%3D; laravel_maintenance=eyJleHBpcmVzX2F0IjoxNzI1MzQxMzEwLCJtYWMiOiJiNWIxMjc3ODBlN2U3M2NhYTQzNmY3ZDMzZTI0MWUyYzViM2I1NzFlNGY4YWIxYTM1NDc5NjllN2Y3ZGNhNDBmIn0%3D"
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
