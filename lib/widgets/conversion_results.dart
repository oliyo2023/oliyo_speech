import 'package:flutter/material.dart';

class ConversionResults extends StatelessWidget {
  const ConversionResults({
    super.key,
    required this.conversionResults,
  });

  final List<String> conversionResults;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 300,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
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
    );
  }
}
