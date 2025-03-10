import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'chat_message.dart';

part 'chat.g.dart';

/// Base class for all chat message items
sealed class ChatMessageItem {
  final bool isMe;

  const ChatMessageItem({required this.isMe});
}

/// Represents a typing indicator in the chat
class TypingChatMessageItem extends ChatMessageItem {
  const TypingChatMessageItem() : super(isMe: false);
}

/// Represents a user or AI message in the chat
class UserChatMessageItem extends ChatMessageItem {
  final String message;

  const UserChatMessageItem({required this.message, required super.isMe});
}

/// Service that manages the chat state and message handling
@riverpod
class ChatService extends _$ChatService {
  @override
  Future<List<ChatMessageItem>> build() async {
    return [
      const UserChatMessageItem(
        message: "Hello, how can I help you today?",
        isMe: false,
      ),
    ];
  }

  /// Sends a new message and simulates an AI response
  Future<void> sendMessage(String message) async {
    if (message.isEmpty) return;

    final currentMessages = state.value ?? [];
    state = AsyncData([
      ...currentMessages,
      UserChatMessageItem(message: message, isMe: true),
      const TypingChatMessageItem(),
    ]);

    state = AsyncLoading();
    await Future.delayed(const Duration(seconds: 1));

    state = AsyncData([
      ...currentMessages,
      UserChatMessageItem(message: message, isMe: true),
      const UserChatMessageItem(message: "This is AI response!", isMe: false),
    ]);
  }
}

/// Main chat page widget that displays the chat interface
class ChatPage extends ConsumerStatefulWidget {
  const ChatPage({super.key});

  @override
  ConsumerState<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends ConsumerState<ChatPage> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  Future<void> _scrollToBottom() async {
    if (_scrollController.position.pixels ==
        _scrollController.position.maxScrollExtent) {
      await _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  Future<void> onSendMessage(String message) async {
    final chatData = ref.read(chatServiceProvider);
    if (chatData.isLoading) return;

    _messageController.clear();
    await ref.read(chatServiceProvider.notifier).sendMessage(message);
    await _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final chatData = ref.watch(chatServiceProvider);

    return Scaffold(
      appBar: AppBar(title: const Text("Chat")),
      body: Column(
        children: [
          Expanded(
            child: Stack(
              children: [
                if (chatData.isLoading)
                  const Center(child: CircularProgressIndicator()),
                ListView.builder(
                  controller: _scrollController,
                  itemCount: chatData.value?.length ?? 0,
                  itemBuilder: (context, index) {
                    final messageCached = chatData.value;
                    if (messageCached == null) return const Text("Starting...");

                    final message = messageCached[index];
                    return Row(
                      mainAxisAlignment:
                          message.isMe
                              ? MainAxisAlignment.end
                              : MainAxisAlignment.start,
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: ChatMessage(message: message),
                        ),
                      ],
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10, right: 10, bottom: 24),
            child: Row(
              children: [
                Expanded(
                  child: TextFormField(
                    decoration: const InputDecoration(
                      border: OutlineInputBorder(),
                    ),
                    controller: _messageController,
                    onFieldSubmitted: onSendMessage,
                  ),
                ),
                TextButton(
                  onPressed: () => onSendMessage(_messageController.text),
                  child: const Text("Send"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
