import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:io';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../services/tts_service.dart';
import '../widgets/conversion_input.dart';
import '../widgets/model_list.dart';
import '../controllers/model_controller.dart';
import 'package:bitsdojo_window/bitsdojo_window.dart';

void main() {
  Get.put(ModelController());
  runApp(const MyApp());
  doWhenWindowReady(() {
    final win = appWindow;
    const initialSize = Size(1280, 720);
    win.minSize = initialSize;
    win.size = initialSize;
    win.alignment = Alignment.center;
    win.title = "Wegame";
    win.show();
  });
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'wegame',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        brightness: Brightness.dark,
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  dynamic _selectedModel;
  final _textController = TextEditingController();
  final List<String> _conversionResults = [];
  late final AudioPlayer _player;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
  }

  @override
  void dispose() {
    _textController.dispose();
    _player.dispose();
    super.dispose();
  }

  Future<void> _handleConvertPressed(double speechRate, double volume) async {
    final text = _textController.text;
    final modelId = _selectedModel?.data['model_id'].toString();

    if (text.isNotEmpty && modelId != null) {
      // try {
      final ttsService = TtsService();
      final response = await ttsService.textToSpeech(
        text,
        modelId,
        speechRate: speechRate,
        volume: volume,
      );
      final bytes = response;
      final directory = await getApplicationDocumentsDirectory();
      databaseFactory = databaseFactoryFfi;
      final file = File('${directory.path}/audio.mp3');
      print(file.path);
      await file.writeAsBytes(bytes);
      await _player.setAudioSource(AudioSource.file(file.path));
      _player.play();
    } else {
      Get.snackbar('警告', '请选择模型并输入文本');
    }
  }

  void _handleModelSelected(model) {
    setState(() {
      _selectedModel = model;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(30),
        child: WindowTitleBarBox(
          child: Row(
            children: [
              Expanded(child: MoveWindow()),
              const WindowButtons(),
            ],
          ),
        ),
      ),
      body: Row(
        children: [
          Expanded(
            child: ModelList(onModelSelected: _handleModelSelected),
          ),
          Expanded(
            child: ConversionInput(
              selectedModel: _selectedModel,
              conversionResults: _conversionResults,
              textController: _textController,
              onConvertPressed: _handleConvertPressed,
            ),
          ),
        ],
      ),
    );
  }
}

class WindowButtons extends StatelessWidget {
  const WindowButtons({super.key});
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        MinimizeWindowButton(),
        MaximizeWindowButton(),
        CloseWindowButton(),
      ],
    );
  }
}
