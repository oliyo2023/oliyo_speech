import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:wegame/services/config_service.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();
  late final Dio dio;

  /// DioClient单例工厂构造函数
  ///
  /// @return DioClient实例
  factory DioClient() {
    return _instance;
  }

  /// 初始化DioClient实例，配置Dio选项和拦截器
  ///
  /// @return void 无返回值
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
