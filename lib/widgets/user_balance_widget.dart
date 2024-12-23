import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/user_controller.dart';
import '../services/tts_service.dart';
import 'package:just_audio/just_audio.dart';

class UserBalanceWidget extends StatelessWidget {
  UserBalanceWidget({super.key});

  final UserController userController = Get.put(UserController());
  final TtsService ttsService = TtsService();
  final AudioPlayer player = AudioPlayer();

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            '用户余额: \$${userController.balance.toStringAsFixed(6)}',
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          ElevatedButton(
            onPressed: userController.fetchBalance,
            child: const Text('刷新'),
          ),
          ElevatedButton(
            onPressed: () async {
              final balanceText =
                  '用户余额是 \$${userController.balance.toStringAsFixed(2)}';
              try {
                final response = await ttsService.textToSpeech(balanceText);
                if (response.statusCode == 200) {
                  final bytes = response.data;
                  await player.setAudioSource(
                      AudioSource.uri(Uri.dataFromBytes(bytes)));
                  player.play();
                } else {
                  Get.snackbar('错误', '无法生成语音');
                }
              } catch (e) {
                Get.snackbar('错误', '发生异常: $e');
              }
            },
            child: const Icon(Icons.speaker_phone),
          ),
        ],
      ),
    );
  }
}
