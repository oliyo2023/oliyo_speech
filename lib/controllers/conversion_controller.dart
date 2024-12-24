import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../services/tts_service.dart';
import '../services/pocketbase_service.dart';
// ignore: depend_on_referenced_packages
import 'package:http/http.dart' as http;
import 'dart:async';

class ConversionController extends GetxController {
  final TtsService ttsService = TtsService();
  final player = AudioPlayer();
  final PocketBaseService pocketBaseService = PocketBaseService();

  Future<void> convertTextToSpeech(
      String text, String modelId, double speechRate, double volume) async {
    if (text.isNotEmpty && modelId.isNotEmpty) {
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
        // await player.setAudioSource(AudioSource.file(file.path));
        // player.play();
        await uploadAudio(text, file, modelId);
      } catch (e) {
        Get.snackbar('错误', '发生异常: $e');
      }
    } else {
      Get.snackbar('警告', '请选择模型并输入文本');
    }
  }

  Future<void> uploadAudio(
      String content, File audioFile, String modelId) async {
    try {
      final audioFileForUpload = http.MultipartFile.fromBytes(
        'audio_file',
        await audioFile.readAsBytes(),
        filename: 'audio.mp3',
      );
      final record =
          await pocketBaseService.pb.collection('audio_record').create(
        body: {
          'content': content,
          'model_id': modelId,
        },
        files: [audioFileForUpload],
      );
      Get.snackbar('成功', '音频已上传到PocketBase');
      audioFile.delete();
    } catch (e) {
      Get.snackbar('错误', '上传音频失败: $e');
    }
  }

  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}
