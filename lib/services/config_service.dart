import 'package:flutter/foundation.dart';

class ConfigService {
  static const String fishAudioApiUrl = 'https://api.fish.audio/v1/tts';
  static const String pocketBaseEndpoint = 'https://pb.example.com';
  static const String pocketBaseEmail = 'oliyo@qq.com';
  static const String pocketBasePassword = 'gemini4094';

  static const Map<String, String> defaultHeaders = {
    'Content-Type': 'application/json',
  };

  static const Duration apiTimeout = Duration(seconds: 30);

  /// 打印调试日志
  ///
  /// @param message 要打印的日志信息
  /// @return void 无返回值
  static void log(String message) {
    if (kDebugMode) {
      print('[ConfigService] $message');
    }
  }
}
