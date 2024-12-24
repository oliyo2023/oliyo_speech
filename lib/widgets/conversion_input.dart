import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import '../services/pocketbase_service.dart';

class ConversionInput extends StatefulWidget {
  const ConversionInput({
    super.key,
    required this.selectedModel,
    required this.conversionResults,
    required this.textController,
    required this.onConvertPressed,
  });

  final dynamic selectedModel;
  final List<String> conversionResults;
  final TextEditingController textController;
  final Function(double speechRate, double volume) onConvertPressed;

  @override
  State<ConversionInput> createState() => _ConversionInputState();
}

class _ConversionInputState extends State<ConversionInput> {
  double _speechRate = 1.0;
  double _volume = 0.5;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        children: [
          if (widget.selectedModel != null)
            Container(
              margin: const EdgeInsets.only(bottom: 16.0),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade600),
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        CachedNetworkImage(
                          imageUrl: PocketBaseService()
                              .pb
                              .files
                              .getUrl(widget.selectedModel,
                                  widget.selectedModel.data['avstor'])
                              .toString(),
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                        const SizedBox(width: 8.0),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                widget.selectedModel.data['name'].toString(),
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold),
                              ),
                              Text(
                                widget.selectedModel.data['description']
                                        ?.toString() ??
                                    '',
                                overflow: TextOverflow.ellipsis,
                                maxLines: 1,
                              ),
                              if ((widget.selectedModel.data['description']
                                          ?.toString()
                                          .length ??
                                      0) >
                                  20)
                                const Text(
                                  '...',
                                ),
                              Row(
                                children: [
                                  const Icon(Icons.task, size: 16),
                                  Text(widget.selectedModel.data['task_count']
                                      .toString()),
                                  const SizedBox(width: 30.0),
                                  const Icon(Icons.thumb_up, size: 16),
                                  Text(widget.selectedModel.data['like_count']
                                      .toString()),
                                  const SizedBox(width: 30.0),
                                  const Icon(Icons.share, size: 16),
                                  Text(widget.selectedModel.data['shared_count']
                                      .toString()),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          TextField(
            controller: widget.textController,
            maxLines: 10,
            onChanged: (text) {
              setState(() {});
            },
            decoration: const InputDecoration(
              hintText: '请输入您想生成的语音文本',
              border: OutlineInputBorder(),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Text('${widget.textController.text.length}/2000 汉字'),
          ),
          const SizedBox(height: 16.0),
          const Align(
            alignment: Alignment.topLeft,
            child: Text(
              '高级设置',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            children: [
              Text('语速 (${_speechRate.toStringAsFixed(1)}x)'),
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    _speechRate = (_speechRate - 0.1).clamp(0.1, 2.0);
                  });
                },
              ),
              Expanded(
                child: Slider(
                  value: _speechRate,
                  min: 0.1,
                  max: 2.0,
                  onChanged: (value) {
                    setState(() {
                      _speechRate = value;
                    });
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    _speechRate = (_speechRate + 0.1).clamp(0.1, 2.0);
                  });
                },
              ),
            ],
          ),
          Row(
            children: [
              Text('音量 (${(_volume * 100).toStringAsFixed(0)})'),
              IconButton(
                icon: const Icon(Icons.remove),
                onPressed: () {
                  setState(() {
                    _volume = (_volume - 0.1).clamp(0.0, 1.0);
                  });
                },
              ),
              Expanded(
                child: Slider(
                  value: _volume,
                  min: 0.0,
                  max: 1.0,
                  onChanged: (value) {
                    setState(() {
                      _volume = value;
                    });
                  },
                ),
              ),
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () {
                  setState(() {
                    _volume = (_volume + 0.1).clamp(0.0, 1.0);
                  });
                },
              ),
            ],
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => widget.onConvertPressed(_speechRate, _volume),
            child: const Text('转换为音频'),
          ),
        ],
      ),
    );
  }
}
