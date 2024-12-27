import 'package:flutter/material.dart';

class ContentDisplay extends StatelessWidget {
  final String content;
  final String? balance;

  const ContentDisplay({Key? key, required this.content, this.balance})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(8),
      ),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (balance != null)
              Padding(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Text(
                  '账户余额: $balance',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.blue,
                  ),
                ),
              ),
            Text(
              content,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
      ),
    );
  }
}
