import 'package:flutter/material.dart';

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
    return SizedBox(
      width: 300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('生成的声音将显示在此处'),
            const SizedBox(height: 8.0),
            const Text(
              '还没有结果',
              style: TextStyle(color: Colors.blueGrey),
            ),
            Expanded(
              child: ListView.separated(
                itemCount: conversionResults.length,
                separatorBuilder: (context, index) => const Divider(),
                itemBuilder: (context, index) {
                  return ListTile(
                    title: Text('转换结果: ${conversionResults[index]}'),
                    trailing: IconButton(
                      icon: const Icon(Icons.play_arrow),
                      onPressed: () {
                        // TODO: Implement audio playback
                      },
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 16.0),
            TextField(
              decoration: InputDecoration(
                border: const OutlineInputBorder(),
                hintText: '输入你的消息...',
              ),
            ),
          ],
        ),
      ),
    );
  }
}
