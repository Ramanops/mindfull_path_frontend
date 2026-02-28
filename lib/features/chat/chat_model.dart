import 'dart:convert';

enum ChatRole { user, assistant }

class ChatMessage {
  final ChatRole role;
  final String content;
  final DateTime createdAt;

  ChatMessage({
    required this.role,
    required this.content,
    DateTime? createdAt,
  }) : createdAt = createdAt ?? DateTime.now();

  /// Helper: check if message is from user
  bool get isUser => role == ChatRole.user;

  /// Helper: check if message is from assistant
  bool get isAssistant => role == ChatRole.assistant;

  /// CopyWith (useful for updates)
  ChatMessage copyWith({
    ChatRole? role,
    String? content,
    DateTime? createdAt,
  }) {
    return ChatMessage(
      role: role ?? this.role,
      content: content ?? this.content,
      createdAt: createdAt ?? this.createdAt,
    );
  }

  /// Convert from JSON
  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      role: json['role'] == 'user'
          ? ChatRole.user
          : ChatRole.assistant,
      content: json['content'] ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'])
          : DateTime.now(),
    );
  }

  /// Convert to JSON (for API calls or storage)
  Map<String, dynamic> toJson() {
    return {
      'role': role.name,
      'content': content,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  /// Optional: Convert to raw JSON string
  String toRawJson() => jsonEncode(toJson());

  factory ChatMessage.fromRawJson(String str) =>
      ChatMessage.fromJson(jsonDecode(str));

  @override
  String toString() {
    return 'ChatMessage(role: ${role.name}, content: $content, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is ChatMessage &&
        other.role == role &&
        other.content == content &&
        other.createdAt == createdAt;
  }

  @override
  int get hashCode =>
      role.hashCode ^ content.hashCode ^ createdAt.hashCode;
}