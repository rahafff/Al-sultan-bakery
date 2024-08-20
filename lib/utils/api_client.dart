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
    "Cookie":"XSRF-TOKEN=eyJpdiI6IkZzeklaRzI1aTZtQTczeHQ5Nk01M0E9PSIsInZhbHVlIjoibitaa1JOaEl0aUxKWUhZZGw0UENya0UvcG52SlBKKzZZeVZKQ010bFc5M1VHUmVoY0IzVFhrbmRmUFVDTmRmY0Q2NUdHaE9BRHgvY0tjRmlkRThSKzFCV3VucDkrU2Y1VTY5Y1paOW94VWlmV3FaN2RuZmhWbE02RnJMSmhsMkciLCJtYWMiOiJlZWM2YzY2MjE5NWMyZWI2MmQ0NmZlMzBjYjA0ODU1NjM2OGMwODZjZjRlZmJiZDlhZDFmMGQ2NDkzOGQ5ZmZhIiwidGFnIjoiIn0%3D; alsultanbakkerij_session=eyJpdiI6IlhMRVNlR0kwM2VRNTJPSUlBYWV3b1E9PSIsInZhbHVlIjoibVI3UnI1cWU2ZDdFT2VmOStMazd6Slp1TDVVZFUrK0oxUDRQa1hmRkZNanROMzVadDF6cTI5YmdUd0VDRDhPRWw3WXVUWldOYUk1R093QndoVy9uQW9OeUw3ZWJRU2RiNlJ6UXQrQ2J2MkVvVzFnWUJWaHc1amo0UnkyTU9HK1EiLCJtYWMiOiIzNjMyZjI3YmUxYjkzZTk4ZmUxYjQ5MGI2ZjIxYjY4NmQyYWY2MGM0MWI2YTMxZGIxNmUyYjVlYjQyOWU1N2I0IiwidGFnIjoiIn0%3D; laravel_maintenance=eyJleHBpcmVzX2F0IjoxNzI0MTM5NTA1LCJtYWMiOiJlMWFkNTdjYzhkNjUzMzQzMGY1MGQ0ZDRjNDQzOTM4NzlhYWUzOTMyNjMzNjMxNDM3NzViZjY1ODgxY2MzMTYyIn0%3D"
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
