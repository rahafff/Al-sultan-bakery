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
    "Cookie":"XSRF-TOKEN=eyJpdiI6ImR0M05NM2gvbUEvNmZoY3N6R05hZ2c9PSIsInZhbHVlIjoienFqWHM1Z1ZPM0dmdThRN0hxdW5GMkYwK2k2UGVrTXQzbXhkM0FIVVI4bHdpSGZzai9LQmozMlpXNERES3o4WjMzazhOYmY2RzEzTkI3OFV5L2RPRlQ4enVGRDBna1ZDMFAzWGZ2ZTNxL21DcmIwUzRob2FFU2FIRER5SWNOUmciLCJtYWMiOiI5MjE4NGNmYTAxN2ZkZGIzMDAwYmQwZWNjOTQ0MGFlZGZmMDE3YzVmMGIzNDM5ZDIzMGI1YjdjZWFkYjRjOWY0IiwidGFnIjoiIn0%3D; alsultanbakkerij_session=eyJpdiI6ImZhNitlRVppNVdDYm5ya1Btd3lGNFE9PSIsInZhbHVlIjoiNjYxeGs5a3M5b091VEFzQVppYzFYS3dMTzNiNUxmVTQrejNYQVo2ZnZUaXlaWWpoa0ZyZ09ad0ZsZkp6NUhjRGhSc0ZOa2dDODlVYVFNQWFQVE4rMEZxelpjZWF2YUZqdmhvelpFTnJmZSsvUXJUSC9malBlUG1tajk4WVFCeWgiLCJtYWMiOiJiYWQwZTJjZjA3OTUzZDc2N2NlMGVmY2E2YmIxZGMxZTYyYWNhMTNjNDdkNDQ3YTcwMDA1ZWJjMjBkODYyNDcyIiwidGFnIjoiIn0%3D; laravel_maintenance=eyJleHBpcmVzX2F0IjoxNzIzNjIyMjUxLCJtYWMiOiIwNmI4OTk5NDg1Yjk5MmZlYzlmYWZiYTdlYmQ0ZTFkYmUxYzMwM2E5OWNkNDNjYTljN2E4ZmRhMDMyMjkyNjA1In0%3D"
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

}

final apiClientProvider = Provider((ref) => ApiClient());
