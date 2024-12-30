import 'package:flutter/foundation.dart';
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

  /// 将文本转换为语音
  /// 
  /// @param request TtsRequest对象，包含要转换的文本和参考ID
  /// @return Future<void> 无返回值
  Future<void> convertTextToSpeech(TtsRequest request) async {
    if (request.text.isNotEmpty && request.referenceId.isNotEmpty) {
      try {
        final bytes = await ttsService.textToSpeech(request);
        final directory = await getApplicationDocumentsDirectory();
        databaseFactory = databaseFactoryFfi;
        final file = File('${directory.path}/audio.mp3');
        if (kDebugMode) {
          print(file.path);
        }
        await file.writeAsBytes(bytes);
        // await player.setAudioSource(AudioSource.file(file.path));
        // player.play();
        await uploadAudio(request.text, file, request.referenceId);
      } catch (e) {
        Get.snackbar('错误', '发生异常: $e');
      }
    } else {
      Get.snackbar('警告', '请选择模型并输入文本');
    }
  }

  /// 上传音频文件到PocketBase
  ///
  /// @param content 音频对应的文本内容
  /// @param audioFile 要上传的音频文件
  /// @param modelId 使用的模型ID
  /// @return Future<void> 无返回值
  Future<void> uploadAudio(
      String content, File audioFile, String modelId) async {
    try {
      final audioFileForUpload = http.MultipartFile.fromBytes(
        'audio_file',
        await audioFile.readAsBytes(),
        filename: 'audio.mp3',
      );
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

  /// 关闭控制器时释放资源
  ///
  /// @return void 无返回值
  @override
  void onClose() {
    player.dispose();
    super.onClose();
  }
}
