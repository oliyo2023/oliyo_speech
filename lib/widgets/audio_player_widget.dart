import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';

class AudioPlayerWidget extends StatefulWidget {
  final String audioUrl;

  const AudioPlayerWidget({super.key, required this.audioUrl});

  @override
  // ignore: library_private_types_in_public_api
  _AudioPlayerWidgetState createState() => _AudioPlayerWidgetState();
}

class _AudioPlayerWidgetState extends State<AudioPlayerWidget> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isDownloading = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
    _initAudio();
  }

  Future<void> _initAudio() async {
    await _audioPlayer.setUrl(widget.audioUrl);
  }

  Future<void> _togglePlayPause() async {
    if (_isPlaying) {
      await _audioPlayer.pause();
    } else {
      await _audioPlayer.play();
    }
    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  Future<void> _downloadAudio() async {
    setState(() {
      _isDownloading = true;
    });

    try {
      final dir = await getApplicationDocumentsDirectory();
      final filePath =
          '${dir.path}/${DateTime.now().millisecondsSinceEpoch}.mp3';

      await Dio().download(widget.audioUrl, filePath);

      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('文件已下载到：$filePath')),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('下载失败：$e')),
      );
    } finally {
      setState(() {
        _isDownloading = false;
      });
    }
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _togglePlayPause,
          ),
          IconButton(
            icon: _isDownloading
                ? CircularProgressIndicator()
                : Icon(Icons.download),
            onPressed: _isDownloading ? null : _downloadAudio,
          ),
        ],
      ),
    );
  }
}
