import 'package:flutter/material.dart';

class MessageBubble extends StatelessWidget {
  final String message;
  final String time;
  final bool isMe;

  const MessageBubble({
    super.key,
    required this.message,
    required this.time,
    required this.isMe,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4, horizontal: 8),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isMe ? const Color(0xFFDCF8C6) : const Color(0xFFffffff),
          borderRadius: BorderRadius.circular(12),
        ),
        child: RichText(
          text: TextSpan(
            style: const TextStyle(fontSize: 16, color: Colors.black),
            children: [
              TextSpan(text: "$message "),
              WidgetSpan(
                child: SizedBox(width: 4), // Small space between text and time
              ),
              WidgetSpan(
                alignment: PlaceholderAlignment.bottom,
                child: Text(
                  time,
                  style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
