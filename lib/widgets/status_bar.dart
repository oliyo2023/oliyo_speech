import 'package:flutter/material.dart';

class StatusBar extends StatefulWidget {
  const StatusBar({super.key});

  @override
  State<StatusBar> createState() => StatusBarState();
}

class StatusBarState extends State<StatusBar> {
  String _statusMessage = 'Ready';
  bool _isLoading = false;

  void updateStatus(String message, bool isLoading) {
    setState(() {
      _statusMessage = message;
      _isLoading = isLoading;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 24.0,
      color: Colors.grey[850],
      alignment: Alignment.centerRight,
      padding: const EdgeInsets.only(right: 8.0),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (_isLoading)
            const CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              strokeWidth: 2.0,
            ),
          if (_isLoading) const SizedBox(width: 8.0),
          Text('Status: $_statusMessage',
              style: const TextStyle(color: Colors.white)),
        ],
      ),
    );
  }
}
