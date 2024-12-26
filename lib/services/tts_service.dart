import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:wegame/services/dio_client.dart';
import 'package:wegame/services/pocketbase_service.dart';

class TtsService {
  final Dio _dio = DioClient().dio;
  final PocketBaseService _pocketBaseService = PocketBaseService();

  Future<Uint8List> textToSpeech(String text, String referenceId,
      {double speechRate = 1.0, double volume = 0.5}) async {
    try {
      final apiKeyRecords =
          await _pocketBaseService.pb.collection('keys').getList(
                filter: 'platform = "fishaudio"',
                perPage: 1,
              );
      final apiKey = apiKeyRecords.items.first.getStringValue('api_key');

      final response = await _dio.post(
        'https://api.fish.audio/v1/tts',
        data: {
          'text': text,
          'format': 'mp3',
          'speed': speechRate,
          'volume': volume,
          'reference_id': referenceId,
        },
        options: Options(
          headers: {
            'Authorization': 'Bearer $apiKey',
            'Content-Type': 'application/json',
          },
          responseType: ResponseType.bytes,
        ),
      );
      return response.data;
    } catch (e) {
      if (kDebugMode) {
        print('Error calling TTS API: $e');
      }
      rethrow;
    }
  }
}
