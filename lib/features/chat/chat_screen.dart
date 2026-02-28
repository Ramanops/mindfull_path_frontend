import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'chat_provider.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatProvider>();

    return Scaffold(
      appBar: AppBar(title: Text("Mindful Assistant")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: provider.messages.length,
              itemBuilder: (context, index) {
                final msg = provider.messages[index];

                return Align(
                  alignment: msg.role == 'user'
                      ? Alignment.centerRight
                      : Alignment.centerLeft,
                  child: Container(
                    margin: EdgeInsets.all(8),
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: msg.role == 'user'
                          ? Colors.blue
                          : Colors.grey[300],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text(
                      msg.content,
                      style: TextStyle(
                        color: msg.role == 'user'
                            ? Colors.white
                            : Colors.black,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          if (provider.isLoading) CircularProgressIndicator(),
          Row(
            children: [
              Expanded(
                child: TextField(
                  controller: controller,
                ),
              ),
              IconButton(
                icon: Icon(Icons.send),
                onPressed: () {
                  provider.sendMessage(controller.text);
                  controller.clear();
                },
              )
            ],
          )
        ],
      ),
    );
  }
}