import 'package:flutter/material.dart';
import 'chat.dart';

/// Widget that displays a chat message with appropriate styling
class ChatMessage extends StatelessWidget {
  const ChatMessage({super.key, required this.message});

  final ChatMessageItem message;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        children: [
          Align(
            alignment:
                message.isMe ? Alignment.centerRight : Alignment.centerLeft,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: message.isMe ? Colors.blue[100] : Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (message is UserChatMessageItem) ...[
                    Icon(message.isMe ? Icons.person : Icons.assistant),
                    const SizedBox(width: 10),
                    Text((message as UserChatMessageItem).message),
                  ] else
                    const Text("..."),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
