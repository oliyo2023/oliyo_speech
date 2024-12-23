import 'package:flutter/material.dart';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../services/pocketbase_service.dart';

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
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (selectedModel != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16.0),
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.grey.shade600),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      selectedModel.data['name'].toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      selectedModel.data['description']?.toString() ?? '',
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                    if ((selectedModel.data['description']?.toString().length ??
                            0) >
                        40)
                      const Text('...'),
                    const SizedBox(height: 8.0),
                    Row(
                      children: [
                        const Icon(Icons.task, size: 16),
                        Text(selectedModel.data['task_count'].toString()),
                        const SizedBox(width: 16.0),
                        const Icon(Icons.thumb_up, size: 16),
                        Text(selectedModel.data['like_count'].toString()),
                        const SizedBox(width: 16.0),
                        const Icon(Icons.share, size: 16),
                        Text(selectedModel.data['shared_count'].toString()),
                      ],
                    ),
                  ],
                ),
              ),
            const Text('生成的声音将显示在此处'),
            const SizedBox(height: 8.0),
            const Text('还没有结果'),
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
          ],
        ),
      ),
    );
  }
}
