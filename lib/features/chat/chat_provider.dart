import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/network/api_client.dart';
import 'chat_model.dart';

/// Provider
final chatProvider =
StateNotifierProvider<ChatNotifier, ChatState>(
      (ref) => ChatNotifier(),
);

/// State Model
class ChatState {
  final List<ChatMessage> messages;
  final bool isLoading;

  ChatState({
    required this.messages,
    required this.isLoading,
  });

  ChatState copyWith({
    List<ChatMessage>? messages,
    bool? isLoading,
  }) {
    return ChatState(
      messages: messages ?? this.messages,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

/// Notifier
class ChatNotifier extends StateNotifier<ChatState> {
  ChatNotifier()
      : super(ChatState(
    messages: [],
    isLoading: false,
  ));

  final ApiClient apiClient = ApiClient();

  Future<void> sendMessage(String text) async {
    if (text.trim().isEmpty) return;

    // Add user message
    state = state.copyWith(
      messages: [
        ...state.messages,
        ChatMessage(
          role: ChatRole.user,
          content: text,
        ),
      ],
      isLoading: true,
    );

    try {
      final response = await apiClient.post(
        '/chat',
        {"message": text},
      );

      state = state.copyWith(
        messages: [
          ...state.messages,
          ChatMessage(
            role: ChatRole.assistant,
            content: response['reply'] ?? '',
          ),
        ],
        isLoading: false,
      );
    } catch (e) {
      state = state.copyWith(
        messages: [
          ...state.messages,
          ChatMessage(
            role: ChatRole.assistant,
            content:
            "Something went wrong. Please try again.",
          ),
        ],
        isLoading: false,
      );
    }
  }
}