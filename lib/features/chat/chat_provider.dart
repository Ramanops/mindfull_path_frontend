import 'package:flutter/material.dart';
import '../../core/network/api_client.dart';
import 'chat_model.dart';

class ChatProvider extends ChangeNotifier {
  final ApiClient apiClient = ApiClient();

  List<ChatMessage> messages = [];
  bool isLoading = false;

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    messages.add(ChatMessage(
      role: ChatRole.user,
      content: text,
    ));

    isLoading = true;
    notifyListeners();

    try {
      final response = await apiClient.post(
        '/chat',
        {"message": text},
      );

      messages.add(ChatMessage(
        role: ChatRole.assistant,
        content: response['reply'] ?? '',
      ));
    } catch (e) {
      messages.add(ChatMessage(
        role: ChatRole.assistant,
        content: "Something went wrong. Please try again.",
      ));
    }

    isLoading = false;
    notifyListeners();
  }
}