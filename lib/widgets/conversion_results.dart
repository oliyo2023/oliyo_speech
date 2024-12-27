import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'chat_box.dart';
import 'content_display.dart';
import '../controllers/balance_controller.dart';

class ConversionResults extends StatelessWidget {
  const ConversionResults({
    super.key,
    required this.conversionResults,
    this.selectedModel,
  });

  final List<String> conversionResults;
  final dynamic selectedModel;

  @override
  Widget build(BuildContext context) {
    final balanceController = Get.put(BalanceController());

    return SizedBox(
      width: 300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              flex: 2,
              child: Obx(() => ContentDisplay(
                    content: 'DeepSeek Chat的响应内容将显示在这里',
                    balance: balanceController.isLoading.value
                        ? '加载中...'
                        : balanceController.balance.value,
                  )),
            ),
            SizedBox(height: 16),
            Expanded(
              flex: 1,
              child: ChatBox(
                onSendMessage: (message) async {
                  await balanceController.fetchBalance();
                  // TODO: 调用DeepSeek Chat API
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
