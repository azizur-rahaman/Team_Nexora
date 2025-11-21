class ChatMessage {
  final String id;
  final String message;
  final bool isBot;
  final DateTime timestamp;
  final MessageType type;
  final List<QuickAction>? quickActions;
  final bool isTyping;

  const ChatMessage({
    required this.id,
    required this.message,
    required this.isBot,
    required this.timestamp,
    this.type = MessageType.text,
    this.quickActions,
    this.isTyping = false,
  });

  ChatMessage copyWith({
    String? id,
    String? message,
    bool? isBot,
    DateTime? timestamp,
    MessageType? type,
    List<QuickAction>? quickActions,
    bool? isTyping,
  }) {
    return ChatMessage(
      id: id ?? this.id,
      message: message ?? this.message,
      isBot: isBot ?? this.isBot,
      timestamp: timestamp ?? this.timestamp,
      type: type ?? this.type,
      quickActions: quickActions ?? this.quickActions,
      isTyping: isTyping ?? this.isTyping,
    );
  }
}

enum MessageType {
  text,
  suggestion,
  tips,
  recipe,
}

class QuickAction {
  final String id;
  final String label;
  final String icon;
  final String prompt;

  const QuickAction({
    required this.id,
    required this.label,
    required this.icon,
    required this.prompt,
  });
}

class ChatSession {
  final String id;
  final DateTime startedAt;
  final List<ChatMessage> messages;
  final int messageCount;

  const ChatSession({
    required this.id,
    required this.startedAt,
    required this.messages,
    required this.messageCount,
  });

  ChatSession copyWith({
    String? id,
    DateTime? startedAt,
    List<ChatMessage>? messages,
    int? messageCount,
  }) {
    return ChatSession(
      id: id ?? this.id,
      startedAt: startedAt ?? this.startedAt,
      messages: messages ?? this.messages,
      messageCount: messageCount ?? this.messageCount,
    );
  }
}
