import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

/// Logging Interceptor for debugging API calls
class LoggingInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (kDebugMode) {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print('🚀 REQUEST[${options.method}] => PATH: ${options.path}');
      print('Headers: ${options.headers}');
      print('Query Parameters: ${options.queryParameters}');
      print('Data: ${options.data}');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    if (kDebugMode) {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print(
          '✅ RESPONSE[${response.statusCode}] => PATH: ${response.requestOptions.path}');
      print('Data: ${response.data}');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (kDebugMode) {
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
      print(
          '❌ ERROR[${err.response?.statusCode}] => PATH: ${err.requestOptions.path}');
      print('Error Type: ${err.type}');
      print('Error Message: ${err.message}');
      print('Error Response: ${err.response?.data}');
      print('━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━');
    }
    super.onError(err, handler);
  }
}
