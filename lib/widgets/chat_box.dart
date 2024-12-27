import 'package:flutter/material.dart';

class ChatBox extends StatefulWidget {
  final Function(String) onSendMessage;

  const ChatBox({super.key, required this.onSendMessage});

  @override
  // ignore: library_private_types_in_public_api
  _ChatBoxState createState() => _ChatBoxState();
}

class _ChatBoxState extends State<ChatBox> {
  final TextEditingController _controller = TextEditingController();
  final List<String> _messages = [];

  void _sendMessage() {
    final message = _controller.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _messages.add('You: $message');
        widget.onSendMessage(message);
        _controller.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          child: ListView.builder(
            itemCount: _messages.length,
            itemBuilder: (context, index) {
              return ListTile(
                title: Text(_messages[index]),
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextField(
                  controller: _controller,
                  decoration: InputDecoration(
                    hintText: '输入消息...',
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: _sendMessage,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
