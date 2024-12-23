import 'dart:io';
import 'package:path_provider/path_provider.dart';
import 'package:just_audio/just_audio.dart';
import 'package:wegame/services/tts_service.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:wegame/controllers/model_controller.dart';
import 'package:wegame/services/pocketbase_service.dart';
import 'package:wegame/widgets/conversion_input.dart';
import 'package:wegame/widgets/conversion_results.dart';
import 'package:wegame/widgets/model_list.dart';
import 'package:wegame/widgets/status_bar.dart';
import 'dart:ui' as ui;

final GlobalKey<StatusBarState> statusBarKey = GlobalKey<StatusBarState>();

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
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      win.maximize();
    }
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: '音频转换器',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(),
      home: const AudioConverterScreen(),
    );
  }
}

final windowButtons = [
  MinimizeWindowButton(),
  MaximizeWindowButton(),
  CloseWindowButton(),
];

class AudioConverterScreen extends StatefulWidget {
  const AudioConverterScreen({super.key});

  @override
  State<AudioConverterScreen> createState() => _AudioConverterScreenState();
}

class _AudioConverterScreenState extends State<AudioConverterScreen> {
  final List<String> _conversionResults = [];
  final TextEditingController _textController = TextEditingController();
  dynamic _selectedModel;

  void _onModelSelected(model) {
    setState(() {
      _selectedModel = model;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WindowBorder(
      color: Colors.black,
      width: 1,
      child: Column(
        children: [
          WindowTitleBarBox(
            child: Container(
              decoration: const BoxDecoration(color: Colors.black),
              child: Row(
                children: [
                  Expanded(child: MoveWindow()),
                  ...windowButtons,
                ],
              ),
            ),
          ),
          Expanded(
            child: Scaffold(
              appBar: AppBar(
                title: const Text('音频转换器'),
                backgroundColor: Colors.transparent,
                elevation: 0,
                toolbarHeight: 0,
              ),
              body: Row(
                children: [
                  // Left Column
                  Expanded(
                    child: ModelList(
                      onModelSelected: _onModelSelected,
                    ),
                  ),
                  // Middle Column
                  Expanded(
                    child: ConversionInput(
                      selectedModel: _selectedModel,
                      conversionResults: _conversionResults,
                      textController: _textController,
                      onConvertPressed: _handleConvertPressed,
                    ),
                  ),
                  // Right Column
                  ConversionResults(
                    conversionResults: _conversionResults,
                    selectedModel: _selectedModel,
                  ),
                ],
              ),
              bottomSheet: StatusBar(key: statusBarKey),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleConvertPressed(double speechRate, double volume) async {
    final text = _textController.text;
    if (text.isNotEmpty) {
      try {
        final ttsService = TtsService();
        final response = await ttsService.textToSpeech(text,
            speechRate: speechRate, volume: volume);
        if (response.statusCode == 200) {
          final bytes = response.data;
          final directory = await getApplicationDocumentsDirectory();
          final file = File('${directory.path}/audio.mp3');
          await file.writeAsBytes(bytes);
          final player = AudioPlayer();
          await player.setAudioSource(AudioSource.file(file.path));
          player.play();
        } else {
          Get.snackbar('错误', '无法生成语音');
        }
      } catch (e) {
        Get.snackbar('错误', '发生异常: $e');
      }
    }
  }
}
