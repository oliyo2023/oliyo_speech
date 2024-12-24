import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../services/tts_service.dart';

class ConversionController extends GetxController {
  final TtsService ttsService = TtsService();
  final player = AudioPlayer();

  Future<void> convertTextToSpeech(
      String text, String modelId, double speechRate, double volume) async {
    if (text.isNotEmpty && modelId != null) {
      try {
        final bytes = await ttsService.textToSpeech(
          text,
          modelId,
          speechRate: speechRate,
          volume: volume,
        );
        final directory = await getApplicationDocumentsDirectory();
        databaseFactory = databaseFactoryFfi;
        final file = File('${directory.path}/audio.mp3');
        print(file.path);
        await file.writeAsBytes(bytes);
        await player.setAudioSource(AudioSource.file(file.path));
        player.play();
      } catch (e) {
        Get.snackbar('错误', '发生异常: $e');
      }
    } else {
      Get.snackbar('警告', '请选择模型并输入文本');
    }
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}
