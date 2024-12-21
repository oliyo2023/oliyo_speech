import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wegame/controllers/model_controller.dart';
import 'package:wegame/services/pocketbase_service.dart';
import 'package:wegame/widgets/conversion_input.dart';
import 'package:wegame/widgets/conversion_results.dart';
import 'package:wegame/widgets/model_list.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PocketBaseService.getInstance();
  Get.put(ModelController());
  runApp(const MyApp());
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(800, 600);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = '音频转换器';
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      // Use GetMaterialApp for GetX features
      title: '音频转换器',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: AudioConverterScreen(),
    );
  }
}

class AudioConverterScreen extends StatefulWidget {
  const AudioConverterScreen({super.key});

  @override
  State<AudioConverterScreen> createState() => _AudioConverterScreenState();
}

class _AudioConverterScreenState extends State<AudioConverterScreen> {
  final List<String> _conversionResults = [];
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('音频转换器'),
      ),
      body: Row(
        children: [
          // Left Column
          Expanded(child: ModelList()),
          // Middle Column
          Expanded(
            child: ConversionInput(
              conversionResults: _conversionResults,
              textController: _textController,
              onConvertPressed: () {
                setState(() {
                  _conversionResults.add(_textController.text);
                  _textController.clear();
                });
              },
            ),
          ),
          // Right Column
          ConversionResults(conversionResults: _conversionResults),
        ],
      ),
    );
  }
}
