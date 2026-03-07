import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'chat_provider.dart';

class ChatScreen extends ConsumerStatefulWidget {
  const ChatScreen({super.key});

  @override
  ConsumerState<ChatScreen> createState() =>
      _ChatScreenState();
}

class _ChatScreenState
    extends ConsumerState<ChatScreen> {
  final TextEditingController controller =
  TextEditingController();

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(chatProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Mindful Assistant"),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: state.messages.length,
              itemBuilder: (context, index) {
                final msg = state.messages[index];

                return Align(
                  alignment: msg.isUser
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin:
                    const EdgeInsets.symmetric(
                        vertical: 4),
                    padding:
                    const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.isUser
                          ? Colors.blue
                          : Colors.grey[300],
                      borderRadius:
                      BorderRadius.circular(
                          12),
                    ),
                    child: Text(
                      msg.content,
                      style: TextStyle(
                        color: msg.isUser
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),

          if (state.isLoading)
            const Padding(
              padding: EdgeInsets.all(8),
              child:
              CircularProgressIndicator(),
            ),

          Padding(
            padding:
            const EdgeInsets.symmetric(
                horizontal: 8,
                vertical: 4),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller,
                    decoration:
                    const InputDecoration(
                      hintText:
                      "Type your message...",
                      border:
                      OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon:
                  const Icon(Icons.send),
                  onPressed: () {
                    ref
                        .read(chatProvider
                        .notifier)
                        .sendMessage(
                        controller.text);
                    controller.clear();
                  },
                ),
              ],
            ),
          )
        ],
      ),
    );
  }
}