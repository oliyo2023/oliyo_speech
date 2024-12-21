import 'package:flutter/material.dart';

class ConversionInput extends StatelessWidget {
  const ConversionInput({
    super.key,
    required this.conversionResults,
    required this.textController,
    required this.onConvertPressed,
  });

  final List<String> conversionResults;
  final TextEditingController textController;
  final VoidCallback onConvertPressed;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          TextField(
            controller: textController,
            maxLines: 5,
            decoration: const InputDecoration(
              hintText: '请输入要转换的文本',
              border: OutlineInputBorder(),
            ),
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: onConvertPressed,
            child: const Text('转换为音频'),
          ),
        ],
      ),
    );
  }
}
