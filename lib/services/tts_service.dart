import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:wegame/services/config_service.dart';
import 'package:wegame/services/dio_client.dart';
import 'package:wegame/services/pocketbase_service.dart';

class TtsRequest {
  final String text;
  final String referenceId;
  final double speechRate;
  final double volume;

  TtsRequest({
    required this.text,
    required this.referenceId,
    this.speechRate = 1.0,
    this.volume = 0.5,
  });

  Map<String, dynamic> toJson() => {
        'text': text,
        'format': 'mp3',
        'speed': speechRate,
        'volume': volume,
        'reference_id': referenceId,
      };
}

class TtsService {
  final Dio _dio = DioClient().dio;
  final PocketBaseService _pocketBaseService = PocketBaseService();
  final Map<String, Uint8List> _audioCache = {};

  /// 将文本转换为语音
  ///
  /// @param request TtsRequest对象，包含要转换的文本和参数
  /// @return Future<Uint8List> 转换后的音频数据
  Future<Uint8List> textToSpeech(TtsRequest request) async {
    final cacheKey = _generateCacheKey(request);
    if (_audioCache.containsKey(cacheKey)) {
      return _audioCache[cacheKey]!;
    }

    try {
      final apiKey = await _pocketBaseService.getApiKeys('fishaudio');

      final response = await _dio.post(
        ConfigService.fishAudioApiUrl,
        data: request.toJson(),
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            ...ConfigService.defaultHeaders,
          },
          responseType: ResponseType.bytes,
        ),
      );

      _audioCache[cacheKey] = response.data;
      return response.data;
    } catch (e) {
      ConfigService.log('Error calling TTS API: $e');
      rethrow;
    }
  }

  /// 生成缓存键
  ///
  /// @param request TtsRequest对象
  /// @return String 缓存键
  String _generateCacheKey(TtsRequest request) {
    return '${request.text}_${request.referenceId}_${request.speechRate}_${request.volume}';
  }

  /// 清除音频缓存
  ///
  /// @return void 无返回值
  void clearCache() {
    _audioCache.clear();
  }
}
