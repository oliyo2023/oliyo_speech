import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:wegame/services/config_service.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

  factory DioClient() {
    return _instance;
  }

  DioClient._internal() {
    dio = Dio(BaseOptions(
      connectTimeout: ConfigService.apiTimeout,
      receiveTimeout: ConfigService.apiTimeout,
      sendTimeout: ConfigService.apiTimeout,
      headers: ConfigService.defaultHeaders,
    ));

    dio.interceptors.add(InterceptorsWrapper(
      onRequest: (options, handler) {
        if (kDebugMode) {
          ConfigService.log('Request: ${options.method} ${options.uri}');
        }
        return handler.next(options);
      },
      onResponse: (response, handler) {
        if (kDebugMode) {
          ConfigService.log('Response: ${response.statusCode}');
        }
        return handler.next(response);
      },
      onError: (error, handler) {
        if (kDebugMode) {
          ConfigService.log('Error: ${error.message}');
        }
        return handler.next(error);
      },
    ));
  }
}
