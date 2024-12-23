import 'package:dio/dio.dart';
import 'package:wegame/services/dio_client.dart';
import 'package:wegame/services/pocketbase_service.dart';

class TtsService {
  final Dio _dio = DioClient().dio;

  Future<Response> textToSpeech(String text,
      {double speechRate = 1.0, double volume = 0.5}) async {
    final apiKey = await _getApiKey();
    try {
      final response = await _dio.post(
        'https://api.fish.audio/v1/tts',
        options: Options(
          headers: {'Authorization': 'Bearer $apiKey'},
          contentType: 'application/json',
        ),
        data: {
          'text': text,
          'format': 'mp3',
          'speed': speechRate,
          'volume': volume
        },
      );
      return response;
    } catch (e) {
      print('Error calling TTS API: $e');
      rethrow;
    }
  }

  Future<String> _getApiKey() async {
    final pocketBaseService = await PocketBaseService.getInstance();
    final records = await pocketBaseService.pb
        .collection('keys')
        .getList(filter: 'platform = "fishaudio"', perPage: 1, skipTotal: true);
    if (records.items.isNotEmpty) {
      final apiKeyRecord = records.items.first;
      return apiKeyRecord.data['api_key'];
    } else {
      throw Exception('No API key found');
    }
  }
}
