import 'package:bitsdojo_window/bitsdojo_window.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/conversion_controller.dart';
import '../controllers/model_controller.dart';
import '../services/tts_service.dart';
import '../widgets/conversion_input.dart';
import '../widgets/conversion_results.dart';
import '../widgets/model_list.dart';

class WindowConfig {
  static const Size initialSize = Size(1280, 720);
  static const String title = "Wegame";

  static void configureWindow() {
    doWhenWindowReady(() {
      final win = appWindow;
      win.minSize = initialSize;
      win.size = initialSize;
      win.alignment = Alignment.center;
      win.title = title;
      win.show();
    });
  }
}

void main() {
  Get.put(ModelController());
  Get.put(ConversionController());
  runApp(const MyApp());
  WindowConfig.configureWindow();
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
  final TextEditingController _textController = TextEditingController();
  final List<String> _conversionResults = [];
  final ConversionController _conversionController = Get.find();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _handleConvertPressed() async {
    final text = _textController.text;
    final modelId = _selectedModel?.data['model_id'].toString();
    final request = TtsRequest(
      text: text,
      referenceId: modelId!,
      speechRate: _speechRate,
      volume: _volume,
    );
    await _conversionController.convertTextToSpeech(request);
  }

  final double _speechRate = 1.0;
  final double _volume = 0.5;

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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ModelList(onModelSelected: _handleModelSelected),
          ),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                ConversionInput(
                  selectedModel: _selectedModel,
                  conversionResults: _conversionResults,
                  textController: _textController,
                  onConvertPressed: _handleConvertPressed,
                ),
              ],
            ),
          ),
          ConversionResults(
            conversionResults: _conversionResults,
            selectedModel: _selectedModel,
          )
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
